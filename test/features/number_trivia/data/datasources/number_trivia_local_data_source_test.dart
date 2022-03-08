import 'dart:convert';

import 'package:clean_architecture_sample/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_sample/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
          () async {
        // arrange
        when(()=>mockSharedPreferences.getString(any()))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(()=>mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
        expect(result, equals(tNumberTriviaModel));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel(number: 1, text: 'test trivia');

    test('should call SharedPreferences to cache the data', () {
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

      when(()=>mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA,
         expectedJsonString)).thenAnswer((_) => Future.value(true));
      // act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      verify(()=>mockSharedPreferences.setString(
        CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });

}