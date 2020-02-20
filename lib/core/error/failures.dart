import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List props = const <dynamic>[];
  Failure();
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
