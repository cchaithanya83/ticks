import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticks/settle.dart';

class amount extends StatefulWidget {
  final String id;

  const amount({required this.id, Key? key}) : super(key: key);

  @override
  State<amount> createState() => _AmountState();
}

class _AmountState extends State<amount> {
  String person = 'Select a person';
  String selectedUid = ''; // Store the selected user's UID
  
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FEBB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: Container(
                  child: Center(
                    child: Text(
                      'Group 1',
                      style: GoogleFonts.oxygen(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  color: Color(0xffEDFF21),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
              child: Center(
                child: FutureBuilder(
                  future: fetchPeopleNames(widget.id),
                  builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No people available for group ID: ${widget.id}');
                    } else {
                      return DropdownButton<String>(
                        items: snapshot.data!.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedUid = value!;
                            person = snapshot.data![value] ?? 'Select a person';
                          });
                          print('Selected UID: $selectedUid');
                        },
                        hint: Text(person),
                      );
                    }
                  },
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    hintText: 'Enter Bill Amount',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () async {
                  String amount = amountController.text ;

                  if (selectedUid.isNotEmpty) {
                    await addAmountToUser(selectedUid, widget.id, amount);
                    print('Amount added to user $selectedUid in group ${widget.id}');
                  } else {
                    print('Please select a person before adding the amount.');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Center(
                    child: Text(
                      'Done',
                      style: GoogleFonts.oxygen(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
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

  Future<Map<String, String>> fetchPeopleNames(String groupId) async {
    try {
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();

      if (!groupSnapshot.exists) {
        return {}; // Return an empty map if the group doesn't exist or has no people
      }

      Map<String, dynamic> personsData = groupSnapshot['peopleData'] ?? {};
      List<String> uids = personsData.keys.toList();

      Map<String, String> namesMap = {};

      for (String uid in uids) {
        DocumentSnapshot userSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (userSnapshot.exists) {
          String userName = userSnapshot['name'] ?? 'Unknown';
          namesMap[uid] = userName;
        }
      }

      return namesMap;
    } catch (e) {
      print('Error fetching people names: $e');
      return Future.error(e);
    }
  }

  Future<void> addAmountToUser(
      String userId, String groupId, String amount1) async {
        double amount = double.parse(amount1);

    try {
      DocumentReference groupRef =
          FirebaseFirestore.instance.collection('groups').doc(groupId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot groupSnapshot = await transaction.get(groupRef);
        Map<String, dynamic> personsData = groupSnapshot['peopleData'] ?? {};
        if (personsData.containsKey(userId)) {
          personsData[userId] = personsData[userId] + amount;
          transaction.update(groupRef, {'peopleData': personsData});
        }
        amountController.clear();
      });
    } catch (e) {
      print('Error adding amount to user: $e');
    }
  }
}
