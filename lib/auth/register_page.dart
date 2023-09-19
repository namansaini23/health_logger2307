import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool showLoader = false;

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


  void registerUser() async{
    print("Name: "+nameController.text.trim());
    print("Email: "+emailController.text.trim());
    print("Password: "+passwordController.text.trim());

    try{
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
          //.signInWithEmailAndPassword(email: emailController.text.trim(),password: passwordController.text.trim());

      print("user Created in sucessfully:"+userCredential.user!.uid.toString());

      FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set(
          {
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "createdOn": DateTime.now()
          }
        ).then((value) => Navigator.pushReplacementNamed(context, "/home"));

      // Navigator.pushReplacementNamed(context, "/home");

      //this will bo commented-----------
      // if(userCredential.user != null){
      // }
      //to this--------------------------
    } on FirebaseAuthException catch(e){
      print("something went wrong"+e.message.toString());
      print("error code"+e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoader ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/user.png"),
            const SizedBox(height: 12,),
            const Text("Register", style: TextStyle(color: Colors.amber, fontSize: 24),),
            const SizedBox(height: 6,),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "Enter Full Name",
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Enter Email ID",
                  filled: true
              ),
            ),
            const SizedBox(height: 6,),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Enter Password",
                  filled: true
              ),
            ),
            const SizedBox(height: 6,),
            OutlinedButton(onPressed: (){
              setState(() {
                showLoader = true;
                registerUser();
              });
            }, child: const Text("Register")),
            const SizedBox(height: 12,),
            InkWell(
              child: Text("Existing User? Login Here"),
              onTap: (){
                Navigator.pushNamed(context, "/login");
              },
            )
            // const Text("Log your health data gor a better healthy life", style: TextStyle(color: Colors.blueGrey, fontSize: 18),)
          ],
        ),
      ),
    );
  }
}
