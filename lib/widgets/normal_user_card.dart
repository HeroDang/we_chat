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

class NormalUserCard extends StatefulWidget {
  final ChatUser user;

  const NormalUserCard({super.key, required this.user});

  @override
  State<NormalUserCard> createState() => _NormalUserCardState();
}

class _NormalUserCardState extends State<NormalUserCard> {
  //last message o=info (if nill --> no message)
  Message? _message;

  int unreadMessageCount = 0;

  @override
  void initState() {
    super.initState();
    fetchUnreadMessageCount();
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
        margin: EdgeInsets.symmetric(
            horizontal: mq.width * .05, vertical: mq.height * .01),
        elevation: 0.5,
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(color: Color(0xFF5E88DA), width: 2),
        //     borderRadius: BorderRadius.circular(15)),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ViewProfileScreen(
                        user: widget.user, contact: false,
                      )));
            },
            child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final _list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (_list.isNotEmpty) {
                  _message = _list[0];
                }

                return ListTile(
                  //user profile picture
                    leading: InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .3),
                        child: CachedNetworkImage(
                          width: mq.height * .06,
                          height: mq.height * .06,
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
                          fontFamily: 'PoppinsSemiBold', fontSize: 16),
                    ),

                    //last message
                    subtitle: Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.user.email,
                            // maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'PoppinsRegular', fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    //last message time
                    // trailing: Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Icon(
                    //       Icons.circle,
                    //       color: widget.user.isOnline ? Color.fromRGBO(0, 255, 0, 1) : Color.fromRGBO(255, 0, 0, 1),
                    //       size: 16,
                    //     ),],)
                  // trailing: Text(
                  //   '12:00 PM',
                  //   style: TextStyle(color: Colors.black54),
                  // ),
                );
              },
            )));
  }
}
