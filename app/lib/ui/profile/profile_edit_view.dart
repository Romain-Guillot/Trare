import 'dart:io';

import 'package:app/logic/profile_provider.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/values.dart';
import 'package:app/ui/shared/widgets/buttons.dart';
import 'package:app/ui/shared/widgets/flex_spacer.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

///
/// Stateful widget to not lose form data (as we give a special key)
class ProfileEditView extends StatefulWidget{

  final User user;

  ProfileEditView({
    Key key, 
    @required this.user
  }) : super(key: key);

  @override
  _ProfileEditViewState createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  
  final profileFormKey = GlobalKey<_ProfileFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          SaveButton(profileFormKey: profileFormKey)
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: Values.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Strings.profileEditionInfo, 
                style: Theme.of(context).textTheme.display1,
              ),
              FlexSpacer(big: true,),
              ProfileForm(
                key: profileFormKey,
                initialUser: widget.user
              ),
            ],
          )
        ),
      ),
    );
  }
}


class SaveButton extends StatefulWidget {

  final GlobalKey<_ProfileFormState> profileFormKey;

  SaveButton({@required this.profileFormKey});

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {

  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Button(
      child: Text(inProgress ? "Loading..." : "Save"),
      onPressed: inProgress ? null : handleSubmit,
    );
  }

  handleSubmit() async {
    var user = widget.profileFormKey.currentState.getUser();
    if (user != null) {
      setState(() => inProgress = true);
      bool success = await Provider.of<ProfileProvider>(context, listen: false).editUser(user);
      setState(() => inProgress = false);
      if (!success)
        showSnackbar(context: context, content: Text("An error occured"), critical: true);
      else
        showSnackbar(context: context, content: Text("Profile successufully updated"));
    }
  }
}



class ProfileForm extends StatefulWidget {
  final User initialUser;
  
  ProfileForm({
    Key key, 
    @required this.initialUser
  }) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {

  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final languageController = TextEditingController();
  final ageController = TextEditingController();
  final descriptionController = TextEditingController();
  final contryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialUser != null) {
      userNameController.text = widget.initialUser.name;
      languageController.text = widget.initialUser.spokenLanguages;
      ageController.text = widget.initialUser.age?.toString();
      descriptionController.text = widget.initialUser.description;
      contryController.text = widget.initialUser.country;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          UploadPhotoFormField(),
          FlexSpacer(),
          EditProfileTextfield(
            controller: userNameController,
            labelText: Strings.profileUsername,
          ),
          FlexSpacer(),
          EditProfileTextfield(
            controller: descriptionController,
            labelText: Strings.profileDescription,
            keyboardType: TextInputType.multiline,
            optionnal: true,
          ),
          FlexSpacer(),
          EditProfileTextfield(
            controller: ageController,
            labelText: Strings.profileAge,
            keyboardType: TextInputType.number,
            optionnal: true,
          ),
          FlexSpacer(),
          EditProfileTextfield(
            controller: languageController,
            labelText: Strings.profileSpokenLanguages,
            optionnal: true,
          ),
          FlexSpacer(),
          EditProfileTextfield(
            controller: contryController,
            labelText:  Strings.profileCountry,
            optionnal: true,
          ),
        ],
      ),
    );
  }

  User getUser() {
    if (_formKey.currentState.validate()){
      var user = User(
        name: userNameController.text,
        description: descriptionController.text, 
        age: int.parse(ageController.text), 
        spokenLanguages: languageController.text, 
        country: contryController.text,
      );
      return user;
    }
    return null;
  }
}


class UploadPhotoFormField extends StatefulWidget {
  @override
  _UploadPhotoFormFieldState createState() => _UploadPhotoFormFieldState();
}

class _UploadPhotoFormFieldState extends State<UploadPhotoFormField> {

  File _image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(
            builder: (_, constraints) => Container(
              height: constraints.maxWidth,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: Values.borderRadius
              ),
              child: _image == null 
                ? Icon(
                    Icons.account_circle,
                    size: 45.0,
                  )
                : ClipRRect(
                    borderRadius: Values.borderRadius,
                    child: Image.file(
                      _image,
                      fit: BoxFit.cover
                    ),
                ),
            ),
          ),
        ),
        FlexSpacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Button(
              icon: Icon(Icons.add_photo_alternate),
              child: Text("Add photo"),
              onPressed: getImageFromGall,
            ),
            Button(
              icon: Icon(Icons.add_a_photo),
              child: Text("Take photo"),
              onPressed: getImageFromCam,
            )
          ],
        ),
      ],
    );
  }

  Future getImageFromCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() => _image = image);
  }

  Future getImageFromGall() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => _image = image);
  }
}




class EditProfileTextfield extends StatelessWidget{

  final TextEditingController controller;
  final String labelText;
  final Function(String) customValidator;
  final bool optionnal;
  final TextInputType keyboardType;

  EditProfileTextfield({
    this.controller, 
    this.labelText, 
    this.customValidator,
    this.keyboardType = TextInputType.text,
    this.optionnal = false
  });

  @override
  Widget build(BuildContext context) {
    final noBorder = OutlineInputBorder(
      borderRadius: Values.borderRadius,
      borderSide: BorderSide(color: Colors.transparent)
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelText, 
          style: Theme.of(context).inputDecorationTheme.labelStyle,
        ),
        FlexSpacer(small: true),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: keyboardType == TextInputType.multiline ? null : 1,
          minLines: keyboardType == TextInputType.multiline ? 5 : 1,
          
          decoration: InputDecoration(
            hintText: optionnal ? "Optionnal" : "Required",
            contentPadding: EdgeInsets.all(10),
            border: noBorder,
            disabledBorder: noBorder,
            enabledBorder: noBorder,
            focusedBorder: noBorder,
            errorBorder: noBorder,
            focusedErrorBorder: noBorder,
            filled: true,
          ),
          validator: (val) {
            String error;
            if (customValidator != null)
              error = customValidator(val);
            if (error == null && !optionnal && val.isEmpty)
              error = "Cannot be empty";
            return error;
          }
        ),
      ],
    );
  }
}






