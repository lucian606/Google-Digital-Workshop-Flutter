import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Number Guesser';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
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
  final toGuess = new Random().nextInt(100);
  String txt = '';

  get numController => null;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: numController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              txt = value;
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  String allertText;
                  int num = int.parse(txt);
                  if (num < toGuess)
                    allertText = 'Try a higher number';
                  else if (num > toGuess)
                    allertText = 'Try a lower number';
                  else
                    allertText = 'You found the number, congrats!';
                  AlertDialog alert = new AlertDialog(
                    title: Text('Guess Status'),
                    content: Text(allertText),
                    actions: [
                      TextButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                  showDialog(context: context, builder: (BuildContext context) {
                    return alert;
                  });
                }
              },
              child: Text('Guess'),
            ),
          ),
        ],
      ),
    );
  }
}