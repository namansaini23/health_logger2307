import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool showLoader = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  void loginUser() async{
    print("Email: "+emailController.text.trim());
    print("Password: "+passwordController.text.trim());

    try{
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailController.text.trim(),password: passwordController.text.trim());

      print("user signed in sucessfully:"+userCredential.user!.uid.toString());
      Navigator.pushReplacementNamed(context, "/home");
      // if(userCredential.user != null){
      // }
    } on FirebaseAuthException catch(e){
      print("something went wrong"+e.message.toString());
      print("error code"+e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //return const Placeholder();
    return Scaffold(
      body: showLoader ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/user.png"),
            const SizedBox(height: 12,),
            const Text("login", style: TextStyle(color: Colors.amber, fontSize: 24),),
            // const SizedBox(height: 6,),
            // TextFormField(
            //   keyboardType: TextInputType.emailAddress,
            //   controller: emailController,
            // ),
            const SizedBox(height: 6,),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: emailController,
              obscureText: false,
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
                loginUser();
              });


            }, child: const Text("Login")),
            const SizedBox(height: 12,),
            InkWell(
              child: Text("New User? Register Here"),
              onTap: (){
                Navigator.pushNamed(context, "/register");
              },
            )
            // const Text("Log your health data gor a better healthy life", style: TextStyle(color: Colors.blueGrey, fontSize: 18),)
          ],
        ),
      ),
    );
  }
}
