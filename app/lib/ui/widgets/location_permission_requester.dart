import 'package:app/logic/permissions_provider.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:app/ui/utils/color_operations.dart';


/// Display a button to enable the location permission and an informative text
/// 
/// Renders an empty container if the permission is already granted (not visible)
///
/// The informative text [textInformation] is required and have to describe
/// why the permission is needed
/// You can also provide a callback [onPermissionGranted] that will call the
/// function when the location permission IS granted.
class LocationPermissionRequester extends StatelessWidget {

  final String textInformation;
  final Function onPermissionGranted;

  LocationPermissionRequester({@required this.textInformation, this.onPermissionGranted});

  @override
  Widget build(BuildContext context) {
    var primary = Theme.of(context).colorScheme.primary;
    var back = primary.withOpacity(0.2);
    var front = ColorOperations.darken(primary, 0.25);
    return Consumer<LocationPermissionProvider>(
      builder: (_, permissionsProvider, __) {
       return  permissionsProvider.location == null || permissionsProvider.location == PermissionState.granted
          ? Container()
          : Container(
            color: back,
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.screenPaddingValue,
              vertical: Dimens.smallSpacing
            ),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(
                  textInformation,
                  style: TextStyle(color: front),
                )),
                Button(
                    child: Text(Strings.enable),
                    onPressed: () => handleOnEnable(context),
                  ),
              ],
            ),
          );
      }
    );
  }

  /// Request the location permission and call the [onPermissionGranted] callback
  handleOnEnable(context) async {
    var provider = Provider.of<LocationPermissionProvider>(context, listen: false);
    await provider.requestLocationPermission();
    if (provider.location == PermissionState.granted && onPermissionGranted != null)
      onPermissionGranted();
  }
}