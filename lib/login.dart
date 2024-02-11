import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticks/login_page.dart';
import 'package:ticks/signup.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FFBA),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 500),
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
          Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Center(
                child: InkWell(
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> signup()));
                  },
                  child: Container(
                    height: 70,
                    width: 250,
                    child: Center(child: Text('Sign up',style: GoogleFonts.oxygen(color: Colors.white,fontSize: 25),)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 270),
              child: Center(child: Text('Or',style: GoogleFonts.oxygen(fontSize: 20),)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 420),
              child: Center(
                child: InkWell(
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> login_page()));
                  },
                  child: Container(
                    height: 70,
                    width: 250,
                    child: Center(child: Text('Login',style: GoogleFonts.oxygen(color: Colors.white,fontSize: 25),)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      
    );
  }
}