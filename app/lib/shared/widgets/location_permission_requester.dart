import 'package:app/shared/providers/permissions_provider.dart';
import 'package:app/shared/res/dimens.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/utils/color_operations.dart';
import 'package:app/shared/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


/// Display an informative text with a button to enable or grant the location
/// 
/// It use the [LocationPermissionProvider] to know the current location
/// status, and here we consider 3 cases :
/// - neverAskAgain or denied => ask the user to grant the location permission
/// - restricted or diasbled => ask the user to enable the location service
/// - other => display a default error with a retry action
///
/// You can also provide a callback [onPermissionGranted] that will call the
/// function when the location permission IS granted.
class LocationPermissionRequester extends StatelessWidget {

  final Function onPermissionGranted;

  LocationPermissionRequester({@required this.onPermissionGranted});

  @override
  Widget build(BuildContext context) {

    return Consumer<LocationPermissionProvider>(
      builder: (_, permissionsProvider, __) {
        switch (permissionsProvider.location) {
          case PermissionStatus.neverAskAgain:
          case PermissionStatus.denied:
            return PermissionCardRequester(
              label: Text(Strings.locationPermissionDenied),
              button: Button(
                child: Text(Strings.grant),
                onPressed: () => handleOnGrant(context),
              ),
            );
          case PermissionStatus.restricted:
            return PermissionCardRequester(
              label: Text(Strings.locationPermissionDisabled),
              button: Button(
                child: Text(Strings.enable),
                onPressed: () => handleOnEnable(context),
              ),
            );
          case PermissionStatus.granted:
          default:
            return PermissionCardRequester(
              label: Text(Strings.locationPermissionUnknonw),
              button: Button(
                child: Text(Strings.reload),
                onPressed: () => onPermissionGranted(),
              ),
            );
        }
      }
    );
  }

  /// Request the location permission and call the [onPermissionGranted] callback
  handleOnEnable(context) async {
    var provider = Provider.of<LocationPermissionProvider>(context, listen: false);
    await provider.enableLocation();
    if (provider.location == PermissionStatus.granted && onPermissionGranted != null)
      onPermissionGranted();
  }

  handleOnGrant(context) async {
    var provider = Provider.of<LocationPermissionProvider>(context, listen: false);
    await provider.requestLocationPermission();
    if (provider.location == PermissionStatus.granted && onPermissionGranted != null)
      onPermissionGranted();
  }
}



/// Display an informative text with a button to trigger an action
class PermissionCardRequester extends StatelessWidget {

  final Widget label;
  final Button button;

  PermissionCardRequester({
    @required this.label,
    @required this.button
  });

  @override
  Widget build(BuildContext context) {
    var primary = Theme.of(context).colorScheme.primary;
    var back = primary.withOpacity(0.2);
    var front = ColorOperations.darken(primary, 0.25);
    return Container(
      color: back,
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.screenPaddingValue,
        vertical: Dimens.smallSpacing
      ),
      child: Row(
        children: <Widget>[
          DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText1.copyWith(color: front),
            child: Expanded(child: label)
          ),
          button
        ],
      ),
    );
  }
}