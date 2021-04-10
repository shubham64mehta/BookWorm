import 'package:bookworm/Global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Datasearch extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        primaryColor: HexColor('#232531'),
        hintColor: CupertinoColors.white);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
          icon: Icon(CupertinoIcons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar

    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //show some results based ont the selection
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    suggestionlist = query.isEmpty
        ? []
        : books.where((p) => p.bookname.startsWith(query)).toList();

    return Container(
      color: HexColor('#232531'),
      child: ListView.builder(
          itemCount: suggestionlist.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey, width: 1.2)),
                  leading: Card(
                    elevation: 9,
                    color: CupertinoColors.tertiarySystemFill,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(suggestionlist[index].imageurl),
                          ),
                          color: CupertinoColors.tertiarySystemFill,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                  title: RichText(
                      text: TextSpan(
                          text: suggestionlist[index]
                              .bookname
                              .substring(0, query.length),
                          style: TextStyle(
                              fontSize: 18,
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.w500),
                          children: [
                        TextSpan(
                            text: suggestionlist[index]
                                .bookname
                                .substring(query.length),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.grey))
                      ]))),
            );
          }),
    );
  }
}
