import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_rivia/features/number_triva/data/models/number_trivia_model.dart';
import 'package:number_rivia/features/number_triva/domain/entities/number_triva.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a subclass of number trivia entitity', () async {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return valid model when json number is integer', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should return valid model when json number is regarded as a double',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });
  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectedMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
