import 'package:app/logic/authentication_provider.dart';
import 'package:app/logic/profile_provider.dart';
import 'package:app/ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


class ProfileVisualisationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
            final user = profileProvider.user;

            if (!profileProvider.isInit)
              return Text("Loading...");
            if (profileProvider.error)
              return Text("An error occured");

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LayoutBuilder(
                      builder: (_, constraints) => Placeholder(
                      fallbackHeight: constraints.maxWidth,
                      fallbackWidth: constraints.maxWidth,
                    ),
                  ),
                  Container(
                    padding: Values.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(user.name??"Unknown", style: Theme.of(context).textTheme.title,),
                            Expanded(child: Container()),
                            FlatButton(
                              child: Text("Edit"),
                              textColor: Theme.of(context).colorScheme.primary,
                              onPressed: () {},
                            )
                          ],
                        ),
                        ProfileItem(label: "Description", content: user.description),
                        ProfileItem(label: "Country", content: user.country),
                        ProfileItem(label: "Spoken languages", content: user.spokenLanguages),
                        SizedBox(height: 40),
                        Center(
                          child: FlatButton(
                            child: Text("Sign out"),
                            color: Theme.of(context).colorScheme.error,
                            textColor: Theme.of(context).colorScheme.onError,
                            onPressed: () {
                              Provider.of<AuthenticationProvider>(context, listen: false).signOut();
                            },
                          ),
                        )
                      ],
                    )
                  )
                ],
              );
          }
        ),
      )
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String label;
  final String content;

  ProfileItem({@required this.label, @required this.content});
  
  @override
  Widget build(BuildContext context) {
    return content == null || content.isEmpty
    ? Container()
    : Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.subtitle),
          Text(content)
        ],
      ),
    );
  }

}