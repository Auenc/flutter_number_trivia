import 'package:dartz/dartz.dart';
import 'package:number_rivia/core/error/failures.dart';
import 'package:number_rivia/features/number_triva/domain/entities/number_triva.dart';

abstract class NumberTrivaRepository {
  Future<Either<Failure, NumberTrivia>> getSpecificTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomTriva();
}
