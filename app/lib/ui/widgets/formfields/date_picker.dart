import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


///
///
///
class DateTimePicker extends FormField<DateTime> {

  static final dateFormat = DateFormat.yMMMd();  

  DateTimePicker({
    Key key,
    @required String label,
    @required DateTime initialDate,
    @required DateTime firstDate,
    @required DateTime lastDate,
    String Function(DateTime) validator,
  }) : super(
    key: key,
    validator: validator??((_) => null),
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
