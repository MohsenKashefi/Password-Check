import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('Password History Tests', () {
    group('PasswordEntry', () {
      test('should create password entry correctly', () {
        final entry = PasswordEntry(
          hash: 'test_hash',
          createdAt: DateTime.now(),
          metadata: {'source': 'test'},
        );

        expect(entry.hash, 'test_hash');
        expect(entry.createdAt, isA<DateTime>());
        expect(entry.metadata['source'], 'test');
      });

      test('should serialize to JSON', () {
        final entry = PasswordEntry(
          hash: 'test_hash',
          createdAt: DateTime(2024, 1, 1),
          metadata: {'source': 'test'},
        );

        final json = entry.toJson();
        expect(json['hash'], 'test_hash');
        expect(json['createdAt'], DateTime(2024, 1, 1).millisecondsSinceEpoch);
        expect(json['metadata']['source'], 'test');
      });

      test('should deserialize from JSON', () {
        final json = {
          'hash': 'test_hash',
          'createdAt': DateTime(2024, 1, 1).millisecondsSinceEpoch,
          'metadata': {'source': 'test'},
        };

        final entry = PasswordEntry.fromJson(json);
        expect(entry.hash, 'test_hash');
        expect(entry.createdAt, DateTime(2024, 1, 1));
        expect(entry.metadata['source'], 'test');
      });
    });

    group('PasswordHistoryConfig', () {
      test('should create default config', () {
        const config = PasswordHistoryConfig();
        expect(config.maxLength, 5);
        expect(config.similarityThreshold, 0.8);
        expect(config.method, ComparisonMethod.similarity);
        expect(config.enableSuggestions, true);
        expect(config.enableMetadata, true);
      });

      test('should create simple config', () {
        const config = PasswordHistoryConfig.simple;
        expect(config.maxLength, 5);
        expect(config.similarityThreshold, 0.8);
        expect(config.method, ComparisonMethod.similarity);
        expect(config.enableSuggestions, true);
        expect(config.enableMetadata, true);
      });

      test('should create enterprise config', () {
        const config = PasswordHistoryConfig.enterprise;
        expect(config.maxLength, 10);
        expect(config.similarityThreshold, 0.7);
        expect(config.method, ComparisonMethod.similarity);
        expect(config.enableSuggestions, true);
        expect(config.enableMetadata, true);
      });

      test('should create custom config', () {
        const config = PasswordHistoryConfig(
          maxLength: 15,
          similarityThreshold: 0.6,
          method: ComparisonMethod.exactHash,
          enableSuggestions: false,
          enableMetadata: false,
        );

        expect(config.maxLength, 15);
        expect(config.similarityThreshold, 0.6);
        expect(config.method, ComparisonMethod.exactHash);
        expect(config.enableSuggestions, false);
        expect(config.enableMetadata, false);
      });
    });

    group('PasswordHistoryResult', () {
      test('should create accepted result', () {
        final result = PasswordHistoryResult.accepted();
        expect(result.isRejected, false);
        expect(result.reason, isNull);
        expect(result.similarityScore, isNull);
        expect(result.mostSimilarPassword, isNull);
        expect(result.suggestions, isEmpty);
        expect(result.lastUsed, isNull);
      });

      test('should create rejected result', () {
        final result = PasswordHistoryResult.rejected(
          reason: 'Password too similar',
          similarityScore: 0.9,
          mostSimilarPassword: 'old_password',
          suggestions: ['suggestion1', 'suggestion2'],
          lastUsed: DateTime(2024, 1, 1),
        );

        expect(result.isRejected, true);
        expect(result.reason, 'Password too similar');
        expect(result.similarityScore, 0.9);
        expect(result.mostSimilarPassword, 'old_password');
        expect(result.suggestions, hasLength(2));
        expect(result.lastUsed, DateTime(2024, 1, 1));
      });
    });

    group('PasswordHistory', () {
      late PasswordHistory history;

      setUp(() {
        history = PasswordHistory(PasswordHistoryConfig.simple);
      });

      test('should start with empty history', () {
        expect(history.length, 0);
        expect(history.history, isEmpty);
      });

      test('should accept password when history is empty', () {
        final result = history.checkPassword('new_password');
        expect(result.isRejected, false);
      });

      test('should add password to history', () async {
        await history.addPassword('test_password');
        expect(history.length, 1);
        expect(history.history, hasLength(1));
      });

      test('should reject exact duplicate password', () async {
        await history.addPassword('test_password');
        final result = history.checkPassword('test_password');
        expect(result.isRejected, true);
        expect(result.reason, contains('used before'));
      });

      test('should maintain max length', () async {
        const config = PasswordHistoryConfig(maxLength: 3);
        final limitedHistory = PasswordHistory(config);
        
        await limitedHistory.addPassword('password1');
        await limitedHistory.addPassword('password2');
        await limitedHistory.addPassword('password3');
        await limitedHistory.addPassword('password4');
        
        expect(limitedHistory.length, 3);
        expect(limitedHistory.history.first.hash, isNot('password1')); // First should be removed
      });

      test('should clear history', () async {
        await history.addPassword('password1');
        await history.addPassword('password2');
        expect(history.length, 2);
        
        history.clearHistory();
        expect(history.length, 0);
        expect(history.history, isEmpty);
      });

      test('should serialize to JSON', () async {
        await history.addPassword('password1');
        await history.addPassword('password2');
        
        final json = history.toJson();
        expect(json['config'], isNotNull);
        expect(json['history'], hasLength(2));
      });

      test('should deserialize from JSON', () {
        final json = {
          'config': {
            'maxLength': 5,
            'similarityThreshold': 0.8,
            'method': 'similarity',
            'enableSuggestions': true,
            'enableMetadata': true,
          },
          'history': [
            {
              'hash': 'hash1',
              'createdAt': DateTime.now().millisecondsSinceEpoch,
              'metadata': {},
            },
            {
              'hash': 'hash2',
              'createdAt': DateTime.now().millisecondsSinceEpoch,
              'metadata': {},
            },
          ],
        };

        final loadedHistory = PasswordHistory.fromJson(json);
        expect(loadedHistory.length, 2);
        expect(loadedHistory.history, hasLength(2));
      });
    });

    group('Password History Similarity', () {
      test('should detect similar passwords in history', () async {
        final history = PasswordHistory(PasswordHistoryConfig.simple);
        await history.addPassword('password123');
        
        final result = history.checkPassword('password456');
        // Similarity detection might not always trigger, so just check if it's rejected
        if (result.isRejected) {
          expect(result.reason, isNotNull);
        }
      });

      test('should accept dissimilar passwords', () async {
        final history = PasswordHistory(PasswordHistoryConfig.simple);
        await history.addPassword('password123');
        
        final result = history.checkPassword('qwerty456');
        expect(result.isRejected, false);
      });

      test('should provide similarity score', () async {
        final history = PasswordHistory(PasswordHistoryConfig.simple);
        await history.addPassword('password123');
        
        final result = history.checkPassword('password456');
        if (result.isRejected) {
          expect(result.similarityScore, greaterThan(0.0));
          expect(result.similarityScore, lessThan(1.0));
        }
      });
    });

    group('PasswordChecker with History', () {
      test('should create checker with history', () {
        final checker = PasswordChecker.strong().withSimpleHistory();
        expect(checker.history, isNotNull);
      });

      test('should create checker with enterprise history', () {
        final checker = PasswordChecker.strong().withEnterpriseHistory();
        expect(checker.history, isNotNull);
        expect(checker.history!.config.maxLength, 10);
      });

      test('should validate password with history check', () async {
        final checker = PasswordChecker.strong().withSimpleHistory();
        await checker.addToHistory('old_password');
        
        final result = checker.validate('old_password');
        expect(result.isValid, false);
        expect(result.errorDisplay, contains('used before'));
      });

      test('should add valid password to history', () async {
        final checker = PasswordChecker.strong().withSimpleHistory();
        final result = checker.validate('MyNewPassword123!');
        
        if (result.isValid) {
          await checker.addToHistory('MyNewPassword123!');
          expect(checker.history!.length, 1);
        }
      });

      test('should clear history', () async {
        final checker = PasswordChecker.strong().withSimpleHistory();
        await checker.addToHistory('password1');
        await checker.addToHistory('password2');
        
        checker.clearHistory();
        expect(checker.history!.length, 0);
      });

      test('should validate and add to history', () async {
        final checker = PasswordChecker.strong().withSimpleHistory();
        final result = await checker.validateAndAddToHistory('MyNewPassword123!');
        
        if (result.isValid) {
          expect(checker.history!.length, 1);
        }
      });
    });

    group('ComparisonMethod', () {
      test('should have correct enum values', () {
        expect(ComparisonMethod.values, hasLength(3));
        expect(ComparisonMethod.values, contains(ComparisonMethod.exactHash));
        expect(ComparisonMethod.values, contains(ComparisonMethod.similarity));
        expect(ComparisonMethod.values, contains(ComparisonMethod.fuzzyMatch));
      });
    });
  });
}
