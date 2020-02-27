import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';



/// [FormField] used to choose a specific [DateTime] (year, month, day)
///
/// It is a [FormField] so you can provide a [GlobalKey<FormFieldState>] to 
/// retreive the form value (the date).
/// 
/// ```dart
/// var datePickerKey = GlobalKey<FormFieldState>();
/// 
/// ...
/// 
/// DateTimePicker(
///   key: datePickerKey
///   label: "My field",
///   initialDate: initialDate,
///   firstDate: firstDate,
///   lastDate: lastDate,
/// )
/// 
/// ...
/// 
/// var date = datePickerKey.currentState.value;
/// ```
/// 
/// You can set the flag [required], it will display an error text if no date
/// is selected (it never happened normally as we give an initialDate)
/// You can also add you [customValidator] to validate your date.
/// For example to valdiate the date only if it is after a specific date :
/// 
/// ```dart
/// DateTimePicker(
///   ...
///   customValidator: (date) => date.isBefore(beginDate) ? "Error" : null
///   }
/// )
/// ```
class DateTimePicker extends FormField<DateTime> {

  static final dateFormat = DateFormat.yMMMd();  

  DateTimePicker({
    Key key,
    @required String label,
    @required DateTime initialDate,
    @required DateTime firstDate,
    @required DateTime lastDate,
    bool required = false,
    String Function(DateTime) customValidator,
  }) : super(
    key: key,
    validator: (date) {
      if (required && date == null)
        return Strings.requiredDate;
      if (customValidator != null)
        return customValidator(date) ;
      return null;
    },
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
                initialDate: state.value, 
                firstDate: firstDate,
                lastDate: lastDate
              );
              if (date != null)
                state.didChange(date);
            }
          ),
          if (state.hasError)
            Text(
              state.errorText, 
              style: Theme.of(context).inputDecorationTheme.errorStyle
            )
        ],
      );
    }
  );
}
