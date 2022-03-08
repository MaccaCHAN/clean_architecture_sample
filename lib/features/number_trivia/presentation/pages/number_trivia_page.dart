import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_display.dart';


class NumberTriviaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context)  {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  // Top half
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is NumberTriviaInitial) {
                        return Container(
                          // Third of the size of the screen
                          height: MediaQuery.of(context).size.height / 3,
                          // Message Text widgets / CircularLoadingIndicator
                          child: Center(child: Text('Start searching!')),
                        );
                      } else if (state is NumberTriviaLoading) {
                        return LoadingWidget();
                      } else if (state is NumberTriviaLoaded) {
                        return TriviaDisplay(
                          numberTrivia: state.trivia,
                        );
                      }
                      else if (state is Error)
                      {
                        return MessageDisplay(
                          message: state.message,
                        );
                      }
                      else {
                        return SizedBox();}
                    },
                  ),
                  const SizedBox(height: 20),
                  // Bottom half
                  TriviaControls()
                ],
              ),
            ),
          ),
      ),
      );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // TextField
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
            print(inputStr);
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              // Search concrete button
              child: ElevatedButton(
                child: Text('Search'),
                onPressed: () { dispatchConcrete();},
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              // Random button
              child: ElevatedButton(
                       child: Text('Get random trivia'),
                    onPressed: dispatchRandom,
                ),
            )
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    // Clearing the TextField to prepare it for the next inputted number
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForRandomNumber());
  }
}




