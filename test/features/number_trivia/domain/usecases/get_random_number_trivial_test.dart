import 'package:clean_architecture_sample/core/usecases/usecase.dart';
import 'package:clean_architecture_sample/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_sample/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_sample/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_sample/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;


  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  // const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  final noParams = NoParams();

  test(
    'should get trivia for the number from the repository',
        () async {
      //arrange
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      final result = await usecase(noParams);
      //assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );

}