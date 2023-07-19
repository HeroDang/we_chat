import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/widgets/user_card.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';

class FriendsScreen extends StatefulWidget {
    final List<ChatUser> listUser;
    const FriendsScreen({super.key, required this.listUser});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int countOnl = 9, countBusy = 0, countAway = 0; 

  List<ChatUser> listOnline = [];
  List<ChatUser> listBusy = [];
  List<ChatUser> listAway = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.listUser.forEach((element) {
      if(element.isOnline){
        listOnline.add(element);
      }else{
        listBusy.add(element);
      }
    });
    countOnl = listOnline.length;
    countBusy = listBusy.length;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  // unselectedLabelColor: Colors.black,
                  // labelColor: Color(0xFF5E88DA),
                  unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  labelStyle:
                      TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 14),
                  tabs: [
                    Tab(
                      // text: 'Online (${countOnl})',
                      child: Text('Online (${countOnl})', 
                                  style:TextStyle(color: Color.fromRGBO(0, 255, 0, 1)),
                                  overflow: TextOverflow.ellipsis,
                                  ),
                    ),
                    Tab(
                      // text: 'Busy' + '(${countBusy})',
                      child: Text('Busy (${countBusy})', 
                                  style:TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                                  overflow: TextOverflow.ellipsis,
                                  ),
                    ),
                    // Tab(
                    //   // text: 'Away (${countAway})',
                    //   child: Text('Away (${countAway})',
                    //               style:TextStyle(color: Color.fromRGBO(255, 165, 0, 1)),
                    //               overflow: TextOverflow.ellipsis,
                    //               ),
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
                       ListView.builder(
                        itemCount: listOnline.length,
                        physics:
                            BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return UserCard(
                              user: listOnline[index]);
                        },
                      ),
                      ListView.builder(
                        itemCount: listBusy.length,
                        physics:
                            BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return UserCard(
                              user: listBusy[index]);
                        },
                      ),
                      // Text("123"),
                    ],
                    // controller: _tabController,
                  ),
                ),
              ),
            ],
          )
        )
        )
      );
  }
}
