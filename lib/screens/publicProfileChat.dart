import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicProfileChatScreen extends StatefulWidget {
  final userUid;
  PublicProfileChatScreen({Key key, @required this.userUid}) : super(key: key);
  @override
  _PublicProfileChatScreenState createState() =>
      _PublicProfileChatScreenState();
}

class _PublicProfileChatScreenState extends State<PublicProfileChatScreen> {
  var listReview;
  var userData;
  @override
  Widget build(BuildContext context) {
    Widget buildItem(int index, DocumentSnapshot document) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(document['reviewerPhotoUrl']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(document['reviewer']),
          subtitle: Text(document['content']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(document['rating'].toString()),
              Icon(
                Icons.star,
                color: Colors.green,
              )
            ],
          ),
        ),
      );
    }

    Widget buildListReview() {
      // return Flexible(
      return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userUid)
            .collection('reviews')
            // .orderBy('lastUpdated', descending: true)
            // .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green)));
          } else {
            listReview = snapshot.data.documents;
            // print(listReview['reviewers']);
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
        // ),
      );
    }

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: Firestore.instance
                .collection('users')
                .document(widget.userUid)
                .get(),
            builder: (context, ds) {
              if (!ds.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.green)));
              } else {
                userData = ds.data;

                return Column(
                  children: <Widget>[
                    // SizedBox(
                    //   height: 32.0,
                    // ),
                    Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Column(
                          //   children: <Widget>[
                          //     Text(
                          //       '27',
                          //       style: TextStyle(fontSize: 16.0),
                          //     ),
                          //     Text(
                          //       'Rating',
                          //       style: TextStyle(color: Colors.grey),
                          //     ),
                          //   ],
                          // ),
                          // Spacer(),
                          Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userData['photoUrl']),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                userData['displayName'],
                                style: TextStyle(
                                  fontSize: 24.0,
                                ),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                userData['email'],
                                style: TextStyle(color: Colors.grey),
                              ),
                              OutlineButton.icon(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                                label: Text("SEND FRIEND REQUEST",
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.green)),
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 20.0,
                                ),
                                onPressed: () {},
                              )
                            ],
                          ),
                          // Spacer(),
                          // Column(
                          //   children: <Widget>[
                          //     Text(
                          //       '27',
                          //       style: TextStyle(fontSize: 16.0),
                          //     ),
                          //     Text(
                          //       'Friends',
                          //       style: TextStyle(color: Colors.grey),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(64.0, 0, 64.0, 0),
                      child: Container(
                        height: 1.0,
                        decoration: BoxDecoration(color: Colors.green[200]),
                      ),
                    ),
                    SizedBox(height: 16.0),

                    Column(
                      children: <Widget>[
                        TabBar(
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.green,
                            labelColor: Colors.green,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(
                                text: "Reviews",
                              ),
                              // Tab(
                              //   text: "Friends",
                              // ),
                            ]),
                        Container(
                          height: 500,
                          child: TabBarView(
                            children: <Widget>[buildListReview()],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
