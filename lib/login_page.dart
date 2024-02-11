
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticks/done.dart';
import 'package:ticks/home.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {

    TextEditingController emailController= TextEditingController();
  TextEditingController passController= TextEditingController();

  void login()async{
    String email=emailController.text.trim();
    String pass = passController.text.trim();


    UserCredential userCredential=await  FirebaseAuth . instance.signInWithEmailAndPassword(email: email, password: pass);
    if(userCredential.user!=null){
      Navigator.push(context,MaterialPageRoute(builder: (context)=> home()));
    }
    }
  


 @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xffF9FEBB),
       body: SafeArea(
         child: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.only(top: 60,left: 10),
             child: Column(
               children: [
                 Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Center(
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
                
              ),
                 Center(
                   child: Padding(
                     padding: const EdgeInsets.only(bottom: 20),
                     child: Column(
                       children: [
                         Container(
                          child: Text('Login!',style: GoogleFonts.oxygen(fontSize: 30,fontWeight: FontWeight.w600),),
                         ),
                       ],
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(bottom: 30,right: 10),
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
             padding: const EdgeInsets.only(bottom: 20, right: 10),
             child: Center(
               child: TextField(
                 controller: passController,
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
                   padding: const EdgeInsets.only(top: 20),
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
                          login();
                        },
                        child: Center(child: Text('Login',style: GoogleFonts.oxygen(color: Colors.white,fontSize: 25),))),
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