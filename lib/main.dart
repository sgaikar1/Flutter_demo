import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List data;

class _MyHomePageState extends State<MyHomePage> {
  String url = "api url";
  Future<String> makeRequest() async {
    print("1");
    Map<String, int> jsonMap = {
      'myFeed': 1
    };
    print("2");
    String jsonString = json.encode(jsonMap);
    print("3");
    String paramName = 'param'; // give the post param a name
    String formBody =/* paramName + '=' + */Uri.encodeQueryComponent(jsonString);
    List<int> bodyBytes = utf8.encode(formBody); // utf8 encode
    print("4");
//    Map<String, String> requestHeaders = ;
    var response =
        await http.post(Uri.encodeFull(url), body: formBody, headers: {
//          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer 5c7d5738f4bade3c7ce540a3",
        });

    print("5");

    setState(() {
      var extractedData = json.decode(response.body.toString());
        print(extractedData);
      data = extractedData["data"]["list"];
//      print(data[0]["name"]);
    });
  }

  @override
  void initState() {
    makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        /*body: new Center(
          child: new RaisedButton(
              child: new Text("Click me"),
              onPressed: makeRequest),
        ),*/
        body: new MyList(data),
    );
  }
}

class MyList extends StatelessWidget {
  MyList(List data);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: data == null ? 0 : data.length,
      padding: const EdgeInsets.all(4.0),
      itemBuilder: (context, i) {
        return new ListTile(
          title: new Text(data[i]["title"]),
//          subtitle: new Text(data[i]["phone"]),
          leading: new CircleAvatar(
            backgroundImage: new NetworkImage(data[i]["image"]),
          ),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new SecondPage(data[i])));
          },
        );
      },
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);

  final data;

  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text("Second Page"),
        ),
        body: new Center(
          child: new Container(
            width: 150.0,
            height: 150.0,
            decoration: new BoxDecoration(
              color: Colors.transparent,
              image: new DecorationImage(
                image: new NetworkImage(data["image"]),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
              border: new Border.all(color: Colors.red, width: 4.0),
            ),
          ),
        ),
      );
}
