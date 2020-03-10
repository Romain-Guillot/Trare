import 'dart:async';
import 'dart:math';

import 'package:app/models/activity.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/widgets/activities_widgets.dart';
import 'package:app/ui/widgets/error_widgets.dart';
import 'package:app/ui/widgets/loading_widgets.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';




class UserActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Consumer<MockProvider>(
              builder: (_, userActivitiesProvider, __) {
                switch (userActivitiesProvider.state) {
                  case MockEnum.loaded:
                    return Expanded(
                      child: ListItemsActivities(
                        key: GlobalKey(),
                        activities: userActivitiesProvider.activities,
                      )
                    );
                  case MockEnum.inprogress:
                   return LoadingWidget();
                  case MockEnum.error:
                  default:
                   return ErrorWidgetWithReload(
                     message: Strings.userActivitiesError,
                     onReload: () => reloadActivities(context),
                   );
                }
              } 
            )
          ],
        ),
      ),
    );
  }

  reloadActivities(context) {
    Provider.of<MockProvider>(context, listen: false).load();
  }
}








// MOCK MOCK MOCK MOCK MOCK MOCK 
// Juste pour tester
// MOCK MOCK MOCK MOCK MOCK MOCK 

enum MockEnum {loaded, inprogress, error}


class MockProvider extends ChangeNotifier {

  MockEnum state = MockEnum.inprogress;

  var activities = List<Activity>.generate(999, (i) => Activity(
    title: "Title",
    beginDate: DateTime.now(),
    endDate: DateTime.now(),
    createdDate: DateTime.now(),
    description: "",
    location: null,
    user: null
  ));

  init() async {
    await Future.delayed(Duration(seconds: 2));
    Timer.periodic(Duration(seconds: 4), (t)  {
      state = Random().nextBool() ? MockEnum.error : MockEnum.loaded; 
      notifyListeners();
    });
  }

  load() {
    state = MockEnum.inprogress;
    notifyListeners();
  }
}