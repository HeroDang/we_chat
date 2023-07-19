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
import 'package:we_chat/screens/search_screen.dart';
import 'package:we_chat/widgets/normal_user_card.dart';
import 'package:we_chat/widgets/user_card.dart';


import '../screens/view_profile_screen.dart';

class AddFriendsScreen extends StatefulWidget {

  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  //last message o=info (if nill --> no message)
  Message? _message;

  int unreadMessageCount = 0;
  List<ChatUser> _list = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: SafeArea(
          child: Scaffold(
                backgroundColor: Colors.white,
                //app bar
                body: Column(
                  children: [
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: _searchBtn()),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 20),
                    //   child: TabBar(
                    //     unselectedLabelColor: Colors.black,
                    //     labelColor: Color(0xFF5E88DA),
                    //     unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                    //     labelStyle:
                    //         TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 18),
                    //     tabs: [
                    //       Tab(
                    //         text: 'Add Friends',
                    //       ),
                    //     ],
                    //     // controller: _tabController,
                    //     indicatorSize: TabBarIndicatorSize.label,
                    //     indicatorColor: Color(0xFFF1F1F1),
                    //     indicatorWeight: 4,
                    //     indicatorPadding: EdgeInsets.symmetric(vertical: 8),
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                        child: 
                            StreamBuilder(
                              stream: APIs.getMyUsersId(),

                              //get id of only know user
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  //if data is loading
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );

                                  //if some or all data is loaded then show it
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    return StreamBuilder(
                                      stream: APIs.getUsers(snapshot
                                              .data?.docs
                                              .map((e) => e.id)
                                              .toList() ??
                                          []),

                                      //get only those user, who's ids are provide
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          //if data is loading
                                          case ConnectionState.waiting:
                                          case ConnectionState.none:
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );

                                          //if some or all data is loaded then show it
                                          case ConnectionState.active:
                                          case ConnectionState.done:
                                            final data = snapshot.data?.docs;
                                            _list = data
                                                    ?.map((e) =>
                                                        ChatUser.fromJson(
                                                            e.data()))
                                                    .toList() ??
                                                [];

                                            if (_list.isNotEmpty) {
                                              return ListView.builder(
                                                itemCount: _list.length,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return NormalUserCard(
                                                      user: _list[index]);
                                                },
                                              );
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      'No Connections Found',
                                                      style: TextStyle(
                                                          fontSize: 20)));
                                            }
                                        }
                                      },
                                    );
                                
                                }
                              },
                            ),
                      ),
                    ),
                  ],
                )),
        ),
      ),
    );
  }
Widget _searchBtn() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SearchScreen(isHome: false)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            Icon(CupertinoIcons.search),
            SizedBox(width: 8),
            Text(
              'Search',
              style: const TextStyle(
                color: Color(0xFF252525),
                fontFamily: 'Poppins',
                fontSize: 16,
                letterSpacing: 0.5,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
