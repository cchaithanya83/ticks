import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroup extends StatefulWidget {
  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FEBB),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 10),
        child: Stack(
          children: [
            Text(
              'TabTango!',
              style: GoogleFonts.kaushanScript(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 500),
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/WhatsApp Image 2023-12-04 at 9.15.55 PM.jpeg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200, right: 10),
              child: Center(
                child: TextField(
                  controller: groupNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    hintText: 'Enter Group Name',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 700),
              child: Center(
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: InkWell(
                    onTap: () {
                      addGroup(groupNameController.text);
                      print('Group added');
                    },
                    child: Center(
                      child: Text('Done', style: GoogleFonts.oxygen(color: Colors.white, fontSize: 25)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addGroup(String groupName) async {
    try {
      CollectionReference groups = FirebaseFirestore.instance.collection('groups');
      await groups.doc(groupName).set({
        'name': groupName,
        'peopleData': {}, // Initialize with an empty map for peopleData
      });
      groupNameController.clear();
    } catch (e) {
      print('Error adding group: $e');
    }
  }
}
