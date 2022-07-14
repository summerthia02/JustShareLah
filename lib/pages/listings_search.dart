import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListingSearch extends SearchDelegate {
  CollectionReference listings =
      FirebaseFirestore.instance.collection('listings');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: listings.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element['title']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .isEmpty) {
              return Center(
                child: Text("No such listing found :("),
              );
            } else {
              // get data here

              return ListView(
                children: [
                  ...snapshot.data!.docs
                      .where((QueryDocumentSnapshot<Object?> element) =>
                          element['title']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .map((QueryDocumentSnapshot<Object?> element) {
                    // final String title = data.get('title');

                    return ListTile(
                      onTap: () {},
                    );
                  })
                ],
              );
            }
            ;
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("Search for Listings!");
  }
}




  // show the data retrieved from firebase 


  