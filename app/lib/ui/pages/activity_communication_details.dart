import 'package:app/logic/activity_communication_provider.dart';
import 'package:app/models/user.dart';
import 'package:app/ui/pages/activity_page.dart';
import 'package:app/ui/shared/dimens.dart';
import 'package:app/ui/shared/strings.dart';
import 'package:app/ui/utils/snackbar_handler.dart';
import 'package:app/ui/widgets/activities_widgets.dart';
import 'package:app/ui/widgets/buttons.dart';
import 'package:app/ui/widgets/error_widgets.dart';
import 'package:app/ui/widgets/flex_spacer.dart';
import 'package:app/ui/widgets/loading_widgets.dart';
import 'package:app/ui/widgets/page_header.dart';
import 'package:app/ui/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:app/main.dart';



///
///
///
class ActivityCommunicationDetails extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityCommunicationProvider>(
      builder: (_, provider, __) {
        switch (provider.state) {
          case ActivityCommunicationState.loaded:
            return ListView(
              key: GlobalKey(), // because the items can changed
              children: <Widget>[
                ItemActivity(
                  activity: provider.activity,
                  onPressed: () => openActivity(context, provider.activity),
                ),
                FlexSpacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.screenPaddingValue),
                  child: PageHeader(
                    title: Text(Strings.participantRequestsTitle),
                  ),
                ),
                FlexSpacer(),
                UserList(
                  users: provider.activityCommunication.interestedUsers,
                  actionBuilder: (u) => AcceptRejectButtonBar(
                    user: u,
                    onAccept: () async => await onAcceptUser(context, u),
                    onReject: () async => await onRejectUser(context, u),
                  ),
                ),
                FlexSpacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.screenPaddingValue),
                  child: PageHeader(
                    title: Text(Strings.participantsTitle),
                  ),
                ),
                FlexSpacer(),
                UserList(
                  users: provider.activityCommunication.participants,
                ),
              ],
            );
          case ActivityCommunicationState.inProgress:
            return LoadingWidget();

          case ActivityCommunicationState.idle:
          case ActivityCommunicationState.error:
          default:
            return ErrorWidgetWithReload(
              message: "Unable to load data",
              onReload: ( ) {},
            );
        }
      }
    );
  }

  reloadCommunicationSystem(context) {
    var provider = Provider.of<ActivityCommunicationProvider>(context, listen: false);
    provider.load();
  }

  openActivity(context, activity) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ActivityPage(activity: activity)
    ));
  }

  Future onAcceptUser(context, user) async {
    var provider = Provider.of<ActivityCommunicationProvider>(context, listen: false);
    bool status = await provider.acceptParticipant(user);
    if (!status)
      _handleError(context);
  }

  Future onRejectUser(context, user) async {
    var provider = Provider.of<ActivityCommunicationProvider>(context, listen: false);
    bool status = await provider.rejectParticipant(user);
    if (!status)
      _handleError(context);
  }

  _handleError(context) {
    showSnackbar(
      context: context, 
      content: Text(Strings.unexpectedError),
      critical: true
    );
  }
}



///
///
///
class UserList extends StatelessWidget {

  final List<User> users;
  final Widget Function(User) actionBuilder;

  UserList({
    Key key, 
    @required this.users,
    this.actionBuilder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView.separated(
          shrinkWrap: true,
          itemCount: users.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: Dimens.normalSpacing),
          separatorBuilder: (_, __) => SizedBox(height: Dimens.normalSpacing,),
          itemBuilder: (_, index) => Column(
            children: <Widget>[
              UserCard(
                user: users[index], 
                isClickable: true,
              ),
              if (actionBuilder != null)
                actionBuilder(users[index]),
            ],
          )
        ),
      ],
    );
  }
}



///
///
///
class AcceptRejectButtonBar extends StatefulWidget {

  final User user;
  final Future Function() onAccept;
  final Future Function() onReject;

  AcceptRejectButtonBar({
    Key key, 
    @required this.user,
    @required this.onAccept,
    @required this.onReject,
  }) : super(key: key);

  @override
  _AcceptRejectButtonBarState createState() => _AcceptRejectButtonBarState();
}

class _AcceptRejectButtonBarState extends State<AcceptRejectButtonBar> {

  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.screenPaddingValue),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Button(
              icon: Icon(Icons.check),
              child: Text(Strings.participantAcceptRequest),
              onPressed: inProgress ? null : () => onAction(widget.onAccept),
            ),
          ),
          Expanded(
            child: Button(
              icon: Icon(Icons.close),
              child: Text(Strings.participantRejectRequest),
              color: Theme.of(context).colorScheme.onSurfaceLight,
              onPressed: inProgress ? null : () => onAction(widget.onReject),
            ),
          )
        ],
      ),
    );
  }

  onAction(Future Function() action) async {
    setState(() => inProgress = true);
    await action();
    if (mounted)
      setState(() => inProgress = false);
  }
}