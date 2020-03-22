import 'package:app/shared/res/dimens.dart';
import 'package:flutter/widgets.dart';


enum _FlexSpacerType {normal, big, small}


/// Widget used to add spacing (padding) between widgets
/// 
/// Used typically in [Row] or [Column].
class FlexSpacer extends StatelessWidget {

  final _FlexSpacerType spaceType;

  /// Create a normal spacer : [Dimens.normalSpacing]
  FlexSpacer() : spaceType = _FlexSpacerType.normal;

  /// Create a small spacer : [Dimens.smallSpacing]
  FlexSpacer.small() : spaceType = _FlexSpacerType.small;

  /// Create a big spacer : [Dimens.bigSpacing]
  FlexSpacer.big() : spaceType = _FlexSpacerType.big;

  @override
  Widget build(BuildContext context) {
    var space;
    switch (spaceType) {
      case _FlexSpacerType.normal:
        space = Dimens.normalSpacing;
        break;
      case _FlexSpacerType.small:
        space = Dimens.smallSpacing;
        break;
      case _FlexSpacerType.big:
        space = Dimens.bigSpacing;
        break;
    }
    return SizedBox(
      width: space,
      height: space,
    );
  }
}