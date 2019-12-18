import 'package:flutter/material.dart';
import 'package:flutter_signature_view/flutter_signature_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SignatureView _signatureView;
  var _value;

  @override
  Widget build(BuildContext context) {
    _signatureView = SignatureView(
      backgroundColor: Colors.yellow,
      penStyle: Paint()
        ..color = Colors.blue
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0,
      onSigned: (data) {
        print("On change $data");
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Signature view"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.print),
              onPressed: () {
                try {
                  _signatureView.isEmpty;
                  _signatureView.exportBytes().then((value) {
                    setState(() {
                      _value = value;
                      print("value: $value");
                    });
                  });

                  _signatureView.exportBase64Image().then((value) {
                    print("Value: $value");
                  });
                } catch (e) {
                  print(e.toString());
                }
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .8,
                child: Container(
                  child: Center(
                    child: _value != null ? Image.memory(_value) : Container(),
                  ),
                )),
            Container(
              width: 330,
              height: 330,
              child: _signatureView,
            )
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clear,
        tooltip: 'Clear',
        child: Icon(Icons.add),
      ),
    );
  }

  _clear() {
    _signatureView?.clear();
  }
}
