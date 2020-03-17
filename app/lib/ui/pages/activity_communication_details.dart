
import 'package:app/logic/activity_communication_provider.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/widgets/activities_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// TODO(romain)
class ActivityCommunicationDetails extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityCommunicationProvider>(
      builder: (_, provider, __) {
        return ListView(
          children: <Widget>[
            ItemActivity(
              activity: provider.activity,
              onPressed: () => openActivity(context, provider.activity),
            ),
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