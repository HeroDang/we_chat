import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/dialog.dart';
import 'package:we_chat/helper/my_date_util.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  final Message preMessage;



  const MessageCard({super.key, required this.message, required this.preMessage});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late int difference;
  @override
  void initState(){
    difference = int.parse(widget.message.sent) - int.parse(widget.preMessage.sent);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return Container(
      child: isMe ? _roundedMessage() : _outlineMessage(),
    );
    // return InkWell(
    //   onLongPress: () {
    //     _showBottomSheet(isMe);
    //   },
    //   child: isMe ? _roundedMessage() : _outlineMessage(),
    // );
  }

  //sender or another user message
  Widget _outlineMessage() {
    //update last read message if sender and receiver are difference are difference
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: mq.width * .04, vertical: mq.height * .01),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //message content
        Container(
            constraints: BoxConstraints(maxWidth: mq.width * .7),
            padding: EdgeInsets.all(
                widget.message.type == Type.image ? 0 : mq.width * .04),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF5E88DA)),
                //making borders radius
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: InkWell(
              onLongPress: () {
                _showBottomSheet(APIs.user.uid == widget.message.fromId);
              },
              child: widget.message.type == Type.text
                  ?
                  //show text
                  Text(
                      widget.message.msg,
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    )
                  :
                  //shw image
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(Icons.image, size: 70),
                        ),
                      ),
                    ),
            )),

        //message time
        
         Container(
          decoration: BoxDecoration(
              color: Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(7)),
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.only(top: 4),
          child: Text(
            MyDateUtil.getMessageTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),

       
      ]),
    );

    // return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    //   //message content
    //   Flexible(
    //     child: Container(
    //       padding: EdgeInsets.all(widget.message.type == Type.image
    //           ? mq.width * .03
    //           : mq.width * .04),
    //       margin: EdgeInsets.symmetric(
    //           horizontal: mq.width * .04, vertical: mq.height * .01),
    //       decoration: BoxDecoration(
    //           color: Color.fromARGB(255, 221, 245, 255),
    //           border: Border.all(color: Colors.lightBlue),
    //           //making borders radius
    //           borderRadius: const BorderRadius.only(
    //               topLeft: Radius.circular(30),
    //               topRight: Radius.circular(30),
    //               bottomRight: Radius.circular(30))),
    //       child: widget.message.type == Type.text
    //           ?
    //           //show text
    //           Text(
    //               widget.message.msg,
    //               style: TextStyle(fontSize: 15, color: Colors.black87),
    //             )
    //           :
    //           //shw image
    //           ClipRRect(
    //               borderRadius: BorderRadius.circular(15),
    //               child: CachedNetworkImage(
    //                 imageUrl: widget.message.msg,
    //                 placeholder: (context, url) => const Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: const CircularProgressIndicator(
    //                     strokeWidth: 2,
    //                   ),
    //                 ),
    //                 errorWidget: (context, url, error) => const CircleAvatar(
    //                   child: Icon(Icons.image, size: 70),
    //                 ),
    //               ),
    //             ),
    //     ),
    //   ),

    //   //message time
    //   Padding(
    //     padding: EdgeInsets.only(right: mq.width * .04),
    //     child: Text(
    //       MyDateUtil.getMessageTime(
    //           context: context, time: widget.message.sent),
    //       style: const TextStyle(fontSize: 13, color: Colors.black54),
    //     ),
    //   ),
    // ]);
  }

  //our or user message
  Widget _roundedMessage() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: mq.width * .04, vertical: mq.height * .01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              constraints: BoxConstraints(maxWidth: mq.width * .7),
              padding: EdgeInsets.all(
                  widget.message.type == Type.image ? 0 : mq.width * .04),
              decoration: BoxDecoration(
                  color: Color(0xFF5E88DA),
                  //making borders radius
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: InkWell(
                onLongPress: () {
                  _showBottomSheet(APIs.user.uid == widget.message.fromId);
                },
                child: widget.message.type == Type.text
                    ?
                    //show text
                    Text(
                        widget.message.msg,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'Poppins'),
                      )
                    :
                    //show image
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            child: Icon(Icons.image, size: 70),
                          ),
                        ),
                      ),
              )),

          ////message time
          UnconstrainedBox(
            child: 
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(7)),
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //read time
                  Text(
                    MyDateUtil.getMessageTime(
                        context: context, time: widget.message.sent),
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontFamily: 'Poppins'),
                  ),

                  //for adding some space
                  const SizedBox(
                    width: 2,
                  ),

                  //double tick blue icon for message read
                  if (widget.message.read.isNotEmpty)
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF7EBD4C),
                      size: 20,
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    // return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    //   //message time
    //   Row(
    //     children: [
    //       // for adding some space
    //       SizedBox(
    //         width: mq.width * .04,
    //       ),

    //       //double tick blue icon for message read
    //       if (widget.message.read.isNotEmpty)
    //         const Icon(
    //           Icons.done_all_rounded,
    //           color: Colors.blue,
    //           size: 20,
    //         ),

    //       //for adding some space
    //       const SizedBox(
    //         width: 2,
    //       ),

    //       //read time
    //       Text(
    //         MyDateUtil.getMessageTime(
    //             context: context, time: widget.message.sent),
    //         style: const TextStyle(
    //             fontSize: 13, color: Colors.black54, fontFamily: 'Poppins'),
    //       ),
    //     ],
    //   ),

    //   //message content
    //   Flexible(
    //     child: Container(
    //       padding: EdgeInsets.all(widget.message.type == Type.image
    //           ? mq.width * .03
    //           : mq.width * .04),
    //       margin: EdgeInsets.symmetric(
    //           horizontal: mq.width * .04, vertical: mq.height * .01),
    //       decoration: BoxDecoration(
    //           color: Color(0xFF5E88DA),
    //           // border: Border.all(color: Colors.lightGreen),
    //           //making borders radius
    //           borderRadius: const BorderRadius.all(Radius.circular(16))),
    //       child: widget.message.type == Type.text
    //           ?
    //           //show text
    //           Text(
    //               widget.message.msg,
    //               style: TextStyle(
    //                   fontSize: 15,
    //                   color: Colors.white,
    //                   fontFamily: 'Poppins'),
    //             )
    //           :
    //           //shw image
    //           ClipRRect(
    //               borderRadius: BorderRadius.circular(15),
    //               child: CachedNetworkImage(
    //                 imageUrl: widget.message.msg,
    //                 placeholder: (context, url) => const Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: const CircularProgressIndicator(
    //                     strokeWidth: 2,
    //                   ),
    //                 ),
    //                 errorWidget: (context, url, error) =>
    //                     const CircleAvatar(
    //                   child: Icon(Icons.image, size: 70),
    //                 ),
    //               ),
    //             ),
    //     ),
    //   ),
    // ]);
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);
                          Dialogs.showSnackbar(context, 'Text copied');
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          log('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'We Chat')
                              .then((success) {
                            //for hiding bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Image Successfully Saved');
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImg: $e');
                        }
                      }),

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              if (widget.message.type == Type.text && isMe)
                //edit option
                _OptionItem(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: 26,
                    ),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),
              //read time
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                    size: 26,
                  ),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message'),
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                initialValue: updatedMsg,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //action
              actions: [
                //cancel button
                MaterialButton(
                  onPressed: () {
                    //Hide Alert Dialog
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
                //update button
                MaterialButton(
                  onPressed: () {
                    //Hide Alert Dialog
                    Navigator.pop(context);
                    APIs.updateMessage(widget.message, updatedMsg);
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ));
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            top: mq.height * .015,
            left: mq.width * .05,
            bottom: mq.height * .015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: const TextStyle(
                  color: Colors.black54, fontSize: 16, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
