import 'package:flutter/material.dart';

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
  bool _isSakuraBackground = true;

  void buttonPressed() {
    print('One of the buttons was pressed');
        setState(() {
      _isSakuraBackground = !_isSakuraBackground;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final String backgroundImage = _isSakuraBackground ? 'assets/images/sakura.jpeg' : 'assets/images/wave.jpg';
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          
          final swipeThreshold = screenSize.width > screenSize.height 
              ? 0.2 * screenSize.width : 0.2 * screenSize.height;
          
          // print('Swipe velocity: ${details.primaryVelocity}');
          // print('Swipe threshold: $swipeThreshold');
          // print('Direction: ${details.primaryVelocity! > 0 ? "Right" : "Left"}');
          
          if (details.primaryVelocity!.abs() > swipeThreshold) {
            // print('Swipe detected! Changing background.');
            setState(() {
              _isSakuraBackground = !_isSakuraBackground;
            });
          } 
          // else {
            // print('Swipe too slow to trigger change.');
          // }
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
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
                                color: _isSakuraBackground ? Color.fromRGBO(247, 199, 210, 1) : Color.fromRGBO(173, 195, 193, 1), 
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                _isSakuraBackground ? "桜" : "波",
                                style: TextStyle(
                                  fontSize: textSize*3,
                                  fontWeight: FontWeight.bold,
                                  color: _isSakuraBackground ? Color.fromRGBO(235, 35, 80, 1) : Color.fromRGBO(250, 242, 219, 1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: verticalSpacing * 1.5),
                            ElevatedButton(
                              onPressed: buttonPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isSakuraBackground ? Color.fromRGBO(173, 195, 193, 1) : Color.fromRGBO(247, 199, 210, 1) ,
                                foregroundColor: _isSakuraBackground ? Color.fromRGBO(250, 242, 219, 1) : Color.fromRGBO(235, 35, 80, 1),
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding * 2, 
                                  vertical: verticalSpacing
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: _isSakuraBackground ? Color.fromRGBO(250, 242, 219, 1) : Color.fromRGBO(235, 35, 80, 1), width: 2),
                                ),
                                elevation: 5,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_isSakuraBackground ? Icons.directions_ferry : Icons.filter_vintage, size: textSize * 1.2),
                                  SizedBox(width: horizontalPadding),
                                  Text(
                                    _isSakuraBackground ? "波に" : "桜に",
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
          ],
        ),
      ),
    );
  }
}
