import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Money Converter';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(appTitle, textAlign: TextAlign.center,),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String txt = '';
  String valid = '09.';
  String leistring = '';
  final double exchange = 4.87;

  get numController => null;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
          child: Container(
            width: MediaQuery.of(context).size.width /2,
            child: Image.network("https://www.europafm.ro/wp-content/uploads/2015/07/leu-romanesc.jpg"),
          ),),
          TextFormField(
            controller: numController,
            keyboardType: TextInputType.number,
            validator: (value) {
              value = value.trim();
              if (value.isEmpty || value.contains('-') || value.contains(',') || value.contains(' ') || '.'.allMatches(value).length > 1) {
                return 'Please enter a number';
              }
              if ((value.codeUnitAt(0) < valid.codeUnitAt(0) || value.codeUnitAt(0) > valid.codeUnitAt(1)) && value.codeUnitAt(0) != valid.codeUnitAt(2)) {
                return 'Please enter a number';
              }
              if (value.codeUnitAt(0) == valid.codeUnitAt(2))
                value = "0" + value;
              txt = value;
              return null;
            },
            decoration: InputDecoration(
              hintText: "Enter the amount of EUR you wish to convert"
            )
          ),
          Center(
              child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  double eur = double.parse(txt);
                  double lei = exchange * eur;
                  setState(() {
                    leistring = '' + lei.toString();
                  });
                }
              },
              child: Text('Convert to RON'),
              ),),
          Center(
              child: Text("Lei amount: $leistring",
                  style: TextStyle(fontSize: 21),),)
        ],
      ),
    );
  }
}