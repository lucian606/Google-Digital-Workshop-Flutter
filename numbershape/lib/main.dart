import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Number Shape';

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
  String txt = '';
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
            child: Text('Enter a number to see if it is a prime/square/cube',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),),
          ),
          TextFormField(
            controller: numController,
            keyboardType: TextInputType.number,
            validator: (value) {
              value = value.trim();
              if (value.isEmpty || value.codeUnitAt(0) < valid.codeUnitAt(0) || value.codeUnitAt(0) > valid.codeUnitAt(1) || value.contains('.') || value.contains('-') || value.contains(',') || value.contains(' ')) {
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
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  String allertText = "";
                  int num = int.parse(txt);
                  int ok = 0;
                  for (int i = 2; i <= sqrt(num); i++) {
                    if (num % i == 0) {
                      ok = 1;
                      break;
                    }
                  }
                  if(ok == 0 && num != 1)
                    allertText += "Number $num is prime.\n";
                  double sr = sqrt(num);
                  if (sr - sr.floor() == 0) {
                    allertText += "Number $num is a perfect square.\n";
                  }
                  int cube;
                  for (int i = 1; i <= num; i++) {
                    cube = i * i * i;
                    if (cube == num) {
                      allertText += "Number $num is a perfect cube.\n";
                      break;
                    }
                  }
                  if (allertText.isEmpty)
                    allertText = "Number $num is not special. :(";
                  AlertDialog alert = new AlertDialog(
                    title: Text('$num'),
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
                  showDialog<AlertDialog>(context: context, builder: (BuildContext context) {
                    return alert;
                  });
                }
              },
              child: Text('Get Number Info'),
            ),
          ),
        ],
      ),
    );
  }
}