import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:number_rivia/core/error/failures.dart';
import 'package:number_rivia/features/number_triva/domain/entities/number_triva.dart';
import 'package:number_rivia/features/number_triva/domain/repositories/number_triva_repository.dart';

class GetSpecificNumberTrivia {
  final NumberTrivaRepository repository;
  GetSpecificNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getSpecificTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  Params({@required this.number});
  get props {
    return [number];
  }
}
