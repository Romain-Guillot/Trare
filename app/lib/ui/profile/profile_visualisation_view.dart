import 'package:app/logic/authentication_provider.dart';
import 'package:app/logic/profile_provider.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/shared/values.dart';
import 'package:app/ui/shared/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


class ProfileVisualisationView extends StatefulWidget {
  @override
  _ProfileVisualisationViewState createState() => _ProfileVisualisationViewState();
}


class _ProfileVisualisationViewState extends State<ProfileVisualisationView> {

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).loadUser();
  }

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
            return ProfileView(user: user);
          }
        ),
      )
    );
  }
}


class ProfileView extends StatelessWidget {
  final User user;
  
  ProfileView({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfilePicture(url: user.urlPhoto),
        Container(
          padding: Values.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfileHeader(user: user, onEdit: () {},),
              ProfileItemList(user: user,),
              SizedBox(height: 40),
              Center(
                child: Button(
                  child: Text("Sign out"),
                  critical: true,
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
}


class ProfileHeader extends StatelessWidget {
  final User user;
  final Function onEdit;
  
  ProfileHeader({@required this.user, @required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(user.name??"Unknown", style: Theme.of(context).textTheme.title,),
        Expanded(child: Container()),
        Button(
          child: Text("Edit"),
          onPressed: onEdit,
        )
      ],
    );
  }
}


class ProfilePicture extends StatelessWidget {
  final String url;
  
  ProfilePicture({@required this.url});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, constraints) => Image.network(
          url,
          width: constraints.maxWidth,
          height: constraints.maxWidth,
          fit: BoxFit.fitWidth,
          cacheHeight: 720,
        )
    );
  }
}


class ProfileItemList extends StatelessWidget {
  final User user;
  
  ProfileItemList({@required this.user});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfileItem(label: "Description", content: user.description),
        ProfileItem(label: "Country", content: user.country),
        ProfileItem(label: "Spoken languages", content: user.spokenLanguages),
      ],
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
