import 'package:app/logic/activity_provider.dart';
import 'package:app/logic/permissions_provider.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/utils/color_operations.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Explore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListItemsActivities(),
        ),
      )
    );
  }
}

class ListItemsActivities extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (_, activityProvider, __) {
        Widget body; 
        if (activityProvider.activities == null) {
          body = Text("Loading");
        } else {
          body = ListView.builder(
            shrinkWrap: true,
            itemCount: activityProvider.activities.length,
            itemBuilder: (_, position) {
              var activity = activityProvider.activities[position];
              return ListTile(
                title: Text(activity.title),
                // subtitle: Text(activity.location),
                trailing: Icon(Icons.account_circle),
                onTap: () => openActivity(context, activity),
              );
            } 
          );
        }
        return Column(
          children: <Widget>[
            LocationPermissionRequester(),
            body
          ],
        );        
      }
    );
  }

  openActivity(context, activity) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ActivityPage(activity: activity)
    ));
  } 
}


class LocationPermissionRequester extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var primary = Theme.of(context).colorScheme.primary;
    return Consumer<PermissionsProvider>(
      builder: (_, permissionsProvider, __) => 
        permissionsProvider.location == null || permissionsProvider.location != PermissionState.granted
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