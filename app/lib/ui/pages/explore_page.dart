import 'package:app/logic/activity_explore_provider.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/location_permission_requester.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/activity.dart';


/// this is the principal widget that show all the awailable activity
class ExplorePage extends StatelessWidget {
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
            body=LocationPermissionRequester(
              textInformation: Strings.locationPermissionInfo,
              onPermissionGranted: () => loadActivites(context),
              );
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

/// this is a simple [CircularProgressIndicator] that will be displayed when the state of our [ActiviyExploreProvider] is LoadingInprogress
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

/// this is a simple widget that will be displayed when the state of our [ActiviyExploreProvider] LocationPermissionNotGrant 
class DatabaseErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.databaseErrorInfo),
    );
  }
}
class ItemActivityWidget extends StatelessWidget{

Activity _activity;
  ItemActivityWidget(
    @required Activity activity
  ): this._activity=activity;

  @override
  Widget build(BuildContext context) {
   
    return ListTile(
                title: Text(_activity.title),
                trailing: Icon(Icons.account_circle),
                onTap: () => {},
              );
  }
}





