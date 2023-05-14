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

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
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
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFF5E88DA), width: 2),
            borderRadius: BorderRadius.circular(15)),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(
                            user: widget.user,
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
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => ProfileDialog(user: widget.user));
                      },
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
                        if (_message != null &&
                            _message!.fromId != widget.user.id &&
                            _message!.read.isEmpty)
                          const Icon(
                            Icons.check_circle_outlined,
                            color: Colors.blue,
                            size: 14,
                          ),
                        Text(
                          _message != null
                              ? _message!.type == Type.image
                                  ? 'image'
                                  : _message!.msg
                              : widget.user.about,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: 'PoppinsRegular', fontSize: 13),
                        ),
                      ],
                    ),

                    //last message time
                    trailing: _message == null
                        ? null // show nothing when no message id sent
                        : _message!.read.isEmpty &&
                                _message!.fromId != APIs.user.uid
                            ?
                            //show for unread message
                            Column(
                                children: [
                                  Text(
                                    MyDateUtil.getLastMessageTime(
                                        context: context, time: _message!.sent),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 11),
                                  ),
                                  SizedBox(
                                    height: mq.height * .01,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      (unreadMessageCount - 1) <= 9
                                          ? (unreadMessageCount - 1).toString()
                                          : (unreadMessageCount - 1) <= 20
                                              ? '9+'
                                              : 'N',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'PoppinsRegular',
                                          color: Color(0xFFF5EDED)),
                                    ),
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF5E88DA),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  )
                                ],
                              )
                            :
                            //message sent time
                            Column(
                                children: [
                                  Text(
                                    MyDateUtil.getLastMessageTime(
                                        context: context, time: _message!.sent),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 11),
                                  ),
                                  SizedBox(
                                    height: mq.height * .01,
                                  ),
                                ],
                              )
                    // trailing: Text(
                    //   '12:00 PM',
                    //   style: TextStyle(color: Colors.black54),
                    // ),
                    );
              },
            )));
  }
}
