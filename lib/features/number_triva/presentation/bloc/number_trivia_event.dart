part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetTriviaForSpecificNumber extends NumberTriviaEvent {
  GetTriviaForSpecificNumber(this.numberString);

  @override
  List<Object> get props => [numberString];
  final String numberString;
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  @override
  List<Object> get props => [];
}
