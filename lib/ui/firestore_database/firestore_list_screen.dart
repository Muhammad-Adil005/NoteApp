import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/ui/firestore_database/add_firestore_data.dart';

import '../../utils/utils.dart';
import '../login_screen.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final fAuth = FirebaseAuth.instance;
  final searchFilter = TextEditingController();
  final titleEditController = TextEditingController();
  final subTitleEditController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('Users').snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  void dispose() {
    titleEditController.dispose();
    subTitleEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Firestore List Screen'),
        actions: [
          IconButton(
            onPressed: () async {
              await fAuth.signOut().catchError((error) {
                Utils().toastMessage(error.toString());
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFirestoreScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['title'].toString()),
                      subtitle: Text(data['subtitle']),
                      trailing: PopupMenuButton<int>(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 1) {
                            titleEditController.text = data['title'].toString();
                            subTitleEditController.text =
                                data['subtitle'].toString();
                            _showEditDialog(document);
                          } else if (value == 2) {
                            users.doc(document.id).delete();
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

// This code is for Alert Dialog if we want to update the data
  void _showEditDialog(DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleEditController,
                  decoration: InputDecoration(hintText: 'Edit title'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: subTitleEditController,
                  decoration: InputDecoration(hintText: 'Edit subtitle'),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                onPressed: () {
                  if (titleEditController.text.isNotEmpty &&
                      subTitleEditController.text.isNotEmpty) {
                    users.doc(document.id).update({
                      'title': titleEditController.text,
                      'subtitle': subTitleEditController.text,
                    });
                    Navigator.pop(context);
                  } else {
                    // You can show a toast message or alert here if fields are empty.
                  }
                },
                child: Text('Update'),
              ),
            ],
          );
        });
  }
}

/*
 Expanded(
            child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: const CircularProgressIndicator());
                  } else {
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list = [];
                    list.clear();
                    list = map.values.toList();
                    return ListView.builder(
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(list[index]['title']),
                            subtitle: Text(list[index]['subtitle']),
                          );
                        });
                  }
                }),
          ),
 */
