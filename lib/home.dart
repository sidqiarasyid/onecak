import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onecak/newsModel.dart';
import 'package:onecak/news_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  var _data = [];
  var news;
  List<NewsModel> listNews = [];

  Future addDb() async{
    isLoading = true;
    try {
      final response = await http.get(
          Uri.parse("https://the-lazy-media-api.vercel.app/api/games?page=1"));
      final result = jsonDecode(response.body) as List;
      setState(() {
        print('isi api: ' + result.toString());
        _data = result;

      });
    } catch (error) {
      print('no internet');
    }
    for (int i = 0; i < _data.length; i++) {
      final _news = _data[i];
      news = NewsModel(
          imageUrl: _news['thumb'],
          author: _news['author'],
          title: _news['title']);
      print('Hasil dari api ke: ' + i.toString() + ' Gambar: ' + _news['thumb'] + ' Author: ' +  _news['author'] + ' Title: '  + _news['title']);
      await NewsDatabase.instance.create(news);
    }
    read();
  }

  Future read() async{
    listNews = await NewsDatabase.instance.readAll();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(listNews.isEmpty){
      addDb();
    } else {
      listNews.clear();
      read();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Lazy Media"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    final item = listNews[index];

                    return Container(
                      margin: EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 140,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(item.imageUrl))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  item.author,
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: listNews.length),
            ),
    );
  }
}
