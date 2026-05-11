import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';

import '../utils/app_utils.dart';
import 'disceasedict_homeScreen.dart';


class Disclamierscreen extends StatefulWidget{

  const Disclamierscreen({super.key});

  @override
  State<Disclamierscreen> createState() => _DisclamierScreenState();
}

class _DisclamierScreenState extends State<Disclamierscreen>{

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: ColorUtils.selectedColor,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //1--image
          Image.asset(AssetImages.disclamierImage,height: 300,),
          SizedBox(height: 20,),
          //2--content Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("The information provided in this app is for general educational purposes only."
                " It is not intended to replace professional medical advice, diagnosis, or treatment. Each individual’s health condition is different, and symptoms or disease progression may vary from person to person. Always consult a qualified healthcare professional if you feel unwell or have any concerns. We are not responsible for any outcomes, misinterpretation, "
                "or misuse of the information provided. "
                "Use this app for knowledge and awareness only, not for self-diagnosis or treatment.",
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ),

          //3--checkbox
          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: isChecked,
              onChanged:(value){
                setState(() {
                  isChecked = value!;
                });
              },

              title:
              Text("I am aware that this app is for reference only and not for medical advice.",style: TextStyle(fontSize: 18),),

          ),

          SizedBox(height: 20,),

          //4--button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
              backgroundColor: ColorUtils.selectedColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            ),

            onPressed:isChecked ? (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DisceaseDictionary()));
              } : null ,
            child: Text("Continue",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),

          ),
        ],
      ),
    );
  }

}