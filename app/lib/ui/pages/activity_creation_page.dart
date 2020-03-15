import 'package:app/logic/activity_creation_provider.dart';
import 'package:app/logic/profile_provider.dart';
import 'package:app/models/activity.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:app/ui/widgets/flat_app_bar.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:app/ui/widgets/formfields/app_text_field.dart';
import 'package:app/ui/widgets/formfields/date_picker.dart';
import 'package:app/ui/widgets/maps/map_location_chooser.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';



/// Page ([Scaffold]) to create a new activity
/// 
/// It will create a scaffold with an app bar with an action button to add
/// the activity (make processes) and a body with the activity creation form.
///
/// It is composed of two main components :
/// - the [ActivityForm] responsibles to display the form to create the activity
///   and to create an [Activty] object with the [ActivityForm.makeActivity()]
/// - the [ActivityCreationButton] that retreives the activity object from
///   the form thanks to the makeActivity method seen above
/// 
/// It is a Stateful widget to keep a record of the [ActivityForm] to be able
/// to call the [ActivityForm.makeActivity()] to retreive the generated
/// activity and to communicate with a Provider to make proccesses (for example : 
/// add the activity in a database)
/// 
/// The body is wrapped inside a [SingleChildScrollView] to be able to scroll
/// the activity form
///
/// You can use the [Navigator] object to open this page :
/// 
/// ```dart
/// Navigator.of(context).push(MaterialPageRoute(
///   builder : (_) => ActivityCreationPage()
/// ))
/// ```
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
          padding: Dimens.screenPaddingBodyWithAppBar,
          child: Column(
            children: <Widget>[
              PageHeader(
                subtitle: Text(Strings.activityCreationDescription),
              ),
              FlexSpacer.big(),
              ActivityForm(
                key: activityCreationFormKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//// Button to add the activity thanks to the [ActivityCreationProvider]
///
/// It retreives the activity object form the [ActivityForm] thanks to the
/// key [activityCreationFormKey]. The [ActivityForm] has the method
/// [ActivityForm.makeActivity()] to generate an instance of the activity
/// from the form.
/// 
/// If the generated activity is not null, the proccess is delegates 
/// to the [ActivityCreationProvider] to add the activity in the database.
/// - If the process succeed, the created activity visualisation page is opened
///   ([ActivityPage])
/// - Else, an error snackbar is displayed to inform the user that an unexpected
///   error occured
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
      child: Text(Strings.addActivityButton),
      onPressed: handleSubmit,
    );
  }

  /// Retreive the activity and call the provider, then call [handleSuccess]
  /// or [handleError] depending on the process result (error, success)
  handleSubmit() async {
    var activity = widget.activityCreationFormKey.currentState.makeActivity();
    if (activity != null) {
      setState(() => inProgress = true);
      var provider = Provider.of<ActivityCreationProvider>(context, listen: false);
      activity = await provider.createActivity(activity);
      bool success = activity != null;
      setState(() => inProgress = false);
      success ? handleSuccess(activity) : handleError();
    }
  }

  /// Open the [ActivityPage] with the created activity
  handleSuccess(Activity activity) {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => ActivityPage(activity: activity),
    ));
  }

  /// Show a snackbar to warn the user that an error occured
  handleError() {
    showSnackbar(
      context: context, 
      content: Text(Strings.unexpectedError), 
      critical: true
    );
  }
}



/// Widget to display a form to let the user create a new activity
///
/// It is a basic form widget wrapped inside the [Form] widget and that contains
/// [AppTextField]s, [DateTimePicker]s and [GoogleMapLocationField] to fill
/// the activity information.
/// 
/// An [Activity] instance can be generated thanks to the [makeActivity]
/// method.
/// 
/// Usage :
/// 
/// ```dart
/// var activityCreationFormKey = GlobalKey<_ActivityFormState>();
/// 
/// ...
/// 
/// ActivityForm(
///   key: activityCreationFormKey,
/// ),
/// 
/// ...
/// 
/// var activity = activityCreationFormKey.currentState.makeActivity()
/// 
/// ```
class ActivityForm extends StatefulWidget {

  ActivityForm({Key key}) : super(key: key);

  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {

  final now = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _beginDatePickerKey = GlobalKey<FormFieldState>();
  final _endDatePickerKey = GlobalKey<FormFieldState>();
  final _locationChooserKey = GlobalKey<FormFieldState>();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppTextField(
            optional: false,
            labelText: Strings.activityTitleLabel,
            controller: _titleController,
          ),
          FlexSpacer(),
          AppTextField(
            optional: false,
            labelText: Strings.activityDescriptionLabel,
            controller: _descriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
          ),
          FlexSpacer(),
          DateTimePicker(
            key: _beginDatePickerKey,
            label: Strings.activityBeginDateLabel,
            initialDate: DateTime.now(),
            firstDate: now,
            lastDate: now.add(Duration(days: 365)),
            required: true,
          ),
          FlexSpacer(),
          DateTimePicker(
            key: _endDatePickerKey,
            label: Strings.activityEndDateLabel,
            initialDate: DateTime.now(),
            firstDate: now,
            lastDate: now.add(Duration(days: 365)),
            required: true,
            customValidator: (date) {
              DateTime beginDate = _beginDatePickerKey.currentState.value;
              return beginDate != null && date.isBefore(beginDate)
                ? Strings.errorEndDateBeforeBeginDate
                : null;
            },
          ),
          FlexSpacer(),
          GoogleMapLocationField(
            key: _locationChooserKey,
            label: Strings.activityLocationLabel,
            required: true,
          )
        ],
      ),
    );
  }


  /// Method the generate an [Activity] instance based on the form information
  /// 
  /// It returns null if the form is not valid
  Activity makeActivity() {
    if (_formKey.currentState.validate()) {
      return Activity.create(
        title: _titleController.text,
        description: _descriptionController.text,
        createdDate: DateTime.now(),
        beginDate: _beginDatePickerKey.currentState.value,
        endDate: _endDatePickerKey.currentState.value,
        location: _locationChooserKey.currentState.value,
      );
    }
    return null;
  }
}


