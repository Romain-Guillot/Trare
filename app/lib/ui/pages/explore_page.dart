import 'package:app/logic/activity_explore_provider.dart';
import 'package:app/ui/pages/activity_creation_page.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/activities_widgets.dart';
import 'package:app/ui/widgets/loading_widgets.dart';
import 'package:app/ui/widgets/location_permission_requester.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



/// Page to display a list a activities that can be interesting for the user
/// 
/// It used the [ActivityExploreProvider] to retrieve this list of activities.
/// Depending on the provider state, it will display the follwing widget :
///   - the activities are loaded : [ListItemsActivities]
///   - activity loading in progress : [LoadingWidget]
///   - a database error occured : [DatabaseErrorWidget]
///   - the location permission is not granted (but needed) : [LocationPermissionRequester]
///   - the floating action button [AddActivityFAB] to open the activity 
///     creation page ([ActivityCreationPage]).
class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddActivityFAB(),
      body: SafeArea(
        child: Column(
            children: <Widget>[
              Padding(
                padding: Dimens.screenPadding,
                child: PageHeader(
                  title: Text(Strings.exploreTitle),
                  subtitle: Text(Strings.exploreDescription),
                ),
              ),
               Expanded(
                child: Consumer<ActivityExploreProvider>(
                  builder: (_, activityProvider, __) {
                    switch (activityProvider.state) {
                      case ActivityProviderState.loadingInProgress: 
                        return LoadingWidget(); 
                      case ActivityProviderState.databaseError: 
                        return DatabaseErrorWidget();
                      case ActivityProviderState.locationPermissionNotGranted:
                        return LocationPermissionRequester(
                          textInformation: Strings.locationPermissionInfo,
                          onPermissionGranted: () => loadActivites(context)
                        );   
                      case ActivityProviderState.activitiesLoaded:
                      default: 
                        return ListItemsActivities(
                          key: GlobalKey(),
                          activities: activityProvider.activities
                        );
                    }
                  }
                ),
              ),
            ],
          ),
        ),
    
    );
  }

  loadActivites(context) {
    Provider.of<ActivityExploreProvider>(context, listen: false).loadActivities();
  }
}



/// Floating action button to open the [ActivityCreationPage]
///
/// An extended floating action button with a label and an icon. The pressed
/// action push a new route to open the [ActivityCreationPage]
class AddActivityFAB extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(Icons.add),
      foregroundColor: Colors.white,
      label: Text(Strings.addActivity),
      onPressed: () => openActivityCreationPage(context),
    );
  }

  openActivityCreationPage(context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ActivityCreationPage(),
    ));
  }
}











/// this is a simple widget that will be displayed when the state of our 
/// [ActiviyExploreProvider] LocationPermissionNotGrant 
class DatabaseErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.databaseErrorInfo),
    );
  }
}



