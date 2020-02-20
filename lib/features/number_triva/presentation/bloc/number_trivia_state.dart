part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loaded extends NumberTriviaState {
  Loaded({@required this.trivia});

  @override
  List<Object> get props => [];
  final NumberTrivia trivia;
}

class Error extends NumberTriviaState {
  Error({@required this.message});
  @override
  List<Object> get props => [];
  final String message;
}
