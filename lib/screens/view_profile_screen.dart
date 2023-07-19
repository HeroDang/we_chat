import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/my_date_util.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
// import 'package:we_chat/screens/button_contact.dart';

//view profiles screen -- to view profile of user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  bool _isContacted = false;
  bool _showContacted = false;
  @override
void initState() {
  super.initState();
  // _isContacted = true;
}
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      // onTap: () => FocusScope.of(context).unfocus(),
      onTap: (){
        if (!_isContacted) {
          // Nếu người dùng chưa được kết bạn, xử lý sự kiện click trên button ở đây
          setState(() {
            _isContacted = true;
          });
        }

      },

      child: Scaffold(
          //app bar
          appBar: AppBar(
            title: Text(widget.user.name),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style: TextStyle(color: Colors.black54, fontSize: 16)),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),

                  // User profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),

                  //for adding some space
                  SizedBox(height: mq.height * .03),

                  Text(widget.user.email,
                      style: TextStyle(color: Colors.black87, fontSize: 16)),

                  //for adding some space
                  SizedBox(height: mq.height * .02),

                  //for user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(widget.user.about,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                    ],
                  ),
                  Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                           _showContacted
                            ? Text(
                              'Contacted',
                               style: TextStyle(
                                  color: Colors.teal,
                                   fontWeight: FontWeight.bold,
                                   fontSize: 16,
                                  ),
                               )
                            : ElevatedButton(
                           onPressed: () {
                            bool showContacted = !_isContacted;
                            setState(() {
                            _isContacted = true;
                            _showContacted = showContacted;
                        });
                       },
                         child: Text('Add Contact'),
                        ),
                      ],
               ),
                ],
              ),
            ),
          )),
    );
  }
}
