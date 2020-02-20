import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:number_rivia/features/number_triva/domain/entities/number_triva.dart';
import 'package:number_rivia/features/number_triva/domain/repositories/number_triva_repository.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:number_rivia/features/number_triva/domain/usecases/get_specific_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTrivaRepository {
}

void main() {
  GetSpecificNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetSpecificNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTriva = NumberTrivia(number: 1, text: 'test');

  test(
    'should get triva for the number from the repository',
    () async {
      // arange
      when(mockNumberTriviaRepository.getSpecificTrivia(any))
          .thenAnswer((_) async => Right(tNumberTriva));
      // act
      final result = await usecase(Params(number: tNumber));
      // assert
      expect(result, Right(tNumberTriva));
      verify(mockNumberTriviaRepository.getSpecificTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
