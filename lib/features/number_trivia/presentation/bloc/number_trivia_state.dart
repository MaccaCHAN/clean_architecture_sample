part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaState extends Equatable {

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {

}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia trivia;

  NumberTriviaLoaded({required this.trivia});
  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message});
  @override
  List<Object> get props => [message];
}