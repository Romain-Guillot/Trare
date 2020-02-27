import 'dart:math';

import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



/// Convenient widget to build a [TextFormField] with some parameters
///
/// It builds a TextFormField with a the [labelText] above and validate the
/// input content based on the parameters, e.g [optionnal], [maxLength], 
/// [minLength], etc. If you want to provide an additionnal validator behavior
/// you can add it with [customValidator]. Be careful though, it will NOT
/// replace the current validator behavior, it will "just" add new rules
/// to the existing validor rules.
/// 
/// You can define the input as a [TextInputType.number] field with the 
/// [keyboardType] propery. If so, you can also provide the [minValue] and
/// the [maxValue]. These properties will only work with this specific type
/// of keyboard. They will be ignored for other keyboard type. 
class AppTextField extends StatelessWidget {

  final TextEditingController controller;
  final String labelText;
  final Function(String) customValidator;
  final bool optional;
  final TextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final int minLength;
  final int minValue;
  final int maxValue;


  AppTextField({
    @required this.controller, 
    @required this.labelText, 
    this.customValidator,
    this.keyboardType = TextInputType.text,
    this.optional = false,
    this.maxLength,
    this.minLength,
    this.minValue,
    this.maxValue,
    this.maxLines = Dimens.formMultiLinesDefaultLinesNumber
  });


  @override
  Widget build(BuildContext context) {
    final noBorder = OutlineInputBorder(
      borderRadius: Dimens.borderRadius,
      borderSide: BorderSide(color: Colors.transparent)
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelText, 
          style: Theme.of(context).inputDecorationTheme.labelStyle,
        ),
        FlexSpacer.small(),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: keyboardType == TextInputType.multiline ? null : 1,
          minLines: keyboardType == TextInputType.multiline ? max(maxLines, 5) : 1,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: optional ? Strings.optionalTextField : Strings.requiredTextField,
            contentPadding: EdgeInsets.all(10),
            border: noBorder,
            disabledBorder: noBorder,
            enabledBorder: noBorder,
            focusedBorder: noBorder,
            errorBorder: noBorder,
            focusedErrorBorder: noBorder,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          buildCounter: buildCounter,
          validator: validator
        ),
      ],
    );
  }


  /// Build a counter text length for the input decoration
  ///
  /// It only dispays a counter if a [minLength] is provide AND if the 
  /// current input text length if inferior to this minLength
  /// 
  /// The maxLength is directly constraint with the inputDecoration, so the
  /// value never exceed the [maxLength]
  Widget buildCounter(context, {int currentLength, int maxLength, bool isFocused,}) {
    currentLength = controller.text.trim().length;
    if (minLength != null && currentLength != 0 && currentLength < minLength) {
      var theme = Theme.of(context);
      var style = theme.inputDecorationTheme.counterStyle.copyWith(color: theme.colorScheme.error);
      return Text(Strings.textFieldMinLengthCounter(minLength - currentLength), style: style,);
    }
    return null;
  }


  /// Return a non null string is the input is not valid
  ///
  /// The input is not values if :
  ///   - a customValidator is provide and it returned an error
  ///   - the value length if inferior to minLenght or superior to maxLength
  ///   - the field is a number text field and the value if inferior to minValue
  ///     or superior to maxValue
  ///   - the field is NOT optionnal but the value is empty
  /// 
  /// The first condition if the least important, the last is the most important
  /// (so if the last condition is true, it will be the final error, and the
  /// previous one will be ignored)
  String validator(String val) {
    val = val.trim();
    String error;
    if (customValidator != null)
      error = customValidator(val);
    if (minLength != null && val.length > 0 && val.length < minLength)
      error = Strings.invalidFormTooShort;
    if (keyboardType == TextInputType.number) {
      try {
        int value = int.parse(val);
        if (minValue != null && value < minValue || maxValue != null && value > maxValue)
          error = Strings.invalidFormRangeValue(min: minValue, max: maxValue);
      } catch (_) {}
    }
    if (error == null && !optional && val.isEmpty)
      error = Strings.invalidFormEmpty;

    return error;
  }
}