import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List View'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                  future: getContent(),
                  builder: (BuildContext ctxy, AsyncSnapshot mycontent) {
                    if (null == mycontent.data) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        //scrollDirection: Axis.horizontal,
                        itemCount: mycontent.data.length,
                        itemBuilder: (ctx, i) {
                          return ListTile(
                            onTap: () async {
                              //on tap event

                              var addTocard = http.post('addtocard.php', body: {
                                'pid': mycontent.data[i].id,
                                'uid': 5
                              });
                            },
                            title: Text(mycontent.data[i].title),
                            subtitle: Text(mycontent.data[i].des),
                          );
                        },
                      );
                    }
                  })),
        ],
      )),
    );
  }

  Future<List<MyList>> getContent() async {
    http.Response restest = await http
        .get("https://ghanashyamadhikari.com.np/ecommerce/getdata.php");
    var jsonData = json.decode(restest.body);
    print(jsonData);
    List<MyList> mydata = [];
    for (var u in jsonData) {
      MyList myevent = MyList(u["title"], u["des"]);
      mydata.add(myevent);
    }
    //print(myevents);
    return mydata;
  }
}

class MyList {
  final String title;
  final String des;

  MyList(this.title, this.des);
}
