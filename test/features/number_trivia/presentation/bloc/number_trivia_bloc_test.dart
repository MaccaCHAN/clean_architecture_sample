import 'package:clean_architecture_sample/core/error/failure.dart';
import 'package:clean_architecture_sample/core/usecases/usecase.dart';
import 'package:clean_architecture_sample/core/util/input_converter.dart';
import 'package:clean_architecture_sample/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_sample/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_sample/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_sample/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      inputConverter: mockInputConverter,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
    );
    registerFallbackValue(Params(number: 1));
    registerFallbackValue(NoParams());

  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(NumberTriviaInitial()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(()=> mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(()=>mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(()=>mockInputConverter.stringToUnsignedInteger(any()));
        // assert
        verify(()=>mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    blocTest('should emit [Error] when the input is invalid',
        build: () => bloc,
        setUp: (){ when(()=>mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));}    ,
        act: (NumberTriviaBloc bloc) {
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
        expect: () => [NumberTriviaLoading(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE)]
    );

      test(
      'should get data from the concrete use case',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(()=>mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(()=>mockGetConcreteNumberTrivia(any()));
        // assert
        verify(()=>mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
        expect(await mockGetConcreteNumberTrivia(Params(number: tNumberParsed)), equals(Right(tNumberTrivia)));
      },
    );

    blocTest('should get data from the concrete use case_',
        build: ()=> bloc,
        setUp: () { setUpMockInputConverterSuccess();
        when(()=>mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Right(tNumberTrivia));},
        act: (NumberTriviaBloc bloc) async{
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(()=>mockGetConcreteNumberTrivia(any()));
        },
        verify: (NumberTriviaBloc bloc) {
                mockGetConcreteNumberTrivia(Params(number: tNumberParsed));},
    );

    blocTest(
      'Concrete: should emit [Loading, Loaded] when data is gotten successfully',
       build: () => (bloc),
       act: (NumberTriviaBloc bloc) {
         setUpMockInputConverterSuccess();
         when(()=>mockGetConcreteNumberTrivia(Params(number: 1)))
             .thenAnswer((_) async => Right(tNumberTrivia));
         bloc.add(GetTriviaForConcreteNumber(tNumberString));
       } ,
       expect: () =>
         [ NumberTriviaLoading(),
           NumberTriviaLoaded(trivia: tNumberTrivia),
         ],
    );

    test(
      'should emit [Loading, Error] when getting data fails',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(()=>mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(()=>mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
          () async {
        // arrange
        when(()=>mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(()=>mockGetRandomNumberTrivia(any()));
        // assert
        verify(()=>mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        when(()=>mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
          () async {
        // arrange
        when(()=>mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
        // arrange
        when(()=>mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}