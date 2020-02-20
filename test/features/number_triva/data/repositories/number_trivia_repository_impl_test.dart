import 'package:dartz/dartz.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:mockito/mockito.dart';
import 'package:number_rivia/core/error/exceptions.dart';
import 'package:number_rivia/core/error/failures.dart';
import 'package:number_rivia/core/network/network_info.dart';
import 'package:number_rivia/features/number_triva/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_rivia/features/number_triva/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_rivia/features/number_triva/data/models/number_trivia_model.dart';
import 'package:number_rivia/features/number_triva/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_rivia/features/number_triva/domain/entities/number_triva.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getSpecificNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getSpecificTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getSpecificTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getSpecificTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getSpecificTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache data locally when call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getSpecificTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getSpecificTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getSpecificTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getSpecificTrivia(any))
            .thenThrow(ServerException());
        // act
        final result = await repository.getSpecificTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getSpecificTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    runTestsOffline(() {
      test('should return last locally cached data when cached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getSpecificTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is nocached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getSpecificTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getRandomTriva();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomTriva())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomTriva();
        // assert
        verify(mockRemoteDataSource.getRandomTriva());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache data locally when call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomTriva())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getRandomTriva();
        // assert
        verify(mockRemoteDataSource.getRandomTriva());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomTriva())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomTriva();
        // assert
        verify(mockRemoteDataSource.getRandomTriva());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    runTestsOffline(() {
      test('should return last locally cached data when cached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomTriva();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is nocached data is present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getRandomTriva();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
