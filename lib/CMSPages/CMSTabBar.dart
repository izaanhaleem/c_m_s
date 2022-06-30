// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CMSClosedComplaint.dart';
import 'CMSComplaintActiveList.dart';
import 'CMSProfileList.dart';
import 'CMSReOpenedComaplaint.dart';
import 'CMSResolvedComplaint.dart';
import 'ParentComplaint.dart';
import 'log_in_screen.dart';

class CMSTabBar extends StatefulWidget {
  const CMSTabBar({Key? key}) : super(key: key);

  @override
  _CMSTabBarState createState() => _CMSTabBarState();
}

class _CMSTabBarState extends State<CMSTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('CMS Dashboard'),
          actions: <Widget>[
            PopupMenuButton<int>(
              color: Colors.white,
              elevation: 80,
              shape: CircleBorder(),
              onSelected: (item)=>onSelected(context, item),
              child: Icon(Icons.menu,color: Colors.white,),
              itemBuilder: (context)=>[
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Profile", style: TextStyle(fontWeight: FontWeight.bold),),
                      Icon(Icons.dashboard, color: Colors.black,)
                    ],),
                ),
                PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold),),
                        Icon(Icons.logout, color: Colors.black,)
                      ],)
                ),
                PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Drooped", style: TextStyle(fontWeight: FontWeight.bold),),
                        Icon(Icons.drafts, color: Colors.black,)
                      ],)
                )
              ],
            )
          ],
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: Colors.lightBlueAccent
            ),
            tabs: [
              Tab(text: "Active"),
              Tab(text: "Resolved"),
              Tab(text: "Reopened"),
              Tab(text: "Closed"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CMSComplaintActiveList(),
            CMSResolvedComplaint(),
            CMSReOpenedComaplaint(),
            CMSClosedComplaint(),
          ],
        ),
      ),
    );
  }
  _logout() async {
    SharedPreferences sharePrefs = await SharedPreferences.getInstance();
    await sharePrefs.remove('token');
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        MyHomePage()), (Route<dynamic> route) => false);
  }
  onSelected(BuildContext context, int item) {
    switch(item){
      case 0:
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            ComplaintProfilelist()), (Route<dynamic> route) => false);
        break;
      case 1:
        _logout();
        break;
      case 2:
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            ParentComplaint()), (Route<dynamic> route) => false);
        break;
    }
  }
}
