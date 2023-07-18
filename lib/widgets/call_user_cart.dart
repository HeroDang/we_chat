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

class CallUserCard extends StatefulWidget {
  final ChatUser user;

  const CallUserCard({super.key, required this.user});

  @override
  State<CallUserCard> createState() => _CallUserCardState();
}

class _CallUserCardState extends State<CallUserCard> {
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
                      builder: (_) => ViewProfileScreen(user: widget.user)));
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
                        //messages were read
                        if (_message != null &&
                            _message!.fromId != widget.user.id &&
                            _message!.read.isNotEmpty)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.blue,
                            size: 14,
                          ),
                        //message weren't read
                        // if (_message != null &&
                        //     _message!.fromId != widget.user.id &&
                        //     _message!.read.isEmpty)
                        //   const Icon(
                        //     Icons.check_circle_outlined,
                        //     color: Colors.blue,
                        //     size: 14,
                        //   ),
                        Text(
                          "incoming call",
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: 'PoppinsRegular', fontSize: 13),
                        ),
                        SizedBox(width: 12,),
                        Icon(
                            Icons.circle,
                            color: Colors.black54,
                            size: 8,
                          ),
                        SizedBox(width: 4,),
                        Text(
                        "12:00",
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: 'PoppinsRegular', fontSize: 13),
                        ),
                      ],
                    ),

                    //last message time
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(
                            Icons.call,
                            color: Colors.black54,
                            size: 24,
                          ),],)
                    // trailing: Text(
                    //   '12:00 PM',
                    //   style: TextStyle(color: Colors.black54),
                    // ),
                    );
              },
            )));
  }
}
