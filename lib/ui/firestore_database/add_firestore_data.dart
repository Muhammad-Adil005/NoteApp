import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class AddFirestoreScreen extends StatefulWidget {
  const AddFirestoreScreen({super.key});

  @override
  State<AddFirestoreScreen> createState() => _AddFirestoreScreenState();
}

class _AddFirestoreScreenState extends State<AddFirestoreScreen> {
  bool loading = false;
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Add Firestore'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              //maxLines: 4,
              controller: titleController,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Enter Title',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 30.h),
            TextFormField(
              maxLines: 4,
              controller: subTitleController,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 50.h),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () async {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  firestore.doc(id).set({
                    'id': id,
                    'title': titleController.text.toString(),
                    'subtitle': subTitleController.text.toString(),
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('Post Added Successfully');
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                }),
          ],
        ),
      ),
    );
  }
}
