import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/ui/Realtime_database/post_screen.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Add Post'),
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
                  if (_isValidForm()) {
                    setState(() {
                      loading = true;
                    });
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    await databaseRef.child(id).set({
                      'id': id,
                      'title': titleController.text,
                      'subtitle': subTitleController.text,
                    }).catchError((error) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });

                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('Post Added');
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => PostScreen()));
                  }
                }),
          ],
        ),
      ),
    );
  }

  bool _isValidForm() {
    // This method can be expanded to include more comprehensive validation
    return titleController.text.isNotEmpty &&
        subTitleController.text.isNotEmpty;
  }
}
