import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/my_date_util.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';
import 'package:we_chat/screens/chat_screen.dart';
import 'package:we_chat/widgets/dialogs/profile_dialog.dart';

import '../screens/view_profile_screen.dart';

class UserSelectCard extends StatefulWidget {
  final ChatUser user;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const UserSelectCard({
    super.key,
    required this.user,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<UserSelectCard> createState() => _UserSelectCardState();
}

class _UserSelectCardState extends State<UserSelectCard> {
  bool _isSelected = false;
  int unreadMessageCount = 0;

  @override
  void initState() {
    super.initState();
    fetchUnreadMessageCount();
    _isSelected = widget.initialValue;
  }

  //assign unreadMessageCount
  void fetchUnreadMessageCount() {
    APIs.countUnreadMessages(widget.user).then((count) {
      setState(() {
        unreadMessageCount = count;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        // margin: EdgeInsets.symmetric(
        //     horizontal: mq.width * .05, vertical: mq.height * .01),
        elevation: 0.5,
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(color: Color(0xFF5E88DA), width: 2),
        //     borderRadius: BorderRadius.circular(15)),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          ChatScreen(
                            user: widget.user,
                          )));
            },
            child: ListTile(
              //user profile picture
              leading: InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.height * .05,
                    height: mq.height * .05,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) =>
                    const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
              ),

              //user name
              title: Text(
                widget.user.name,
                style: TextStyle(
                    fontFamily: 'PoppinsSemiBold', fontSize: 14),
              ),

              //select
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Checkbox(
                value: _isSelected,
                onChanged: (newValue) {
                  setState(() {
                    _isSelected = newValue!;
                    widget.onChanged(newValue);
                  });
                },
              ) ,
              ],
            )
          // trailing: Text(
          //   '12:00 PM',
          //   style: TextStyle(color: Colors.black54),
          // ),
        )
    ));
  }
}
