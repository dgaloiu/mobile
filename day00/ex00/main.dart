import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ex00',
      theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(250, 241, 217, 1)),
      ),
      home: const MyHomePage(title: 'NavBar'),
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
  bool _isImageVisible = false;
  double _imageLeft = 0;
  double _imageTop = 0;
  Timer? _timer;

  void buttonPressed() {
    print('Button pressed');
    
    final screenSize = MediaQuery.of(context).size;
    final random = Random();
    
    setState(() {
      _imageLeft = random.nextDouble() * (screenSize.width - (min(screenSize.width, screenSize.height) * 0.4));
      _imageTop = random.nextDouble() * (screenSize.height - (min(screenSize.width, screenSize.height) * 0.4));
      _isImageVisible = true;
    });
    
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        _isImageVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    //final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape; // Maybe later if I want to make a landscape version    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/pumpkin.jpeg'),
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final textSize = screenSize.width * 0.045;
                    final verticalSpacing = screenSize.height * 0.015;
                    final horizontalPadding = screenSize.width * 0.02;
                    
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding, 
                              vertical: verticalSpacing
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(250, 241, 217, 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'Welcome to the mobile dev world!',
                              style: TextStyle(
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: verticalSpacing * 1.5),
                          ElevatedButton(
                            onPressed: buttonPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(250, 241, 217, 1),
                              foregroundColor: Colors.deepOrange,
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding * 2, 
                                vertical: verticalSpacing
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: Colors.deepOrange, width: 2),
                              ),
                              elevation: 5,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.touch_app, size: textSize * 1.2),
                                SizedBox(width: horizontalPadding),
                                Text(
                                  'Click me',
                                  style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),
          ),
          
          if (_isImageVisible)
            Positioned(
              left: _imageLeft,
              top: _imageTop,
              child: AnimatedOpacity(
                opacity: _isImageVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: min(screenSize.width, screenSize.height) * 0.4,
                  height: min(screenSize.width, screenSize.height) * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/screamer.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
