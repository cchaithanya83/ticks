
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticks/AddGroup.dart';
import 'package:ticks/Amount_screen.dart';
import 'package:ticks/delete.dart';
import 'package:ticks/done.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home extends StatefulWidget {
  const home({Key? key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FEBB),
      body: Center(
        child: SafeArea(
          child: Padding(
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
                Padding(
                  
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: FutureBuilder(
                      future: fetchGroupsFromFirestore(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text('No groups available.');
                        } else {
                          List<Widget> groupWidgets = snapshot.data!.docs
                              .map((doc) => buildGroupWidget(context, doc))
                              .toList();
          
                          return Column(
                            children: groupWidgets,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(90)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddGroup()));
                        },
                        child: Center(
                            child: Text(
                          'New Group',
                          style: GoogleFonts.oxygen(
                              color: Colors.white, fontSize: 25),
                        )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 400),
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(90)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DeleteGroup()));
                        },
                        child: Center(
                            child: Text(
                          'Delete Group',
                          style: GoogleFonts.oxygen(
                              color: Colors.white, fontSize: 25),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGroupWidget(BuildContext context, QueryDocumentSnapshot<Object?> doc) {
    return Container(
      height: 60,
      width: 300,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
          ),
        ],
        color: Color(0xffEDFF21),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => done(id: doc.id)),
          );
        },
        child: Center(
          child: Text(
            doc['name'].toString(),
            style: GoogleFonts.oxygen(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot> fetchGroupsFromFirestore() async {
    try {
      return await FirebaseFirestore.instance.collection('groups').get();
    } catch (e) {
      print('Error fetching groups from Firestore: $e');
      return Future.error(e);
    }
  }
}
