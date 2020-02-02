import 'package:app/logic/authentication_provider.dart';
import 'package:app/logic/profile_provider.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/shared/assets.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/shared/values.dart';
import 'package:app/ui/shared/widgets/buttons.dart';
import 'package:app/ui/shared/widgets/flex_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


class ProfileVisualisationView extends StatefulWidget {
  @override
  _ProfileVisualisationViewState createState() => _ProfileVisualisationViewState();
}


class _ProfileVisualisationViewState extends State<ProfileVisualisationView> {

  @override
  void initState() {
    super.initState();
      Future.microtask(() => loadUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
            switch (profileProvider.state) {
              case ProfileProviderState.not_initialized:
                return ProfileLoading();
              case ProfileProviderState.error:
                return ProfileError(onPressed: loadUser);
              case ProfileProviderState.initialized:
              default: 
                return ProfileView(user: profileProvider.user);
            }
          }
        ),
      )
    );
  }

  loadUser() {
    Provider.of<ProfileProvider>(context, listen: false).loadUser();
  }
}


class ProfileLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.profileLoading)
    );
  }
}


class ProfileError extends StatelessWidget {

  final Function onPressed;
  
  ProfileError({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(Strings.profileError),
          FlexSpacer(),
          Button(
            child: Text(Strings.profileErrorRetry),
            critical: true,
            onPressed: onPressed,
          )
        ],
      ),
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
        ProfilePicture(
          url: user.urlPhoto
        ),
        Container(
          padding: Values.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfileHeader(
                user: user, 
                onEdit: () {},
              ),
              ProfileItemList(
                user: user,
              ),
              FlexSpacer(
                big: true
              ),
              Center(
                child: ProfileSignOutButton()
              )
            ],
          )
        )
      ],
    );
  }
}


class ProfileSignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Button(
      child: Text(Strings.profileSignOut),
      critical: true,
      onPressed: () => onSubmit(context)
    );
  }

  onSubmit(context) {
    Provider.of<AuthenticationProvider>(context, listen: false).signOut();
  }
}


class ProfileHeader extends StatelessWidget {
  final User user;
  final Function onEdit;
  
  ProfileHeader({@required this.user, @required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final username = user.name??Strings.profileUnknownName;
    return Row(
      children: <Widget>[
        Text(username, style: Theme.of(context).textTheme.title,),
        Expanded(child: Container()),
        Button(
          child: Text(Strings.profileEdit),
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
    return   
        LayoutBuilder(
          builder: (_, constraints) { 
            final size = constraints.maxWidth;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                boxShadow: [Values.shadow]
              ),
              child: url == null
              ? Center(
                  child: SvgPicture.asset(
                    Assets.defaultProfilePicture, 
                    height: size / 2,
                    color: Colors.black.withOpacity(0.3),
                  ),
                )
              : Image.network(
                  url,
                  width: size,
                  height: size,
                  fit: BoxFit.fitWidth,
                  cacheHeight: Values.maxImageResolution,
                )
            );
          }
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
        ProfileItem(
          label: Strings.profileDescription, 
          content: user.description
        ),
        ProfileItem(
          label: Strings.profileAge,
          content: user.age.toString(),
        ),
        ProfileItem(
          label: Strings.profileCountry, 
          content: user.country
        ),
        ProfileItem(
          label: Strings.profileSpokenLanguages, 
          content: user.spokenLanguages
        ),
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
    : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.subtitle),
        Text(content),
        FlexSpacer()
      ],
    );


  }
}
