import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as Math;

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
    resultController.text = "";
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

  bool hasConsecutiveMinusSigns(String text, int position) {
    // Check if there are already 2 consecutive minus signs
    if (position >= 2) {
      return text[position - 1] == '-' && text[position - 2] == '-';
    }
    return false;
  }

  bool isLastCharDecimalPoint(String text) {
    if (text.isEmpty) return false;
    return text[text.length - 1] == '.';
  }

  void handleButtonPress(String buttonText) {
    print('Button pressed: $buttonText');

    if (buttonText == 'C') {
      inputController.text = inputController.text.isNotEmpty && inputController.text.length != 1
          ? inputController.text.substring(0, inputController.text.length - 1)
          : '0';
      updateTemporaryResult(); // Update result after backspace
    } 
    else if (buttonText == 'AC') {
      inputController.text = '0';
      resultController.text = '';
    } 
    else if (buttonText == '=') {
      if (inputController.text.isNotEmpty && !isInitialState()) {
        try {
          String expression = inputController.text.replaceAll('\n', '');
          
          List<ExpressionPart> numbers = [];
          List<String> operators = [];
          
          String currentNumber = '';
          bool isNegative = false;
          
          for (int i = 0; i < expression.length; i++) {
            String char = expression[i];
            
            if (isDigit(char) || char == '.') {
              currentNumber += char;
            } 
            else if (char == '-') {
              if (i == 0 || isOperator(expression[i-1])) {
                isNegative = true;
              } 
              else {
                if (currentNumber.isNotEmpty) {
                  numbers.add(ExpressionPart(currentNumber, isNegative: isNegative));
                  currentNumber = '';
                  isNegative = false;
                }
                operators.add(char);
              }
            }
            else if (isOperator(char)) {
              if (currentNumber.isNotEmpty) {
                numbers.add(ExpressionPart(currentNumber, isNegative: isNegative));
                currentNumber = '';
                isNegative = false;
              }
              operators.add(char);
            }
          }
          
          if (currentNumber.isNotEmpty) {
            numbers.add(ExpressionPart(currentNumber, isNegative: isNegative));
          }
          
          int i = 0;
          while (i < operators.length) {
            if (operators[i] == '*' || operators[i] == '/') {
              if (operators[i] == '*') {
                double result = numbers[i].toDouble() * numbers[i + 1].toDouble();
                numbers[i] = ExpressionPart(result.abs().toString(), isNegative: result < 0);
              } else if (operators[i] == '/') {
                if (numbers[i + 1].toDouble() == 0) {
                  setState(() {
                    showGochaImage = true;
                  });
                  Timer(Duration(seconds: 1), () {
                    setState(() {
                      showGochaImage = false;
                    });
                  });
                  inputController.text = '0';
                  resultController.text = '';
                  print("You really thought you could divide by zero? Gocha!");
                  return;
                }
                double result = numbers[i].toDouble() / numbers[i + 1].toDouble();
                numbers[i] = ExpressionPart(result.abs().toString(), isNegative: result < 0);
              }
              
              numbers.removeAt(i + 1);
              operators.removeAt(i);
            } else {
              i++;
            }
          }
          
          if (numbers.isNotEmpty) {
            double result = numbers[0].toDouble();
            
            for (int i = 0; i < operators.length; i++) {
              if (operators[i] == '+') {
                result += numbers[i + 1].toDouble();
              } else if (operators[i] == '-') {
                result -= numbers[i + 1].toDouble();
              }
            }
            
            String resultString = result.toString();
            if (resultString.contains('.') && double.parse(resultString) == double.parse(resultString).truncateToDouble()) {
              resultString = double.parse(resultString).truncate().toString();
            }
            
            if (resultString == "Infinity" || resultString == "NaN") {
              setState(() {
                showGochaImage = true;
              });
              Timer(Duration(seconds: 1), () {
                setState(() {
                  showGochaImage = false;
                });
              });
              inputController.text = '0';
              resultController.text = '';
              print("You really thought you could divide by zero? Gocha!");
              return;
            }
            
            inputController.text = resultString;
            resultController.text = '';
          } else {
            inputController.text = '0';
            resultController.text = '';
          }
        }
        catch (e) {
          print("Calculation error: $e");
          resultController.text = '';
        }
      }
    } 
    else if (buttonText == ' ') {
      // Toggle Roman Numerals if doable
    }
    else if (buttonText == '-') {
      if (isInitialState()) {
        inputController.text = buttonText;
        return;
      }
      
      // Prevent adding minus after a decimal point
      if (isLastCharDecimalPoint(inputController.text)) {
        return;
      }
      
      String currentInput = inputController.text;
      int length = currentInput.length;
      
      if (length > 0 && currentInput[length - 1] == '-') {
        if ((length >= 2 && isOperator(currentInput[length - 2])) || length == 1) {
          return;
        }
      }
      
      if (length > 0 && isOperator(currentInput[length - 1])) {
        inputController.text += buttonText;
        return;
      }
      
      inputController.text += buttonText;
    }
    else if (buttonText == '.' &&isInitialState()) {
        inputController.text = "0.";
        return;
    }
    else {
      if (isInitialState() && (isDigit(buttonText) || buttonText == '.') && buttonText != '00') {
        inputController.text = buttonText;
        resultController.text = '';
      }
      else if (isOperator(buttonText) && (inputController.text.isNotEmpty && !isInitialState()
            && !isOperator(inputController.text[inputController.text.length - 1]))) {
        if (isLastCharDecimalPoint(inputController.text)) {
          return;
        }
        inputController.text += buttonText;
      }
      else if (buttonText == '.') {
        
        String currentInput = inputController.text;
        int lastOperatorIndex = -1;
        
        for (int i = currentInput.length - 1; i >= 0; i--) {
          if (isOperator(currentInput[i])) {
            lastOperatorIndex = i;
            break;
          }
        }
        
        String currentNumber = lastOperatorIndex == -1 
            ? currentInput 
            : currentInput.substring(lastOperatorIndex + 1);
        
        if (!currentNumber.contains('.')) {
          if (currentNumber.isEmpty) {
            inputController.text += '0';
          }
          inputController.text += buttonText;
          updateTemporaryResult();
        }
      }
      else if (!isOperator(buttonText) && !isInitialState() && buttonText != '.') {
        inputController.text += buttonText;
        updateTemporaryResult();
      }
    }
  }
  
  void updateTemporaryResult() {
    String expression = inputController.text;
    
    if (!hasOperatorAndNumberAfter(expression)) {
      resultController.text = '';
      return;
    }
    try {
      List<ExpressionPart> numbers = [];
      List<String> operators = [];
      
      String currentNumber = '';
      bool isNegative = false;
      
      for (int i = 0; i < expression.length; i++) {
        String char = expression[i];
        
        if (isDigit(char) || char == '.') {
          currentNumber += char;
        } 
        else if (char == '-') {
          if (i == 0 || isOperator(expression[i-1])) {
            isNegative = true;
          } 
          else {
            if (currentNumber.isNotEmpty) {
              numbers.add(ExpressionPart(currentNumber, isNegative: isNegative));
              currentNumber = '';
              isNegative = false;
            }
            operators.add(char);
          }
        }
        else if (isOperator(char)) {
          if (currentNumber.isNotEmpty) {
            numbers.add(ExpressionPart(currentNumber, isNegative: isNegative));
            currentNumber = '';
            isNegative = false;
          }
          operators.add(char);
        }
      }
      if (currentNumber.isNotEmpty) {
        numbers.add(ExpressionPart(currentNumber, isNegative: isNegative));
      }
      if (numbers.isEmpty || (numbers.length - operators.length) > 1) {
        resultController.text = '';
        return;
      }
      int i = 0;
      while (i < operators.length) {
        if (operators[i] == '*' || operators[i] == '/') {
          if (operators[i] == '*') {
            double result = numbers[i].toDouble() * numbers[i + 1].toDouble();
            numbers[i] = ExpressionPart(result.abs().toString(), isNegative: result < 0);
          } else if (operators[i] == '/') {
            if (numbers[i + 1].toDouble() == 0) {
              resultController.text = 'Error: Division by zero';
              return;
            }
            double result = numbers[i].toDouble() / numbers[i + 1].toDouble();
            numbers[i] = ExpressionPart(result.abs().toString(), isNegative: result < 0);
          }
          
          numbers.removeAt(i + 1);
          operators.removeAt(i);
        } else {
          i++;
        }
      }
      if (numbers.isNotEmpty) {
        double result = numbers[0].toDouble();
        
        for (int i = 0; i < operators.length; i++) {
          if (operators[i] == '+') {
            result += numbers[i + 1].toDouble();
          } else if (operators[i] == '-') {
            result -= numbers[i + 1].toDouble();
          }
        }
        String resultString = result.toString();
        if (resultString.contains('.') && double.parse(resultString) == double.parse(resultString).truncateToDouble()) {
          resultString = double.parse(resultString).truncate().toString();
        }
        
        resultController.text = resultString;
      }
    }
    catch (e) {
      print("Temporary calculation error: $e");
    }
  }
  
  bool hasOperatorAndNumberAfter(String expression) {
    bool hasOperator = false;
    
    for (int i = 0; i < expression.length; i++) {
      if (isOperator(expression[i])) {
        hasOperator = true;
      } else if (hasOperator && (isDigit(expression[i]) || expression[i] == '.')) {
        return true;
      }
    }
    return false;
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

// Add this class after the _MyHomePageState class declaration
class ExpressionPart {
  String value;
  bool isNegative;
  
  ExpressionPart(this.value, {this.isNegative = false});
  
  double toDouble() {
    double val = double.parse(value);
    return isNegative ? -val : val;
  }
  
  @override
  String toString() {
    return isNegative ? '-$value' : value;
  }
}
