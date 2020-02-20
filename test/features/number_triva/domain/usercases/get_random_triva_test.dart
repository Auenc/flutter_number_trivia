import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:number_rivia/core/usecases/usecase.dart';
import 'package:number_rivia/features/number_triva/domain/entities/number_triva.dart';
import 'package:number_rivia/features/number_triva/domain/repositories/number_triva_repository.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:number_rivia/features/number_triva/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTrivaRepository {
}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTriva = NumberTrivia(number: 1, text: 'test');

  test(
    'should get triva from the repository',
    () async {
      // arange
      when(mockNumberTriviaRepository.getRandomTriva())
          .thenAnswer((_) async => Right(tNumberTriva));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tNumberTriva));
      verify(mockNumberTriviaRepository.getRandomTriva());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
