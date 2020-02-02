import 'dart:io';

import 'package:app/logic/profile_provider.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/widgets/app_text_field.dart';
import 'package:app/ui/shared/widgets/buttons.dart';
import 'package:app/ui/shared/widgets/default_profile_picture.dart';
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
          padding: Dimens.screenPadding,
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



///
///
///
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
      child: Text(inProgress ? Strings.loading : Strings.profileEditionSave),
      onPressed: inProgress ? null : handleSubmit,
    );
  }

  handleSubmit() async {
    var user = widget.profileFormKey.currentState.getUser();
    if (user != null) {
      setState(() => inProgress = true);
      var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      bool success = await profileProvider.editUser(user);
      setState(() => inProgress = false);
      success ? _showSuccessSnackbar() : _showErrorSnackbar();
    }
  }

  _showErrorSnackbar() =>
    showSnackbar(
      context: context, 
      content: Text(Strings.profileEditionError), 
      critical: true
    );
  
  _showSuccessSnackbar() =>
    showSnackbar(
      context: context, 
      content: Text(Strings.profileEditionSuccess)
    );
}



///
///
///
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
          AppTextField(
            controller: userNameController,
            labelText: Strings.profileUsername,
          ),
          FlexSpacer(),
          AppTextField(
            controller: descriptionController,
            labelText: Strings.profileDescription,
            keyboardType: TextInputType.multiline,
            maxLines: Dimens.profileDescriptionFormLineNumber,
            optional: true,
          ),
          FlexSpacer(),
          AppTextField(
            controller: ageController,
            labelText: Strings.profileAge,
            keyboardType: TextInputType.number,
            optional: true,
          ),
          FlexSpacer(),
          AppTextField(
            controller: languageController,
            labelText: Strings.profileSpokenLanguages,
            optional: true,
          ),
          FlexSpacer(),
          AppTextField(
            controller: contryController,
            labelText:  Strings.profileCountry,
            optional: true,
          ),
        ],
      ),
    );
  }

  User getUser() {
    if (_formKey.currentState.validate()){
      int age;
      try {
        age = int.parse(ageController.text);
      } catch(_) {}
      return User(
        name: userNameController.text,
        description: descriptionController.text, 
        age: age, 
        spokenLanguages: languageController.text, 
        country: contryController.text,
      );
    }
    return null;
  }
}



/// IN PROGRESS
///
/// TBD
/// 
/// TODO
///   - initial photo
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
                borderRadius: Dimens.borderRadius
              ),
              child: ClipRRect(
                borderRadius: Dimens.borderRadius,
                child: _image == null
                  ? DefaultProfilePicture()
                  : Image.file(
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
              child: Text(Strings.profileEditionPickPhoto),
              onPressed: getImageFromGall,
            ),
            Button(
              icon: Icon(Icons.add_a_photo),
              child: Text(Strings.profileEditionTakePhoto),
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