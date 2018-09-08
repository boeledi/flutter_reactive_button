import 'package:flutter/material.dart';
import 'package:flutter_reactive_button/flutter_reactive_button.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Reactive Button Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new PageReactiveButton(),
    );
  }
}

// ----------------------------------------------------------------

class PageReactiveButton extends StatefulWidget {
  @override
  _PageReactiveButtonState createState() => _PageReactiveButtonState();
}

class _PageReactiveButtonState extends State<PageReactiveButton> {
  List<ReactiveIconDefinition> _flags = <ReactiveIconDefinition>[
    ReactiveIconDefinition(
      assetIcon: 'images/flag-de.png',
      code: 'de',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/flag-en.png',
      code: 'en',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/flag-fr.png',
      code: 'fr',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/flag-it.png',
      code: 'it',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/flag-nl.png',
      code: 'nl',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/flag-es.png',
      code: 'es',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/flag-pt.png',
      code: 'pt',
    ),
  ];

  List<ReactiveIconDefinition> _facebook = <ReactiveIconDefinition>[
    ReactiveIconDefinition(
      assetIcon: 'images/like.gif',
      code: 'like',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/haha.gif',
      code: 'haha',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/love.gif',
      code: 'love',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/sad.gif',
      code: 'sad',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/wow.gif',
      code: 'wow',
    ),
    ReactiveIconDefinition(
      assetIcon: 'images/angry.gif',
      code: 'angry',
    ),
  ];

  String countryCode = 'en';
  String facebook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ReactiveButton Sample'),
        actions: <Widget>[
          ReactiveButton(
            icons: _flags,
            onSelected: (ReactiveIconDefinition button) {
              setState(() {
                countryCode = button.code;
              });
            },
            child: Image.asset(
              'images/flag-$countryCode.png',
              width: 32.0,
              height: 32.0,
            ),
            containerAbove: false,
            iconWidth: 32.0,
            iconGrowRatio: 1.5,
            roundIcons: false,
            onTap: () {
              print('Hey I am hit');
            },
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Colors.black54,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0x55FFFFFF),
            ),
          ),
          SizedBox(
            width: 24.0,
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              height: 850.0,
              color: Colors.blueGrey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Here is some text'),
            ),
            ReactiveButton(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  color: Colors.white,
                ),
                width: 80.0,
                height: 40.0,
                child: Center(
                  child: facebook == null
                      ? Text('click')
                      : Image.asset(
                          'images/$facebook.png',
                          width: 32.0,
                          height: 32.0,
                        ),
                ),
              ),
              icons: _facebook, //_flags,
              onTap: () {
                print('TAP');
              },
              onSelected: (ReactiveIconDefinition button) {
                setState(() {
                  facebook = button.code;
                });
              },
              iconWidth: 32.0,
            ),
            Container(
              height: 800.0,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}
