import 'dart:convert';
import 'dart:developer';

import 'package:cricket_app/Model/playerStat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlayersDetails extends StatefulWidget {
  String PlayerId;
  PlayersDetails({this.PlayerId});
  @override
  _PlayersDetailsState createState() => _PlayersDetailsState();
}

class _PlayersDetailsState extends State<PlayersDetails> {
  PlayerStat playerStat;
  bool isLoading = true;

  getPlayersData() async {
    log(widget.PlayerId.toString());
    try {
      var url =
          'https://cricapi.com/api/playerStats?apikey=ieesoHryukfpnrRnyu9IOpuAUA92&pid=${widget.PlayerId}';

      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        playerStat = PlayerStat.fromJson(jsonResponse);
        isLoading = false;
        setState(() {});
        print('Players Detail Received');
      } else {
        print('Request failed with status:');
      }
    } catch (e) {
      log(e);
    }
  }

  @override
  void initState() {
    getPlayersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${playerStat.name} details: '),
      ),
      body: ListView(
        children: [
          Text(playerStat.fullName),
          Image.network(
            playerStat.imageURL,
          ),
          Text(playerStat.born),
          Text(playerStat.country),
          Text(playerStat.battingStyle),
          Text(playerStat.bowlingStyle),
          Text(playerStat.profile),
        ],
      ),
    );
  }
}
