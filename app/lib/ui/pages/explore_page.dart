import 'package:app/logic/activity_explore_provider.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/activities_widgets.dart';
import 'package:app/ui/widgets/error_widgets.dart';
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
/// 
/// A floating action button is also rendered in the main Scaffold to open the
/// activity creation page, it's the [AddActivityFAB] widget
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
                      case ActivityExploreProviderState.loaded: 
                        return ListItemsActivities(
                          key: GlobalKey(),
                          activities: activityProvider.activities
                        );

                      case ActivityExploreProviderState.inProgress: 
                        return LoadingWidget(); 
                      
                      case ActivityExploreProviderState.locationPermissionNotGranted:
                        return LocationPermissionRequester(
                          textInformation: Strings.locationPermissionInfo,
                          onPermissionGranted: () => loadActivites(context)
                        );   
                      
                      case ActivityExploreProviderState.error: 
                      default:
                        return ErrorWidgetWithReload(
                          message: Strings.databaseErrorInfo,
                          onReload: () => loadActivites(context),
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