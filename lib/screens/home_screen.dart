import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/helper/dialog.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/friends_screen.dart';
import 'package:we_chat/screens/search_screen.dart';
import 'package:we_chat/widgets/call_user_cart.dart';
import 'package:we_chat/widgets/chat_user_card.dart';
import 'package:we_chat/widgets/user_card.dart';

import '../../api/apis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // for storing all user
  List<ChatUser> _list = [];
  // for storing searched item
  // final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  // late TabController _tabController;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active according to lifecycle events
    //resume --> active or online
    //pause --> inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume'))
          APIs.updateActiveStatus(true);
        if (message.toString().contains('pause'))
          APIs.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
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
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
                backgroundColor: Colors.white,
                //app bar
                body: Column(
                  children: [
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: _searchBtn()),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TabBar(
                        unselectedLabelColor: Colors.black,
                        labelColor: Color(0xFF5E88DA),
                        unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                        labelStyle:
                            TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 18),
                        tabs: [
                          Tab(
                            text: 'Chats',
                          ),
                          Tab(
                            text: 'Friends',
                          ),
                          // Tab(
                          //   text: 'Calls',
                          // )
                        ],
                        // controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Color(0xFFF1F1F1),
                        indicatorWeight: 4,
                        indicatorPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: TabBarView(
                          children: [
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
                                      stream: APIs.getAllUsers(snapshot
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
                                                  return ChatUserCard(
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
                                      stream: APIs.getAllUsers(snapshot
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
                                              return FriendsScreen(listUser: _list);
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
                            // StreamBuilder(
                            //   stream: APIs.getMyUsersId(),
                            //
                            //   //get id of only know user
                            //   builder: (context, snapshot) {
                            //     switch (snapshot.connectionState) {
                            //       //if data is loading
                            //       case ConnectionState.waiting:
                            //       case ConnectionState.none:
                            //         return const Center(
                            //           child: CircularProgressIndicator(),
                            //         );
                            //
                            //       //if some or all data is loaded then show it
                            //       case ConnectionState.active:
                            //       case ConnectionState.done:
                            //         return StreamBuilder(
                            //           stream: APIs.getAllUsers(snapshot
                            //                   .data?.docs
                            //                   .map((e) => e.id)
                            //                   .toList() ??
                            //               []),
                            //
                            //           //get only those user, who's ids are provide
                            //           builder: (context, snapshot) {
                            //             switch (snapshot.connectionState) {
                            //               //if data is loading
                            //               case ConnectionState.waiting:
                            //               case ConnectionState.none:
                            //                 return const Center(
                            //                   child:
                            //                       CircularProgressIndicator(),
                            //                 );
                            //
                            //               //if some or all data is loaded then show it
                            //               case ConnectionState.active:
                            //               case ConnectionState.done:
                            //                 final data = snapshot.data?.docs;
                            //                 _list = data
                            //                         ?.map((e) =>
                            //                             ChatUser.fromJson(
                            //                                 e.data()))
                            //                         .toList() ??
                            //                     [];
                            //
                            //                 if (_list.isNotEmpty) {
                            //                   return ListView.builder(
                            //                     itemCount: _list.length,
                            //                     physics:
                            //                         BouncingScrollPhysics(),
                            //                     itemBuilder: (context, index) {
                            //                       return CallUserCard(
                            //                           user: _list[index]);
                            //                     },
                            //                   );
                            //                 } else {
                            //                   return const Center(
                            //                       child: Text(
                            //                           'No Connections Found',
                            //                           style: TextStyle(
                            //                               fontSize: 20)));
                            //                 }
                            //             }
                            //           },
                            //         );
                            //     }
                            //   },
                            // ),
                            
                          ],
                          // controller: _tabController,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

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
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Add User'),
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
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
                //Add button
                MaterialButton(
                  onPressed: () async {
                    //Hide Alert Dialog
                    Navigator.pop(context);
                    if (email.isNotEmpty) {
                      APIs.addChatUser(email).then((value) {
                        if (!value) {
                          Dialogs.showSnackbar(context, 'User does no Exist');
                        }
                      });
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ));
  }

  Widget _searchBtn() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SearchScreen(isHome: true)));
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
