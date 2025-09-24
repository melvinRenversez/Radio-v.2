import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String imgUrl = "";
  String titre = "";
  String album = "";
  String artiste = "";
  String annee = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
            imgUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 50, color: Colors.red);
            },
                  ),
            Text(titre),
            Text(album),
            Text(artiste),
            Text(annee),
          ],
        )
      )
    );
  }

  Future<void> fetchData() async {
    print("test");

    final url = Uri.parse("http://localhost:3000/getCurrentTrack");
    final response = await http.get(url);

    print("test 1 ");
    print(response.body);

    final json = jsonDecode(response.body);

    setState(() {
      imgUrl = "http://localhost:3000/Pochette/${json["pochette"]}";
      titre = json["titre"];
      album = json["album"];
      artiste = json["artiste"];
      annee = json["annee"].toString();
    });

    print(imgUrl);

    print("Finish");
  }
}
