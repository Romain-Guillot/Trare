import 'package:app/activities/activity_user_provider.dart';
import 'package:app/shared/res/dimens.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/widgets/activities_widgets.dart';
import 'package:app/shared/widgets/error_widgets.dart';
import 'package:app/shared/widgets/loading_widgets.dart';
import 'package:app/shared/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';



/// Page to display the list of the activities created by the connected user
/// 
/// It used the [ActivityUserProvider] provider that is responsible to load the
/// user activities and to maintain a state depending (loading in progress,
/// database error, etc.). Here, we use a [Consumer] to listen this state and
/// display the widget accordingly :
/// - The [ListItemsActivities] if the user acitvities are loaded
/// - The [LoadingWidget] if the loading is in progress
/// - The [ErrorWidgetWithReload] if an error occured. It will displays a button
///   to try to reload the user activites
///
/// A floating action button is also rendered in the main Scaffold to open the
/// activity creation page, it's the [AddActivityFAB] widget
class UserActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddActivityFAB(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: Dimens.screenPadding,
              child: PageHeader(
                title: Text(Strings.userActivitiesTitle),
              ),
            ),
            Expanded(
              child: Consumer<ActivityUserProvider>(
                builder: (_, userActivitiesProvider, __) {
                  switch (userActivitiesProvider.state) {
                    case ActivityUserProviderState.loaded:
                      return ListItemsActivities(
                        key: GlobalKey(),
                        activities: userActivitiesProvider.activities,
                      );

                    case ActivityUserProviderState.loading:
                     return LoadingWidget();
                     
                    case ActivityUserProviderState.error:
                    case ActivityUserProviderState.idle:
                    default:
                     return ErrorWidgetWithReload(
                       message: Strings.userActivitiesError,
                       onReload: () => reloadActivities(context),
                     );
                  }
                } 
              ),
            )
          ],
        ),
      ),
    );
  }

  reloadActivities(context) {
    Provider.of<ActivityUserProvider>(context, listen: false).loadActivities();
  }
}