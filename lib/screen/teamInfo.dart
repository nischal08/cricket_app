import 'dart:convert';
import 'dart:developer';

import 'package:cricket_app/Model/squad.dart';
import 'package:cricket_app/screen/PlayersDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeamInfo extends StatefulWidget {
  int gameId;

  TeamInfo({this.gameId});
  @override
  _TeamInfoState createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo> {
  bool isLoading = true;
  List<Squad> squad = new List();
  getNewsData() async {
    log(widget.gameId.toString());
    try {
      var url =
          'https://cricapi.com/api/fantasySquad?apikey=ieesoHryukfpnrRnyu9IOpuAUA92&unique_id=${widget.gameId}';

      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        jsonResponse['squad'].forEach((v) {
          squad.add(Squad.fromJson(v));
        });
        isLoading = false;
        setState(() {});
        print('Squad Received');
      } else {
        print('Request failed with status:');
      }
    } catch (e) {
      log(e);
    }
  }

  @override
  void initState() {
    getNewsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Squad players"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.amber.shade200,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: squad[0].players.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            index == 0
                                ? Text(
                                    squad[0].name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            index == 0 ? Divider() : SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 14.0, top: 10.0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return PlayersDetails(
                                        PlayerId: squad[0].players[index].pid,
                                      );
                                    }));
                                  },
                                  child:
                                      Text(squad[0].players[index].name ?? '')),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.greenAccent.shade200,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: squad[0].players.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            index == 0
                                ? Text(
                                    squad[1].name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            index == 0 ? Divider() : SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 14.0, top: 10.0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return PlayersDetails(
                                        PlayerId: squad[1].players[index].pid,
                                      );
                                    }));
                                  },
                                  child:
                                      Text(squad[1].players[index].name ?? '')),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
