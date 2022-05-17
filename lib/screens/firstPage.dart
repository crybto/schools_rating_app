import 'package:flutter/material.dart';
import 'package:schools/cloudFirebaseSearch.dart';
import 'package:schools/screens/secondPage.dart';

class ScreenOne extends StatelessWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("School APP"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.asset(
            "assets/images/2.jpeg",
            width: 400,
            height: 250,
          ),
          Column(
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CloudFirestoreSearch()));
                  },
                  child: const Text("Find Your School")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PageTwo()));
                  },
                  child: const Text("See our Top Picks")),
            ],
          ),
        ],
      ),
    );
  }
}
