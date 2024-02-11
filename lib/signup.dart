

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController emailController= TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController PassController = TextEditingController();

void  createAccount()async{
  String email = emailController.text.trim();
  String name = nameController.text.trim();
String pass = PassController.text.trim();


  try{

 UserCredential userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
 await firestore.collection('users').doc(userCredential.user?.uid).set({
  'uid': userCredential.user?.uid,
      'email': email,
      'name': name
    });

 if (userCredential.user!=null){
  Navigator.pop(context);
 }

 
  }on FirebaseAuthException catch(ex){

    log(ex.code.toString());
  }


}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xffF9FEBB),
       body: SafeArea(
         child: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.only(top: 50,left: 10),
             child: Column(
               children: [
                 Center(
                   child: Container(
                     height: 100,
                     width: 250,
                     decoration: BoxDecoration(
                       boxShadow: [BoxShadow(
                             color: Colors.black,
                             spreadRadius: 1.5
                 
                           )],
                       color: Color(0xffEDFF21),
                       borderRadius: BorderRadius.circular(20)
                     ),
                     child: Center(child: Text('TabTango!',style: GoogleFonts.kaushanScript(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),
                   ),
                 ),
                 Center(
                   child: Column(
                     children: [
                       Container(
                        child: Text('Sign Up!',style: GoogleFonts.oxygen(fontSize: 30,fontWeight: FontWeight.w600),),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 30,right: 10),
                   child: Center(
                     child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(90)
                        ),
                        hintText: 'Enter Your Email'
                      ),
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 20,right: 10),
                   child: Center(
                     child: TextField( 
                      controller: nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(90)
                        ),
                        hintText: 'Name'
                      ),
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 20,right: 10),
                   child: Center(
                     child: TextField(
                 controller: PassController,
                 decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.black),
              borderRadius: BorderRadius.circular(90),
            ),
            hintText: 'Enter Your Password',
                 ),
                 obscureText: true, // Set this property to true to hide the password
               ),
                   ),
                 ),
                 
                 Padding(
                   padding: const EdgeInsets.only(top:30),
                   child: Center(
                     child: Container(
                      height: 70,
                      width: 350,
                      decoration: BoxDecoration(
                         color: Colors.black,
                        borderRadius: BorderRadius.circular(90)
                      ),
                      child: InkWell(
                        onTap: () {
                          createAccount();
                        },
                        child: Center(child: Text('Sign Up',style: GoogleFonts.oxygen(color: Colors.white,fontSize: 25),))),
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
}