import 'package:app/logic/permissions_provider.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:app/ui/utils/color_operations.dart';


class LocationPermissionRequester extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var primary = Theme.of(context).colorScheme.primary;
    return Consumer<PermissionsProvider>(
      builder: (_, permissionsProvider, __) => 
        permissionsProvider.location == null || permissionsProvider.location == PermissionState.granted
          ? Container()
          : Container(
            color: primary.withOpacity(0.2),
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.screenPaddingValue,
              vertical: Dimens.smallSpacing
            ),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(
                  "Enable the location permission to look for activities near you",
                  style: TextStyle(color: ColorOperations.darken(primary, 0.25)),
                )),
                Button(
                    child: Text("Enable"),
                    onPressed: () {
                      permissionsProvider.requestLocationPermission();
                    },
                  ),
              ],
            ),
          )
    );
  }
}