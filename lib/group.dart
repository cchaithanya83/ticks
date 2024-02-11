import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticks/done.dart';

class group extends StatefulWidget {
  final String ids;
  const group({required this.ids, Key? key}) : super(key: key);

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<group> {
  TextEditingController participantController = TextEditingController();

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
            controller: participantController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.black),
                borderRadius: BorderRadius.circular(90),
              ),
              hintText: 'Enter Participants Email',
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
              onTap: () async {
                String email = participantController.text;
                String uid = await getUidFromEmail(email);

                if (uid.isNotEmpty) {
                  addParticipantToGroup(widget.ids, uid);
                  print('Participant added to group');
                } else {
                  print('User not found with email: $email');
                }
              },
              child: Center(
                child: Text('Done', style: GoogleFonts.oxygen(color: Colors.white, fontSize: 25)),
              ),
            ),
          ),
        ),
      )
          ],
        ),
      ),
    );
  }

 Future<String> getUidFromEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return ''; // Return empty string if user not found
      }
    } catch (e) {
      print('Error getting UID from email: $e');
      return '';
    }
  }
  Future<void> addParticipantToGroup(String groupId, String participantName) async {
    try {
      DocumentReference groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot groupSnapshot = await transaction.get(groupRef);
        Map<String, dynamic> peopleData = groupSnapshot['peopleData'] ?? {};

        // Add the participant to the peopleData map
        peopleData[participantName] = 0; // You can set any initial value

        transaction.update(groupRef, {'peopleData': peopleData});
      });
    } catch (e) {
      print('Error adding participant to group: $e');
    }
  }
}
