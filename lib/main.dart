import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api/indonesian_hero.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const API(),
    );
  }
}

class API extends StatefulWidget {
  const API({Key? key}) : super(key: key);

  @override
  State<API> createState() => _APIState();
}

class _APIState extends State<API> {
  List<IndonesianHero> heroes = [];

  Future _getData() async {
    try {
      var response = await http.get(
        Uri.parse(
          "https://indonesia-public-static-api.vercel.app/api/heroes",
        ),
      );
      List data = jsonDecode(response.body);
      for (var element in data) {
        heroes.add(IndonesianHero.fromJson(element));
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter API"),
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: 191,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                    ),
                    title: Text(heroes[index].name),
                    subtitle: Text(
                      heroes[index].description,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onTap: () {
                    AlertDialog dialog = AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            "Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(heroes[index].name),
                          const Divider(),
                          const Text(
                            "Birth Year",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(heroes[index].birthYear.toString()),
                          const Divider(),
                          const Text(
                            "Death Year",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(heroes[index].deathYear.toString()),
                          const Divider(),
                          const Text(
                            "Description",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            heroes[index].description,
                            textAlign: TextAlign.center,
                          ),
                          const Divider(),
                          const Text(
                            "Ascension Year",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(heroes[index].ascensionYear.toString())
                        ],
                      ),
                    );
                    dialog.build(context);
                    showDialog(context: context, builder: (context) => dialog);
                  },
                );
              },
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Icon(
                  Icons.signal_cellular_connected_no_internet_0_bar,
                ),
              ),
              Center(child: Text("No Internet Connection"))
            ],
          );
        },
      ),
    );
  }
}
