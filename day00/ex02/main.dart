import 'package:flutter/material.dart';

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

  void handleButtonPress(String buttonText) {
    print('Button pressed: $buttonText');
    if (buttonText == 'C') {
      inputController.text = inputController.text.isNotEmpty && inputController.text.length != 1
          ? inputController.text.substring(0, inputController.text.length - 1)
          : '0';
    } else if (buttonText == 'AC') {
      inputController.text = '0';
      resultController.text = '0';
    } else if (buttonText == '=') {
      resultController.text = inputController.text;
    } else {
      if (inputController.text == '0' &&
          ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(buttonText)) {
        inputController.text = buttonText;
      } else if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(buttonText)) {
        inputController.text += buttonText;
      }
    }
  }

  Color getButtonColor(String buttonText) {
    if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '00', '.'].contains(buttonText)) {
      return Colors.black;
    } else if (['+', '-', '*', '/', '='].contains(buttonText)) {
      return Colors.white;
    } else {
      return Colors.deepOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final double fontSize = 20;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Color.fromRGBO(218, 165, 32, 1),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: orientation == AssetImage('assets/images/temple_h.png'),
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
                          color: const Color.fromRGBO(218, 165, 32, 1),
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
                          color: const Color.fromRGBO(218, 165, 32, 1),
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
              width: double.infinity,
              color: Colors.black,
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
                          backgroundColor: Color.fromRGBO(218, 165, 32, 1),
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
    );
  }
}
