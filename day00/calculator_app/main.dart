import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController inputController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  bool showGochaImage = false;

  final List<String> buttonLabels = [
    '7', '8', '9', 'C', 'AC',
    '4', '5', '6', '+', '-',
    '1', '2', '3', '*', '/',
    '0', '.', '00', '=', ' '
  ];

  @override
  void initState() {
    super.initState();
    inputController.text = "0";
    resultController.text = "0";
  }

  @override
  void dispose() {
    inputController.dispose();
    resultController.dispose();
    super.dispose();
  }

  bool isOperator(String buttonText) {
    return ['+', '-', '*', '/'].contains(buttonText);
  }

  bool isDigit(String buttonText) {
    return ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(buttonText);
  }

  bool isInitialState() {
    return inputController.text == '0';
  }

  void handleButtonPress(String buttonText) {
    print('Button pressed: $buttonText');

    if (buttonText == 'C') {
      inputController.text = inputController.text.isNotEmpty && inputController.text.length != 1
          ? inputController.text.substring(0, inputController.text.length - 1)
          : '0';
    } 
    else if (buttonText == 'AC') {
      inputController.text = '0';
      resultController.text = '0';
    } 

    else if (buttonText == '=') { // manage negative numbers
      if (inputController.text.isNotEmpty && !isInitialState()) {
        try {
          String expression = inputController.text.replaceAll('\n', '');
          List parts = expression.split(RegExp(r'(\+|\-|\*|\/)'));
          String operators = expression.replaceAll(RegExp(r'[0-9]'), '');
          String result = '';
          String firstPart = parts[0];

          if(parts.length != 1){
            for (int i = 1; i < parts.length; i++) {

              String operator = operators[i - 1];
              String secondPart = parts[i];
              if (operator == '+' || operator == '-'){
                if (i == parts.length - 1) {
                  result += double.parse(firstPart).toString()+operator+double.parse(secondPart).toString();
                }
                else {
                  result += double.parse(firstPart).toString() + operator;
                }
                firstPart = secondPart;
              }
              else if (operator == '*') {
                String tmp= (double.parse(firstPart) * double.parse(secondPart)).toString();
                firstPart = tmp;
                if (i == parts.length - 1) {
                  result += double.parse(firstPart).toString();
                }
              }
              else if (operator == '/') {
                String tmp= (double.parse(firstPart) / double.parse(secondPart)).toString();
                firstPart = tmp;
                if (i == parts.length - 1) {
                  result += double.parse(firstPart).toString();
                }
              }
            }
          }
          else {
            result = firstPart;
          }

          parts = result.split(RegExp(r'(\+|\-)'));
          operators = result.replaceAll(RegExp(r'[0-9]'), '');
          result = parts[0];
          if(parts.length != 1){
            result = parts[0];
            for (int i = 1; i < parts.length;i++){
              String operator = operators[i - 1];
              if (operator == '+'){
                result = (double.parse(result) + double.parse(parts[i])).toString();
              }
              else if (operator == '-'){
                result = (double.parse(result) - double.parse(parts[i])).toString();
              }
            }
          }

          if (result.contains('.') && result.substring(result.indexOf('.')) == '.0') {
            result = result.substring(0, result.indexOf('.'));
          }
          else if (result=="Infinity") {
            setState(() {
              showGochaImage = true;
            });
            Timer(Duration(seconds: 1), () {
              setState(() {
                showGochaImage = false;
              });
            });
            inputController.text = '0';
            result = '0';
            print("You really thought you could divide by zero? Gocha!");
          }
          resultController.text = result;
        }
        catch (e) {
          resultController.text = 'Error';
        }
      }
    } 

    else if (buttonText == ' ') {
      // Toggle Roman Numerals if doable
    }

    else { //manage negative numbers
      if (isInitialState() && (isDigit(buttonText) /*|| buttonText=='-'*/) && buttonText != '00') {
        inputController.text = buttonText;
      }
      else if (isOperator(buttonText) && (inputController.text.isNotEmpty && !isInitialState()
            && !isOperator(inputController.text[inputController.text.length - 1]))) {
          inputController.text += buttonText;
      }
      else if (buttonText == '.' && !inputController.text.contains('.')) { //handle mutliple float numbers
          inputController.text += buttonText;
          }
      else if (!isOperator(buttonText) && !isInitialState() && buttonText != '.') { //limit to 15 digits
        inputController.text += buttonText;
      }
    }
  }

  Color getButtonColor(String buttonText) {
    if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '00', '.'].contains(buttonText)) {
      return Color.fromRGBO(218, 165, 32, 1);
    } else if (['+', '-', '*', '/', '='].contains(buttonText)) {
      return Colors.white;
    } else {
      return Colors.deepOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fontSize = 20;
    final Color goldColor = const Color.fromRGBO(218, 165, 32, 1);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: goldColor, width: 4.0),
              top: BorderSide(color: goldColor, width: 4.0),
              right: BorderSide(color: goldColor, width: 4.0),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: goldColor,
            title: Text(widget.title),
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: goldColor, width: 4.0),
                      right: BorderSide(color: goldColor, width: 4.0),
                      bottom: BorderSide(color: goldColor, width: 4.0),
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/temple.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            controller: inputController,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: goldColor,
                              shadows: const [Shadow(color: Colors.black, offset: Offset(1, 1))],
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Flexible(
                          child: TextField(
                            controller: resultController,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: goldColor,
                              shadows: const [Shadow(color: Colors.black, offset: Offset(1, 1))],
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              Expanded(
                flex: 1,
                child: Container(
                decoration: BoxDecoration(
                  color:goldColor,
                  border: Border(
                    left: BorderSide(color: goldColor, width: 4.0),
                    right: BorderSide(color: goldColor, width: 4.0),
                    top: BorderSide(color: goldColor, width: 4.0),
                    bottom: BorderSide(color: goldColor, width: 4.0),
                    ),
                  ),
                  width: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, gridConstraints) {
                      final double cellWidth = gridConstraints.maxWidth / 5;
                      final double cellHeight = gridConstraints.maxHeight / 4;
                      final double aspectRatio = cellWidth / cellHeight;
                      
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 20,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: aspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                            onPressed: () => handleButtonPress(buttonLabels[index]),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: getButtonColor(buttonLabels[index]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                buttonLabels[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (showGochaImage)
            Center(
              child: Image.asset(
                'assets/images/gocha.jpeg',
                width: 200,
                height: 200,
              ),
            ),
        ],
      ),
    );
  }
}
