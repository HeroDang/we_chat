import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/helper/my_date_util.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';
import 'package:we_chat/screens/group_member_screen.dart';
import 'package:we_chat/screens/view_profile_screen.dart';

import '../../api/apis.dart';
import '../../main.dart';
import '../../widgets/message_cart.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all message
  List<Message> _list = [];

  //for handling message text change
  final _textController = TextEditingController();

  //showEmoji: for storing value of showing or hiding emoji
  //isUploading: for checking if image is loading or not
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
          child: WillPopScope(
        //if emoji are shown & back button is pressed then hide emoji
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   toolbarHeight: mq.height * .1,
          //   automaticallyImplyLeading: false,
          //   flexibleSpace: _appBar(),
          // ),

          // backgroundColor: const Color.fromARGB(255, 234, 248, 255),

          //body
          body: Column(
            children: [
              _appBar(),
              Container(
                child: Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          // log('Data: ${jsonEncode(data![0].data())}');
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index],
                                   preMessage:  index>0 ? _list[index-1]: _list[index],
                                );
                              },
                            );
                          } else {
                            return const Center(
                                child: Text('Say Hi!!👋',
                                    style: TextStyle(fontSize: 20)));
                          }
                      }
                    },
                  ),
                ),
              ),

              //progress indicator for showing uploading
              if (_isUploading)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),

              //chat input field
              _chatInput(),

              //show emoji on keyboard emoji button click & vice versa
              if (_showEmoji)
                SizedBox(
                  height: mq.height * .35,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                        bgColor: const Color.fromARGB(255, 234, 248, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0)),
                  ),
                )
            ],
          ),
        ),
      )),
    );
  }

  Widget _appBar() {
    return Container(
      height: mq.height * .1,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: 16),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ViewProfileScreen(user: widget.user,contact: true,)));
          },
          child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              return Row(
                children: [
                  //for adding some space
                  const SizedBox(
                    width: 10,
                  ),
                  // back button
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                      )),
                  //for adding some space
                  const SizedBox(
                    width: 10,
                  ),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .3),
                    child: CachedNetworkImage(
                      width: mq.height * .06,
                      height: mq.height * .06,
                      fit: BoxFit.cover,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),

                  //for adding some space
                  const SizedBox(
                    width: 10,
                  ),

                  // user name and last seen time
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //user name
                        Text(
                          list.isNotEmpty ? list[0].name : widget.user.name,
                          overflow: TextOverflow.ellipsis, // default is .clip
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'PoppinsSemiBold',
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        //for adding some space
                        const SizedBox(
                          height: 2,
                        ),
                        // last seen time of user
                        Flexible(
                          child: Text(
                            list.isNotEmpty
                                ? list[0].isOnline
                                    ? 'Online'
                                    : MyDateUtil.getLastActiveTime(
                                        context: context,
                                        lastActive: list[0].lastActive)
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: widget.user.lastActive),
                            overflow: TextOverflow.ellipsis, // default is .clip
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5E88DA),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       CupertinoIcons.video_camera,
                  //       color: Color(0xFF5E88DA),
                  //       size: 36,
                  //     )),
                  // IconButton(
                  //     onPressed: () {
                  //       Navigator.push(context,MaterialPageRoute(builder: (context) => GroupMemberScreen()),);
                  //     },
                  //     icon: const Icon(
                  //       Icons.group_add,
                  //       color: Color(0xFF5E88DA),
                  //       size: 30,
                  //     )),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                ],
              );
            },
          )),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Container(
      height: mq.height * .1,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: mq.height * .01, horizontal: mq.width * .03),
        child: Row(
          children: [
            //input field & buttons
            Expanded(
                child: Card(
              color: Color(0xFFF8F8F8),
              shadowColor: Colors.transparent,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Color(0xFF5E88DA),
                        size: 25,
                      )),

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    style: TextStyle(fontFamily: 'Poppins'),
                    decoration: const InputDecoration(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF8D8D8D),
                      ),
                      border: InputBorder.none,
                    ),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick multiple images.
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        //uploading & sending image one by one
                        for (var i in images) {
                          setState(() => _isUploading = true);
                          log('image Path: ${i.path}');
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.photo,
                        color: Color(0xFF5E88DA),
                        size: 26,
                      )),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('image Path: ${image.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.camera,
                        color: Color(0xFF5E88DA),
                        size: 26,
                      )),
                  // adding some space
                  // SizedBox(
                  //   width: mq.width * .02,
                  // )
                ],
              ),
            )),

            //send message button
            MaterialButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  if (_list.isEmpty) {
                    //on first message (add user to my_user collection of chat user)
                    APIs.sendFirstMessage(
                        widget.user, _textController.text, Type.text);
                  } else {
                    //simply send message
                    APIs.sendMessage(
                        widget.user, _textController.text, Type.text);
                  }
                  _textController.text = '';
                }
              },
              minWidth: 0,
              // padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
              // shape: const CircleBorder(),
              // color: Color(0xFF5E88DA),
              child: const Icon(
                Icons.send,
                color: Color(0xFF5E88DA),
                size: 28,
              ),
            )
          ],
        ),
      ),
    );
  }
}
