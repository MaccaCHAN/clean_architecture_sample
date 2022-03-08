import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';


class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {

  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getRandomNumberTrivia,
    required this.getConcreteNumberTrivia,
    required this.inputConverter
  })
      : super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumber>(_mapGetTriviaForConcreteNumberToState);
    on<GetTriviaForRandomNumber>(_mapGetTriviaForRandomNumberToState);
  }


  Future<void> _mapGetTriviaForConcreteNumberToState
      (GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    // Immediately branching the logic with type checking, in order
    // for the event to be smart casted

    emit(NumberTriviaLoading());
    final inputEither =  inputConverter.stringToUnsignedInteger(event.numberString);

    /// remember to add await before Either.fold() if it has async function inside
    await inputEither.fold(
      //return left side
            (failure) {
          emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
        }
        //return right side
        , (integer) async {
      print('$integer got');
      final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
      print('$failureOrTrivia got');
       _eitherLoadedOrErrorState(failureOrTrivia, emit);
    }
    );
  }

  Future<void> _mapGetTriviaForRandomNumberToState
      (GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    // Immediately branching the logic with type checking, in order
    // for the event to be smart casted

    emit(NumberTriviaLoading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams(),);

    _eitherLoadedOrErrorState(failureOrTrivia, emit);
  }

  void _eitherLoadedOrErrorState(Either<Failure, NumberTrivia> either,
      Emitter<NumberTriviaState> emit)  {

     either.fold(
          (failure)  => emit (Error(message: _mapFailureToMessage(failure))),
          (trivia) {
            emit (NumberTriviaLoaded(trivia: trivia));
          } ,
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}