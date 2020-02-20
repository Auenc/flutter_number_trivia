import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_rivia/core/error/failures.dart';
import 'package:number_rivia/core/usecases/usecase.dart';
import 'package:number_rivia/features/number_triva/domain/entities/number_triva.dart';
import 'package:number_rivia/features/number_triva/domain/repositories/number_triva_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTrivaRepository repository;
  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomTriva();
  }
}
