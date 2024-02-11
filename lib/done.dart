import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticks/Amount_screen.dart';
import 'package:ticks/group.dart';

class done extends StatelessWidget {
  final String id;

  const done({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FEBB),
      body: SafeArea(
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
              FutureBuilder(
                future: fetchUserDataFromFirestore(id),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No data available for ID: $id');
                  } else {
                    var peopleData = snapshot.data!['peopleData'] ?? {};                
        
                    return Column(
                      children: [
                       
                        SizedBox(height: 50),
                        Column(
                          children: [
                            
                             
                                for (var entry in peopleData.entries)
                            FutureBuilder(
                              future: loadcurrentName(entry.key),
                              builder: (context, AsyncSnapshot<String> nameSnapshot) {
                                if (nameSnapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (nameSnapshot.hasError) {
                                  return Text('Error loading name: ${nameSnapshot.error}');
                                } else {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      'Email: ${nameSnapshot.data} \n Pending Amount: ${entry.value}',
                                      style: GoogleFonts.oxygen(fontSize: 20,),
                                    ),
                                    height: 70,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.black),color: const Color.fromARGB(255, 206, 204, 197)),
                            
                                  );
                                }
                              },
                            ),
                              ],
                            ),
                            FilledButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => amount(id: id),));                           
                            }, child: Text("Enter expense")),
                            FilledButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => group(ids: id),));                           
                            }, child: Text("add people"))
                            
                          ],
                        
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DocumentSnapshot> fetchUserDataFromFirestore(String id) async {
    try {
      return await FirebaseFirestore.instance.collection('groups').doc(id).get();
    } catch (e) {
      print('Error fetching user data from Firestore: $e');
      return Future.error(e);
    }
  }
Future<String> loadcurrentName(uid) async {
  try {
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var name = ds['email'];
    print(name);
    return name.toString();
  } catch (e) {
    print('Error loading name: $e');
    return Future.error(e);
  }
}

}