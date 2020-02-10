import 'package:app/logic/activity_provider.dart';
import 'package:app/models/activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Explore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListItemsActivities(),
    ));
  }
}

class ListItemsActivities extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (_, activityProvider, __) {
        if (activityProvider.activities == null) {
          return Text("Loading");
        } else {
          return ListView.builder(
            itemCount: activityProvider.activities.length,
            itemBuilder: (_, position) {
              var activity = activityProvider.activities[position];
              return ListTile(
                title: Text(activity.title),
                subtitle: Text(activity.location),
                trailing: Icon(Icons.account_circle),
              );
            } 
          );
        }
      }
    );
  }
}