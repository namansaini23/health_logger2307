import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HealthLoggerPage extends StatefulWidget {
  const HealthLoggerPage({super.key});

  @override
  State<HealthLoggerPage> createState() => _HealthLoggerPageState();
}

class _HealthLoggerPageState extends State<HealthLoggerPage> {

  bool showLoader = false;

  TextEditingController bpLowController = new TextEditingController();
  TextEditingController bpHighController = new TextEditingController();
  TextEditingController sugarController = new TextEditingController();

  void addHealthData() async{
    print("BP Low: "+bpLowController.text.trim());
    print("BP High: "+bpHighController.text.trim());
    print("Sugae: "+sugarController.text.trim());

    try{
       var uid = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance.collection("users").doc(uid).collection("health").add(
      {
      "bpHigh": int.parse(bpHighController.text.trim()),
      "bpLow": int.parse(bpLowController.text.trim()),
        "sugar": int.parse(sugarController.text.trim()),
      "createdOn": DateTime.now()
      }
      ).then((value) => Navigator.pop(context));


    } on FirebaseAuthException catch(e){
      print("something went wrong"+e.message.toString());
      print("error code"+e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //return const Placeholder();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Health Details"),

      ),
      body: showLoader ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/bp.png", width: 64, height: 64,),
            const SizedBox(height: 12,),
            const Text("ADD heath data", style: TextStyle(color: Colors.amber, fontSize: 24),),
            const SizedBox(height: 6,),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: bpHighController,
              decoration: const InputDecoration(
                labelText: "Enter BP High",
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: bpLowController,
              decoration: InputDecoration(
                  labelText: "Enter BP Low",

              ),
            ),
            const SizedBox(height: 6,),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: sugarController,
              decoration: InputDecoration(
                  labelText: "Enter Sugar Level",
                  filled: true
              ),
            ),
            const SizedBox(height: 6,),
            OutlinedButton(onPressed: (){
              setState(() {
                showLoader = true;
                addHealthData();
              });
            }, child: const Text("Log Heath Data")),
            const SizedBox(height: 12,),
            // InkWell(
            //   child: Text("Existing User? Login Here"),
            //   onTap: (){
            //     Navigator.pushNamed(context, "/login");
            //   },
            //)
            // const Text("Log your health data gor a better healthy life", style: TextStyle(color: Colors.blueGrey, fontSize: 18),)
          ],
        ),
      ),
    );
  }
}
