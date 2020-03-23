import 'package:app/activities/activity_page.dart';
import 'package:app/chats/participants/participants_provider.dart';
import 'package:app/shared/models/activity.dart';
import 'package:app/shared/models/activity_communication.dart';
import 'package:app/shared/models/user.dart';
import 'package:app/shared/res/dimens.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/shared/utils/snackbar_handler.dart';
import 'package:app/shared/widgets/activities_widgets.dart';
import 'package:app/shared/widgets/buttons.dart';
import 'package:app/shared/widgets/flex_spacer.dart';
import 'package:app/shared/widgets/page_header.dart';
import 'package:app/shared/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:app/main.dart';



///
///
///
class ActivityCommunicationDetails extends StatelessWidget {
  
  final ActivityCommunication activityCommunication;
  Activity get activity => activityCommunication.activity;

  ActivityCommunicationDetails({
    Key key, 
    @required this.activityCommunication
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      key: GlobalKey(), // because the items can changed
      children: <Widget>[
        ItemActivity(
          activity: activity,
          onPressed: () => openActivity(context, activity),
        ),
        FlexSpacer(),
        UserList(
          title: Text(Strings.participantRequestsTitle),
          users: activityCommunication.interestedUsers,
          actionBarBuilder: (u) => AcceptRejectButtonBar(
            user: u,
            onAccept: () async => await onAcceptUser(context, u),
            onReject: () async => await onRejectUser(context, u),
          ),
        ),
        FlexSpacer(),
        UserList(
          title: Text(Strings.participantsTitle),
          users: activityCommunication.participants,
          empty: Text("No participant yet"),
        ),
      ],
    );
  }



  openActivity(context, activity) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ActivityPage(activity: activity)
    ));
  }

  Future onAcceptUser(context, user) async {
    var provider = Provider.of<ParticipantsProvider>(context, listen: false);
    bool status = await provider.acceptParticipant(user);
    if (!status)
      _handleError(context);
  }

  Future onRejectUser(context, user) async {
    var provider = Provider.of<ParticipantsProvider>(context, listen: false);
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

  final Widget title;
  final Widget empty;
  final List<User> users;
  final Widget Function(User) actionBarBuilder;

  UserList({
    Key key, 
    @required this.title,
    @required this.users,
     this.empty,
    this.actionBarBuilder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (empty == null && (users == null || users.isEmpty))
      return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.screenPaddingValue),
          child: PageHeader(
            title: title,
          ),
        ),
        if (users == null || users.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.screenPaddingValue),
            child: empty
          ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: users?.length??0,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: Dimens.normalSpacing),
          separatorBuilder: (_, __) => SizedBox(height: Dimens.normalSpacing,),
          itemBuilder: (_, index) => Column(
            children: <Widget>[
              UserCard(
                user: users[index], 
                isClickable: true,
              ),
              if (actionBarBuilder != null)
                actionBarBuilder(users[index]),
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