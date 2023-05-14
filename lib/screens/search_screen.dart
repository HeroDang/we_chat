import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // for storing all user
  List<ChatUser> _list = [];
  // for storing searched item
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  Timer? _debounce;

  final searchController = TextEditingController();

  _onSearchChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // search logic
      _searchList.clear();

      for (var i in _list) {
        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
            i.email.toLowerCase().contains(val.toLowerCase())) {
          _searchList.add(i);
        }
        setState(() {
          _isSearching = true;
          _searchList;
        });
      }
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
      onTap:  () => FocusManager.instance.primaryFocus?.unfocus(),
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
              title: TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name, Email, ...'),
                autofocus: true,
                style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                controller: searchController,
                // when search text changes then updated search list
                onChanged: _onSearchChanged,
              ),
              actions: [
                //search user button
                if (searchController.text != '')
                  IconButton(
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                          _isSearching = false;
                        });
                      },
                      icon: Icon(CupertinoIcons.clear_circled_solid))
              ],
            ),
            body: StreamBuilder(
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
                          snapshot.data?.docs.map((e) => e.id).toList() ?? []),
    
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
                                    ?.map((e) => ChatUser.fromJson(e.data()))
                                    .toList() ??
                                [];
    
                            if (_list.isNotEmpty) {
                              if (searchController.text == '') {
                                return ListView.builder(
                                  itemCount: _list.length,
                                  padding:
                                      EdgeInsets.only(top: mq.height * .01),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ChatUserCard(user: _list[index]);
                                  },
                                );
                              } else {
                                if (_searchList.isNotEmpty) {
                                  return ListView.builder(
                                    itemCount: _searchList.length,
                                    padding:
                                        EdgeInsets.only(top: mq.height * .01),
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ChatUserCard(
                                          user: _searchList[index]);
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
            )),
      ),
    );
  }
}
