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
import 'package:app/shared/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:app/main.dart';



/// Display the chat details for an activity
///
/// It take the [activityCommunciation] associated with the activity, and it
/// will displayed the followwing componenet :
/// - the [ItemActivity] to be able to see the activity page
/// - the list of interested user 
/// - the list of participants
/// 
/// Note: if the user IS NOT the creator of the activity, the interested users
/// list will be empty, so nothing will be displayed (as only the creator can
/// see the interested users)
/// 
/// Each interested user will be displayed with an [AcceptRejectButtonBar] to
/// let the creator add or reject the user request.
class ChatParticipantsPage extends StatelessWidget {
  
  final ActivityCommunication activityCommunication;
  Activity get activity => activityCommunication.activity;

  ChatParticipantsPage({
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
          empty: Text(Strings.noParticipant),
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



/// Button bar to accept of reject an user as participant of the activity chat
///
/// Display two buttons, one to accept the request (it will called the [onAccept]
/// function), and one to reject the user request (it will called the [onReject]
/// function)
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
    if (mounted) // at the end of the operation, the widget is maybe no longer in the tree 
      setState(() => inProgress = false);
  }
}