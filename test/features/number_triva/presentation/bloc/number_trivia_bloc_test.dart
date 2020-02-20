import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:number_rivia/core/error/failures.dart';
import 'package:number_rivia/core/usecases/usecase.dart';
import 'package:number_rivia/core/util/input_converter.dart';
import 'package:number_rivia/features/number_triva/domain/entities/number_triva.dart';
import 'package:number_rivia/features/number_triva/domain/usecases/get_random_number_trivia.dart';
import 'package:number_rivia/features/number_triva/domain/usecases/get_specific_number_trivia.dart';
import 'package:number_rivia/features/number_triva/presentation/bloc/number_trivia_bloc.dart';

class MockGetSpecificNumberTrivia extends Mock
    implements GetSpecificNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetSpecificNumberTrivia mockGetSpecificNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetSpecificNumberTrivia = MockGetSpecificNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        specific: mockGetSpecificNumberTrivia,
        random: mockGetRandomNumberTrivia,
        converter: mockInputConverter);
  });

  test('should be empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('getTriviaForSpecificNumber', () {
    final tNumberString = "1";
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(Right(tNumberParsed));
    }

    test(
        'should call the input converter to validate and convert the string to an unsgined integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      bloc.add(GetTriviaForSpecificNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid.', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(Left(InvalidInputFailure()));
      // act
      // assert
      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetTriviaForSpecificNumber(tNumberString));
    });

    test('should get data from the specific user case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetSpecificNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForSpecificNumber(tNumberString));
      await untilCalled(mockGetSpecificNumberTrivia(any));
      // assert
      verify(mockGetSpecificNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetSpecificNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // assert later
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForSpecificNumber(tNumberString));
    });

    test('should emit [Loading, Error] when data is getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetSpecificNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForSpecificNumber(tNumberString));
    });

    test(
        'should emit [Loading, Error] with the proper message when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetSpecificNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForSpecificNumber(tNumberString));
    });
  });

  group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

    test('should get data from the specific user case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // assert later
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when data is getting data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with the proper message when getting data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
