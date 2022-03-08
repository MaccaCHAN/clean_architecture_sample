
import 'package:clean_architecture_sample/core/error/failure.dart';
import 'package:clean_architecture_sample/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {

  final NumberTriviaRepository repository;
  
  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call (NoParams params) async {
    // TODO: implement call
    return await repository.getRandomNumberTrivia();
  }
  
  
  
  
}