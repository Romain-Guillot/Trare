import 'dart:io';

import 'package:app/logic/profile_provider.dart';
import 'package:app/models/user.dart';
import 'package:app/repositories/profile_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';





class ProfileEditView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _ProfileEditViewState();
  }

}


class _ProfileEditViewState extends State<ProfileEditView>{

  final userNameController=TextEditingController();
  final languageController=TextEditingController();
  

  @override
  void dispose(){
    userNameController.dispose();
    languageController.dispose();
    super.dispose();
  }



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
          child: Column(
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

             EditProfileTextfieldList(),


            ],

          ),
        ),
      ),

    );
  }

}







class EditProfileTextfieldList extends StatefulWidget{

  @override
  _EditProfileTextfieldListState createState() => _EditProfileTextfieldListState();
}

class _EditProfileTextfieldListState extends State<EditProfileTextfieldList> {
  final _formKey = GlobalKey<FormState>();

  final userNameController=TextEditingController();

  final languageController=TextEditingController();
  final ageController=TextEditingController();

  final descriptionController=TextEditingController();

  final contryController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Column(
      //mainAxisAlignment: MainAxisAlignment.,
      children: <Widget>[

        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[

              EditProfileTextfield(
                controller: userNameController,
                labelText: "Enter Username",
                errorMessage: "Username cannot be empty",
              ),

              EditProfileTextfield(
                controller: descriptionController,
                labelText: "Enter your description",
              ),

              EditProfileTextfield(
                controller: ageController,
                labelText: "Enter your age",
              ),

              EditProfileTextfield(
                controller: languageController,
                labelText: "Spoken languages",
                errorMessage:  "Spoken laguages cannot be empty",

              ),
              EditProfileTextfield(
                controller: contryController,
                labelText:  "Enter your contry",
              ),

            ],
          ),
        ),



        Container(
          padding: const EdgeInsets.all(15.0),
          child: new RaisedButton(
            onPressed: (){

              if(_formKey.currentState.validate()){
                String userName=userNameController.text;
                String description=descriptionController.text;
                int age=int.parse(ageController.text);
                String language=languageController.text;
                String country=contryController.text;

                User user=new User(
                  name: userName,
                  description: description, 
                  age: age, 
                  spokenLanguages: language, 
                  country: country,
                  urlPhoto: null);
                  ProfileProvider _ProfileProvider;
                  FiresoreProfileRepository _FiresoreProfileRepository;
                  _ProfileProvider.editUser(user);
                  _FiresoreProfileRepository.editUser(user);
                
                
                


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
    );
  }
}


class EditProfileTextfield extends StatelessWidget{
  TextEditingController controller;
  String labelText;
  String errorMessage;
  //Function(String) validator;

  EditProfileTextfield({this.controller, this.labelText, this.errorMessage});

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.all(15.0),
      child: new TextFormField(
        controller: controller,
        decoration: new InputDecoration(
          labelText: labelText,
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
            return errorMessage;
          }else{
            return null;
          }
        },
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      ),

    );

  }

}



