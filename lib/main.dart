// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Welcome to Flutter'),
//        ),
//        body: Center(
//          child: RandomWords(),
//        ),
//      ),
      theme: new ThemeData(
        primaryColor: Colors.greenAccent,
      ),
      home: RandomWords(),
    );
  }
}

// #docregion RandomWordsState, RWS-class-only
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // #enddocregion RWS-class-only
  @override
  Widget build(BuildContext context) {
//    final wordPair = WordPair.random();
//    return Text(wordPair.asPascalCase);

    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator!'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map(
          (WordPair pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final List<Widget> divided =
            ListTile.divideTiles(context: context, tiles: tiles).toList();

        // 들어오면 나오는 다음화면 (중요)
        return new Scaffold(
          appBar: new AppBar(
            title: const Text("Saved Suggestions"),
          ),
          body: new ListView(children: divided),
        );
      },
    ));
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          // i가 홀수면 가운데 선을 그어줘라
          if (i.isOdd) return Divider();

          // ~/ -> 몫
          // 홀수가 아니면 글씨를 표시
          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            // words들을 _suggestions에 넣는다
            _suggestions.addAll(generateWordPairs().take(10));
          }
          // 글씨 생성해서 리턴
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    // _saved에 글씨가 포함되어있으면 true 아니면 false
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      // click시 이벤트 발생
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

// #docregion RWS-class-only
}
// #enddocregion RandomWordsState, RWS-class-only

// #docregion RandomWords
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
