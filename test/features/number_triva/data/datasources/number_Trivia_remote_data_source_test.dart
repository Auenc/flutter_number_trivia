import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_rivia/core/error/exceptions.dart';
import 'package:number_rivia/features/number_triva/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_rivia/features/number_triva/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure500() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 500));
  }

  group('getSpecificNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL with a number being at the endpoint and with application/json header',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getSpecificTrivia(tNumber);
      // assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the success code is 200', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getSpecificTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      // arrange
      setUpMockHttpClientFailure500();
      // act
      final call = dataSource.getSpecificTrivia;
      // assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL with a number being at the endpoint and with application/json header',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getRandomTriva();
      // assert
      verify(mockHttpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the success code is 200', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomTriva();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      // arrange
      setUpMockHttpClientFailure500();
      // act
      final call = dataSource.getRandomTriva;
      // assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
