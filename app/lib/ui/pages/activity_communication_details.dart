
import 'package:app/logic/activity_communication_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// TODO(romain)
class ActivityCommunicationDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityCommunicationProvider>(
      builder: (_, provider, __) => Text("TODO Romain")
    );
  }
}