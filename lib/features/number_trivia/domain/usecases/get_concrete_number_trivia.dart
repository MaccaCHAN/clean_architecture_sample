import 'package:clean_architecture_sample/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

import '../repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/number_trivia.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call (Params params,
  ) async {
    int number = params.number;
    return await repository.getConcreteNumberTrivia(number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  // TODO: implement props
  List<Object?> get props => [];


}