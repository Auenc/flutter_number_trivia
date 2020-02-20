import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:number_rivia/core/error/exceptions.dart';
import 'package:number_rivia/core/error/failures.dart';
import 'package:number_rivia/core/network/network_info.dart';
import 'package:number_rivia/features/number_triva/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_rivia/features/number_triva/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_rivia/features/number_triva/domain/entities/number_triva.dart';
import 'package:number_rivia/features/number_triva/domain/repositories/number_triva_repository.dart';

typedef Future<NumberTrivia> _SpecificOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTrivaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.localDataSource,
      @required this.remoteDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getRandomTriva() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomTriva();
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getSpecificTrivia(int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getSpecificTrivia(number);
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _SpecificOrRandomChooser getSpecificOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getSpecificOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
