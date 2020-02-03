import 'dart:math';

import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/widgets/flex_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class AppTextField extends StatelessWidget {

  final TextEditingController controller;
  final String labelText;
  final Function(String) customValidator;
  final bool optional;
  final TextInputType keyboardType;
  final int maxLines;

  AppTextField({
    this.controller, 
    this.labelText, 
    this.customValidator,
    this.keyboardType = TextInputType.text,
    this.optional = false,
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
        FlexSpacer(small: true),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: keyboardType == TextInputType.multiline ? null : 1,
          minLines: keyboardType == TextInputType.multiline ? min(maxLines, 5) : 1,
          
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
            fillColor: Theme.of(context).colorScheme.surface
          ),
          validator: (val) {
            String error;
            if (customValidator != null)
              error = customValidator(val);
            if (error == null && !optional && val.isEmpty)
              error = Strings.invalidForm;
            return error;
          }
        ),
      ],
    );
  }
}