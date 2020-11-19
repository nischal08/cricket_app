import 'dart:convert';
import 'dart:developer';

import 'package:cricket_app/Model/match.dart';
import 'package:cricket_app/screen/teamInfo.dart';
import 'package:cricket_app/widget/gameCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CricketHome extends StatefulWidget {
  @override
  _CricketHomeState createState() => _CricketHomeState();
}

class _CricketHomeState extends State<CricketHome> {
  List<Games> game = new List();
  bool isLoading = true;

  getNewsData() async {
    try {
      var url =
          'https://cricapi.com/api/matches?apikey=ieesoHryukfpnrRnyu9IOpuAUA92';

      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        jsonResponse['matches'].forEach((v) {
          game.add(Games.fromJson(v));
        });
        isLoading = false;
        setState(() {});
        print('Macthes Received');
      } else {
        print('Request failed with status:');
      }
    } catch (e) {
      log(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getNewsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cricket API')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: game.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0, top: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return TeamInfo(
                          gameId: game[index].uniqueId,
                        );
                      }));
                    },
                    child: GameCard(
                      games: game[index],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
