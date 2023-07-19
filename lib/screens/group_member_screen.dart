import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/widgets/user_select_card.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';

class GroupMemberScreen extends StatefulWidget {
  const GroupMemberScreen({super.key});

  @override
  State<GroupMemberScreen> createState() => _GroupMemberState();
}

class _GroupMemberState extends State<GroupMemberScreen> {
  // for storing all user
  List<ChatUser> _list = [];

  // for storing searched item
  List<ChatUser> _searchList = [];

  List<String> _tmpList = [];

  // for storing search status
  bool _isSearching = false;

  Timer? _debounce;

  final searchController = TextEditingController();
  final groupNameController = TextEditingController();

  _onSearchChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // search logic
      // _searchList.clear();

      // for (var i in _list) {
      //   if (i.name.toLowerCase().contains(val.toLowerCase()) ||
      //       i.email.toLowerCase().contains(val.toLowerCase())) {
      //     _searchList.add(i);
      //   }
      //   setState(() {
      //     _isSearching = true;
      //     _searchList;
      //   });
      // }

      setState(() {
        _searchList = _list
            .where((element) => (element.name.toLowerCase().contains(val.toLowerCase())
            || element.email.toLowerCase().contains(val.toLowerCase())  ))
            .toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              // _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            //app bar
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                  )),
              title: ListTile(
                title: Text("Chọn thành viên",
                    style: TextStyle(
                      fontFamily: 'PoppinsSemiBold',
                      fontSize: 16,
                      color: Colors.black87,
                    )),
                subtitle: Text("Đã chọn: " + "0"),
              ),
            ),
            body: Column(children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: mq.width*.05),
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(8.0),
                  // color: Colors.grey[200],
                  // ),
                  child: Row(children: [
                    IconButton(
                        onPressed: () => {},
                        icon: Icon(
                          CupertinoIcons.camera_fill,
                          size: 24,
                          color: Colors.black54,
                        )),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Group name'),
                        // autofocus: true,
                        style: const TextStyle(
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontFamily: "PoppinsRegular"),
                        controller: groupNameController,
                        // when search text changes then updated search list
                        // onChanged: _onSearchChanged,
                      ),
                    ),
                  ])),

              /////////Search
              Container(
                  margin: EdgeInsets.symmetric(horizontal: mq.width*.05),
                  padding: EdgeInsets.symmetric(horizontal: mq.width*.05),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.grey[200],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Name, Email'),
                        autofocus: true,
                        style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.5,
                            fontFamily: "PoppinsRegular"),
                        controller: searchController,
                        // when search text changes then updated search list
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    if (searchController.text != '')
                      IconButton(
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              _isSearching = false;
                            });
                          },
                          icon: Icon(CupertinoIcons.clear_circled_solid))
                  ])),
              Container(
                margin: EdgeInsets.only(top: mq.height * .01),
                color: Colors.black12,
                child: SizedBox(
                  height: 2,
                  width: mq.width,
                ),
              ),
              Expanded(
                child: StreamBuilder(
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
                          stream: APIs.getAllUsers(
                              snapshot.data?.docs.map((e) => e.id).toList() ??
                                  []),

                          //get only those user, who's ids are provide
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
                                final data = snapshot.data?.docs;
                                _list = data
                                        ?.map(
                                            (e) => ChatUser.fromJson(e.data()))
                                        .toList() ??
                                    [];

                                if (_list.isNotEmpty) {
                                  if (searchController.text == '') {
                                    List<ChatUser> _tmp = _list.where((element) => _tmpList.contains(element.id)).toList();

                                    return ListView.builder(
                                      itemCount: _list.length,
                                      // padding:
                                      //     EdgeInsets.only(top: mq.height * .01),
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        bool _isSelect = false;
                                        if(_tmpList.contains(_list[index].id)){
                                          _isSelect = true;
                                        }
                                        return UserSelectCard(user: _list[index],initialValue: _isSelect, onChanged: (value){
                                          if(value){
                                            setState(() {
                                              _tmpList.add(_list[index].id);
                                            });
                                          }else{
                                            setState(() {
                                              _tmpList.remove(_list[index].id);
                                            });
                                          }
                                        });
                                      },
                                    );
                                  } else {
                                    if (_searchList.isNotEmpty) {
                                      return ListView.builder(
                                        itemCount: _searchList.length,
                                        padding: EdgeInsets.only(
                                            top: mq.height * .01),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          bool _isSelect = false;
                                          if(_tmpList.contains(_list[index].id)){
                                            _isSelect = true;
                                          }
                                          return UserSelectCard(user: _searchList[index],initialValue: _isSelect, onChanged: (value){
                                            if(value){
                                              setState(() {
                                                _tmpList.add(_list[index].id);
                                              });
                                            }else{
                                              setState(() {
                                                _tmpList.remove(_list[index].id);
                                              });
                                            }
                                          });
                                        },
                                      );
                                    } else {
                                      return const Center(
                                          child: Text('No results found',
                                              style: TextStyle(fontSize: 20)));
                                    }
                                  }
                                } else {
                                  return const Center(
                                      child: Text('No Connections Found',
                                          style: TextStyle(fontSize: 20)));
                                }
                            }
                          },
                        );
                    }
                  },
                ),
              ),
            ])),
      ),
    );
  }
}
