import 'package:app/models/user.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ProfileVisualisationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
  
    return _myProfil();
  }
  
}


class _myProfil extends State<ProfileVisualisationView>{


  final userNameController=TextEditingController();
  final descriptionController=TextEditingController();
  final languageController=TextEditingController();
  final contryController=TextEditingController();

  @override
  void dispose(){
    userNameController.dispose();
    descriptionController.dispose();
    languageController.dispose();
    contryController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  File _image;

  Future getImageFromCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getImageFromGall() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Profile"),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:Column(
            //mainAxisAlignment: MainAxisAlignment.,
          children: <Widget>[
            Card(
              //margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: MediaQuery.of(context).size.width/2,
                child: _image==null? new Icon(
                  Icons.account_circle,
                  size: 45.0,

                ): Image.file(
                  _image,
                fit: BoxFit.cover),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.add_photo_alternate),
                  onPressed: getImageFromGall,
                ),
                RaisedButton(
                  child: Icon(Icons.add_a_photo),
                  onPressed: getImageFromCam,
                )

              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: new TextFormField(
                      controller: userNameController,
                      decoration: new InputDecoration(
                        labelText: "Enter Username",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.isEmpty) {
                          return "Username cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),

                  ),

                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: new TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: new InputDecoration(
                        labelText: "Enter your description",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),

                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),

                  ),

                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: new TextFormField(
                      controller: languageController,
                      decoration: new InputDecoration(
                        labelText: "Spoken languages",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.isEmpty) {
                          return "Spoken laguages cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),

                  ),

                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Enter your contry",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),

                  ),

                ],
              ),
            ),



            Container(
              padding: const EdgeInsets.all(15.0),
              child: new RaisedButton(
                onPressed: (){

                  if(_formKey.currentState.validate()){
                    

                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green),
                ),
                color: Colors.green,
                child: Text(
                  "Submit".toUpperCase(),
                  style: new TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),

                ),


              ),

            )

          ],
        ),
        )

      ),
    );


  }

}