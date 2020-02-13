import 'package:app/logic/activity_provider.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/location_permission_requester.dart';
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
    return Consumer<ActivityExploreProvider>(
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
            LocationPermissionRequester(
              textInformation: Strings.locationPermissionInfo,
              onChecked: () => loadActivites(context),
            ),
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


  loadActivites(context) {
    Provider.of<ActivityExploreProvider>(context, listen: false).loadActivities();
  }
}


