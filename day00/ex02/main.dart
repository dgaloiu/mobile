import 'package:flutter/material.dart';
import 'dart:developer' as developer;

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
    developer.log('Button pressed: $buttonText');
    if (inputController.text == '0') {
      inputController.text = buttonText;
    } else {
      inputController.text += buttonText;
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Color.fromRGBO(218, 165, 32, 1),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.5,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/temple.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: inputController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 20, color: Color.fromRGBO(218, 165, 32, 1)),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: resultController,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 20, color: Color.fromRGBO(218, 165, 32, 1)),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.all(constraints.maxWidth * 0.01),
                    child: LayoutBuilder(
                      builder: (context, gridConstraints) {
                        final double cellWidth = gridConstraints.maxWidth / 5;
                        final double cellHeight = gridConstraints.maxHeight / 4;
                        final double aspectRatio = cellWidth / cellHeight;
                        
                        return GridView.builder(
                          shrinkWrap: true,
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
                                  borderRadius: BorderRadius.circular(5),
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
              ),
            ],
          );
        }
      ),
    );
  }
}
