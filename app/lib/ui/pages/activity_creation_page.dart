import 'package:app/logic/profile_provider.dart';
import 'package:app/models/activity.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:app/ui/widgets/app_text_field.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:app/ui/widgets/flat_app_bar.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';



/// Page (scaffold) to create a new activity
///
/// TODO
class ActivityCreationPage extends StatefulWidget {
  @override
  _ActivityCreationPageState createState() => _ActivityCreationPageState();
}

class _ActivityCreationPageState extends State<ActivityCreationPage> {

  final activityCreationFormKey = GlobalKey<_ActivityFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlatAppBar(
        action: ActivityCreationButton(
          activityCreationFormKey: activityCreationFormKey,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.screenPaddingValue),
          child: Column(
            children: <Widget>[
              PageHeader(
                subtitle: Text(Strings.activityCreationDescription),
              ),
              FlexSpacer.big(),
              ActivityForm(
                key: activityCreationFormKey,
              )
            ],
          ),
        ),
      ),
    );
  }
}



////
///
///
class ActivityCreationButton extends StatefulWidget {

  final GlobalKey<_ActivityFormState> activityCreationFormKey;

  ActivityCreationButton({@required this.activityCreationFormKey});

  @override
  _ActivityCreationButtonState createState() => _ActivityCreationButtonState();
}

class _ActivityCreationButtonState extends State<ActivityCreationButton> {

  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Button(
      child: Text("Add the activity"),
      onPressed: handleSubmit,
    );
  }

  handleSubmit() {
    var activity = widget.activityCreationFormKey.currentState.getActivity();
    if (activity != null) {
      setState(() => inProgress = true);
      // TODO(dioul)
      // bool success = << create activity provider function >>
      bool success = false; // TODO(dioul) ==> à supprimer 
      setState(() => inProgress = false);
      success ? handleSuccess() : handleError();
    }
  }

  handleSuccess() {
    var parentRoute = ModalRoute.of(context);
    var canPop = parentRoute?.canPop ?? false;
    if (canPop)
      Navigator.pop(context);
    else
      showSnackbar(context: context, content: Text("Successs"));
  }

  handleError() {
    showSnackbar(
      context: context, 
      content: Text("Error activity creation"), 
      critical: true
    );
  }
}



///
///
///
class ActivityForm extends StatefulWidget {

  ActivityForm({Key key}) : super(key: key);

  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _beginDateController = GlobalKey<FormFieldState>();
  final _endDateController = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppTextField(
            optional: false,
            labelText: "Title",
            controller: _titleController,
          ),
          FlexSpacer(),
          AppTextField(
            optional: false,
            labelText: "Description",
            controller: _descriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
          ),
          FlexSpacer(),
          DateTimePicker(
            label: "Begin date",
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(3000),
          ),
          FlexSpacer(),
          DateTimePicker(
            label: "End date",
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(3000),
          ),
          FlexSpacer(),
          Text("Location")
        ],
      ),
    );
  }

  ///
  Activity getActivity() {
    var currentUser = Provider.of<ProfileProvider>(context, listen: false).user;
    if (currentUser != null && _formKey.currentState.validate()) {
      return Activity(
        title: _titleController.text,
        description: _titleController.text,
        createdDate: DateTime.now(),
        user: currentUser,
        beginDate: _beginDateController.currentState.value,
        endDate: _endDateController.currentState.value,
        location: null,
      );
    }
    if (currentUser == null)
      handeInvalidUserAccount();
    return null;
  }

  ///
  handeInvalidUserAccount() {
    showSnackbar(
      context: context, 
      content: Text(Strings.unexpectedError)
    );
  }
}


class DateTimePicker extends FormField<DateTime> {

  static final dateFormat = DateFormat.yMMMd();  

  DateTimePicker({
    @required String label,
    @required DateTime initialDate,
    @required DateTime firstDate,
    @required DateTime lastDate
  }) : super(
    validator: (date) => initialDate == null ? "Invalid" : null,
    initialValue: initialDate,
    builder: (state) {
      var context = state.context;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FlexSpacer.small(),
          FlatButton.icon(
            icon: Icon(Icons.calendar_today),
            label: Text(dateFormat.format(state.value)),
            color: Theme.of(context).colorScheme.surface,
            onPressed: () async {
              var date = await showDatePicker(
                context: context, 
                initialDate: initialDate, 
                firstDate: firstDate,
                lastDate: lastDate
              );
              state.didChange(date);
            }
          ),
        ],
      );
    }
  );
}
