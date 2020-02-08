import 'package:app/ui/shared/widgets/app_layout.dart';
import 'package:app/ui/shared/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Activity {
  String title = "Randonnée au mont tremblant";
  String description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin hendrerit ligula eu malesuada ultricies. Morbi sed venenatis enim. Sed convallis egestas tristique. In quis enim eu ante porta dignissim. Sed velit est, consequat ac massa blandit, porttitor viverra urna. Aenean pretium sagittis enim non tempus. Morbi eget varius urna.";
  DateTime createdDate = DateTime.now();
  DateTime beginDate = DateTime(2020, 2, 10);
  DateTime endDate = DateTime(2020, 2, 15);
}


class ActivityView extends StatelessWidget {

  final Activity activity;

  ActivityView({Key key, @required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlatAppBar(
        action: Button(
          child: Text("I'm interested"),
          onPressed: () {},
        )        
      ),

      body: Container(),
    );
  }
}