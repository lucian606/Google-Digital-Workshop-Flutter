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
  int toGuess = new Random().nextInt(100) + 1;
  bool guessed = false;
  String txt = '';
  String statusText = '';
  String buttonText = 'Guess';
  String valid = '09';

  Null get numController => null;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
              child: Text(
            "I'm thinking of a number from 1 to 100.\n",
            style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
            textAlign: TextAlign.center,
          )),
          Center(
              child: Text(
            "It's your turn to guess my number!\n",
            style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 20,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )),
          Center(
            child: Text(
              statusText,
              style: TextStyle(
                  fontFamily: 'Roboto', fontSize: 30, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Card(
              child: Column(children: <Widget>[
                Text(
                  "Try a number!",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 40,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  controller: numController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    value = value.trim();
                    if (value.isEmpty ||
                        value.codeUnitAt(0) < valid.codeUnitAt(0) ||
                        value.codeUnitAt(0) > valid.codeUnitAt(1) ||
                        value.contains('.') ||
                        value.contains('-') ||
                        value.contains(',') ||
                        value.contains(' ')) {
                      return 'Please enter an integer';
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
                      if (guessed) {
                        setState(() {
                          toGuess = new Random().nextInt(100) + 1;
                          guessed = false;
                          buttonText = "Guess";
                        });
                      }
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        String statusTextTemp;
                        int num = int.parse(txt);
                        if (num < toGuess)
                          statusTextTemp =
                              'You tried ' + num.toString() + '\n Try higher';
                        else if (num > toGuess)
                          statusTextTemp =
                              'You tried ' + num.toString() + '\n Try lower';
                        else {
                          statusTextTemp = 'You found the number, congrats!';
                          guessed = true;
                        }
                        print(toGuess);
                        setState(() {
                          statusText = statusTextTemp;
                          if (guessed) {
                            String allertText = "It was " + num.toString();
                            buttonText = "Reset";
                            AlertDialog alert = new AlertDialog(
                              title: Text('You guessed right!'),
                              content: Text(allertText),
                              actions: [
                                TextButton(
                                  child: Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Try Again!'),
                                  onPressed: () {
                                    setState(() {
                                      toGuess = new Random().nextInt(100) + 1;
                                      guessed = false;
                                      buttonText = "Guess";
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                            showDialog<AlertDialog>(context: context, builder: (BuildContext context) {
                              return alert;
                            });
                          }
                        });
                      }
                    },
                    child: Text(buttonText),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
