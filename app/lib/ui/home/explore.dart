import 'package:app/logic/activity_explore_provider.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/location_permission_requester.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/activity_explore_provider.dart';
import '../../logic/activity_explore_provider.dart';
import '../../logic/activity_explore_provider.dart';
import '../../models/activity.dart';



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
        var state=activityProvider.state;
      switch(state){
        case ActivityProviderState.loadingInProgress: 
            body=LoadInprogressWidget(); 
            break;
        case ActivityProviderState.databaseError: 
            body=DatabaseErrorWidget();
            break;
        case ActivityProviderState.locationPermissionNotGranted:
            body=LocationPermissionNotGrantedWidget();
            break;
        
        default: 
        body=ListView.builder(
            shrinkWrap: true,
            itemCount: activityProvider.activities.length,
            itemBuilder: (_, position) {
              var activity = activityProvider.activities[position];
              return ItemActivityWidget(activity);
            } 
          );
        break;

      }
      
        return Column(
          children: <Widget>[
            LocationPermissionRequester(
              textInformation: Strings.locationPermissionInfo,
              onPermissionGranted: () => loadActivites(context),
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

class LoadInprogressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
      backgroundColor: Colors.amber,
      semanticsLabel: Text("Please wait...").toString(),
      semanticsValue: Text("Please wait...").toString(),  
    ),
    );
  }
}

class LocationPermissionNotGrantedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("Sorry locationPermissionNotGranted!!!"),
    );
  }
}

class DatabaseErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Sorry DataBaseError!!!"),
    );
  }
}


/*class ActivitiesLoadedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    
    return CircularProgressIndicator(
      backgroundColor: Colors.amber,
      semanticsLabel: Text("Please wait...").toString(),
      semanticsValue: Text("Please wait...").toString(),  
    );
     /*ListView.builder(
            shrinkWrap: true,
            itemCount: activityProvider.activities.length,
            itemBuilder: (_, position) {
              var activity = activityProvider.activities[position];
              return ListTile(
                title: Text(activity.title),
                trailing: Icon(Icons.account_circle),
                onTap: () => openActivity(context, activity),
              );
            } 
          );*/
  }
}*/

class ItemActivityWidget extends StatefulWidget{

Activity _activity;
  ItemActivityWidget(
    @required Activity activity
  ): this._activity=activity;

  @override
  _ItemActivityWidgetState createState() => _ItemActivityWidgetState();
}

class _ItemActivityWidgetState extends State<ItemActivityWidget> {
  @override
  Widget build(BuildContext context) {
   
    return ListTile(
                title: Text(widget._activity.title),
                trailing: Icon(Icons.account_circle),
                onTap: () => {},
              );;
  }
}




