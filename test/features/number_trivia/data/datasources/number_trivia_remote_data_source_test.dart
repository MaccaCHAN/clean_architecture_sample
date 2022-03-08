import 'dart:convert';

import 'package:clean_architecture_sample/core/error/exceptions.dart';
import 'package:clean_architecture_sample/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_sample/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';


class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(Uri.parse('http://numbersapi.com/1'));
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));


    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
          () {
        //arrange
        when(()=> mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
              (_) async => http.Response(fixture('trivia.json'), 200),
        );
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(()=> mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
          () async {
        // arrange
        when(()=>mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
              (_) async => http.Response(fixture('trivia.json'), 200),
        );
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        when(()=>mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
              (_) async => http.Response('Something went wrong', 404),
        );
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );

  });

}