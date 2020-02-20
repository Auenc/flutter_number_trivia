import 'dart:convert';

import 'package:number_rivia/core/error/exceptions.dart';
import 'package:number_rivia/features/number_triva/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getSpecificTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getRandomTriva();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getRandomTriva() async =>
      this._getTriviaFromURL('http://numbersapi.com/random');

  @override
  Future<NumberTriviaModel> getSpecificTrivia(int number) async =>
      this._getTriviaFromURL('http://numbersapi.com/$number');

  Future<NumberTriviaModel> _getTriviaFromURL(String url) async {
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    return throw ServerException();
  }
}
