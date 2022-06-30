// ignore_for_file: file_names, unnecessary_new, prefer_const_constructors, deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:c_m_s/CMSController/CMSProfileController.dart';
import 'package:c_m_s/CMSPages/CMSResolvedComplaint.dart';
import 'package:c_m_s/CMSResponse/CMSComplaintResponse.dart';
import 'CMSClosedComplaint.dart';
import 'CMSComplaintActiveList.dart';
import 'CMSProfileList.dart';
import 'CMSReOpenedComaplaint.dart';
import 'DroppedComplaint.dart';
import 'log_in_screen.dart';
class ParentComplaint extends StatefulWidget {
  const ParentComplaint({Key? key, this.tabIndex}) : super(key: key);
  final int? tabIndex;

  @override
  State<ParentComplaint> createState() => _ParentComplaintState();
}

class _ParentComplaintState extends State<ParentComplaint> {
  Future<bool?> showWarning(BuildContext context) async => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context)=>MyHomePage()), (Route<dynamic>route) => false);
  final parentprofilecontroller = Get.put(CMSProfileController());
  final controller = ScrollController();

  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 0),
            () =>
            setState((){
              parentprofilecontroller.CmsComplaintActiveList.length;
              parentprofilecontroller.fetchComplaintList();

            }));
  //  TabControll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('COMPLAINTS'),
            actions: <Widget>[
              PopupMenuButton<int>(
                color: Colors.white,
                elevation: 90,
                //shape: CircleBorder(),
                onSelected: (item)=>onSelected(context, item),
                child: Icon(Icons.menu,color: Colors.white,),
                itemBuilder: (context)=>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text("Profile", style: TextStyle(fontWeight: FontWeight.bold),),
                        Icon(Icons.dashboard, color: Colors.black,)
                      ],),
                  ),
                  PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold),),
                          Icon(Icons.logout, color: Colors.black,)
                        ],)
                  ),
              /*    PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text(" ", style: TextStyle(fontWeight: FontWeight.bold),),
                          //Icon(Icons.drafts, color: Colors.black,)
                        ],)
                  )*/
                ],
              )
            ],
            centerTitle: true,
          ),
          body: Column(
             // scrollDirection: Axis.vertical,
              children: [
                SizedBox(height: 10.0,),
                TabControll(),
               Container(
                 child: Column(
                   children: [
                     Title()
                   ],
                 ),
               ),
               // Text("Complaint", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: SizedBox(
                        height:400,
                          child: AspectRatio(
                            aspectRatio: 85/95,
                              child:Container(
                                  child:SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        AllResolvedComplaintList(),
                                        SizedBox(height: 1.0,),
                                        AllDroppedComplaintList(),
                                        SizedBox(height: 1.0,),
                                        AllActiveComplaintList(),
                                        SizedBox(height: 1.0,),
                                        AllReopenedComplaintList(),
                                        SizedBox(height: 15.0,),
                                        AllClosedComplaintList()
                                      ],
                                    ),
                                  )
                              )
                    ),
                    )
                  ),
              ],

          )
      ),
      onWillPop: () async{
         showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
        return Future.value(true);
      },
        /*onWillPop: () async{
          final shouldPop = await showWarning(context);
          return shouldPop ?? false;}*/
    );
  }
Widget Title(){
    return Text("All Complaints",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
}
  Widget TabControll(){
    return GestureDetector(
          child:SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:Row(
          children: <Widget>[
             ButtonBar(
                  children: <Widget>[
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.red,
                      child:IntrinsicHeight(
                        child: Row(
                          children: [
                            Text('Active'),
                            VerticalDivider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                            Text("${parentprofilecontroller.CmsComplaintActiveList.length}")
                          ],
                        ),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CMSComplaintActiveList()));
                      },
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.green,
                      child:IntrinsicHeight(
                        child: Row(
                          children: [
                            Text('Resolved'),
                            VerticalDivider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                            Text("${parentprofilecontroller.CmsComplainResolvetList.length}")
                          ],
                        ),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CMSResolvedComplaint()));
                      },
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.orange,
                      child:IntrinsicHeight(
                        child: Row(
                          children: [
                            Text('Reopened'),
                            VerticalDivider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                            Text("${parentprofilecontroller.CmsComplaintReopenedList.length}")
                          ],
                        ),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CMSReOpenedComaplaint()));
                      },
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.grey,
                        child:IntrinsicHeight(
                          child: Row(
                            children: [
                              Text('Closed'),
                              VerticalDivider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                              Text("${parentprofilecontroller.CmsComplaintClosedList.length}")
                            ],
                          ),
                        ),
              /*        child: Row(
                        children: [
                          Text('Closed'),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 4,
                          ),
                          Text("${parentprofilecontroller.CmsComplaintClosedList.length}")
                        ],
                      ),*/
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CMSClosedComplaint()));
                      },
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.blue,
                      child:IntrinsicHeight(
                        child: Row(
                          children: [
                            Text('Dropped'),
                            VerticalDivider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                            Text("${parentprofilecontroller.CmsComplaintDroppedList.length}")
                          ],
                        ),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DroppedComplaint()));
                      },
                    ),
    ]
    )
           ]

              ),
    )
    );
  }
  Widget AllActiveComplaintList(){
    return Column(
      children: [
        Obx((){
          if(parentprofilecontroller.isLoading.value) {
            return Center(
                child: CircularProgressIndicator());
          } else {
            return AnimationLimiter(
                child:ListView.builder(
                scrollDirection: Axis.vertical,
                controller: controller,
                shrinkWrap: true,
                itemCount: parentprofilecontroller.CmsComplaintActiveList.length,
                itemBuilder: (BuildContext context, int index){
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child:ActiveComaplitnlist(index,parentprofilecontroller.CmsComplaintActiveList),
                  )
                  )

                  );
                }
            )
            );
          }
        })
      ],
    );
  }
  Widget AllDroppedComplaintList(){
    return Column(
              children: [
                  Obx((){
                      if (parentprofilecontroller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return AnimationLimiter(
                            child:ListView.builder(
                                scrollDirection: Axis.vertical,
                                controller: controller,
                                shrinkWrap: true,
                                itemCount: parentprofilecontroller.CmsComplaintDroppedList.length,
                                itemBuilder: (BuildContext context, int index){
                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(seconds: 2),
                                      child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child:DroppedComplaintlist(index,parentprofilecontroller.CmsComplaintDroppedList),
                                          )
                                      )

                                  );
                                }
                            )
                        );
                      }
                    })

              ],

    );
  }
  Widget AllResolvedComplaintList(){
    return Column(
              children: [
                  Obx((){
                      if (parentprofilecontroller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return AnimationLimiter(
                            child:ListView.builder(
                                scrollDirection: Axis.vertical,
                                controller: controller,
                                shrinkWrap: true,
                                itemCount: parentprofilecontroller.CmsComplainResolvetList.length,
                                itemBuilder: (BuildContext context, int index){
                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(seconds: 2),
                                      child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child:ResolvedComplaintlist(index,parentprofilecontroller.CmsComplainResolvetList),
                                          )
                                      )

                                  );
                                }
                            )
                        );

                      }
                    })

              ],

    );
  }
  Widget AllReopenedComplaintList() {
    return Column(
      children: [
        Obx((){
          if(parentprofilecontroller.isLoading.value) {
            return Center(
                child: CircularProgressIndicator());
          } else {
            return AnimationLimiter(
                child:ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: parentprofilecontroller.CmsComplaintReopenedList.length,
                    itemBuilder: (BuildContext context, int index){
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(seconds: 2),
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child:ReopenComaplitnlist(index,parentprofilecontroller.CmsComplaintReopenedList),
                              )
                          )

                      );
                    }
                )
            );
          }
        })
      ],
    );
  }
  Widget AllClosedComplaintList(){
    return Column(
      children: [
        Obx((){
          if(parentprofilecontroller.isLoading.value) {
            return Center(
                child: CircularProgressIndicator());
          } else {
            return AnimationLimiter(
                child:ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: parentprofilecontroller.CmsComplaintClosedList.length,
                    itemBuilder: (BuildContext context, int index){
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(seconds: 2),
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child:ClosedComaplitnlist(index,parentprofilecontroller.CmsComplaintClosedList),
                              )
                          )

                      );
                    }
                )
            );
          }
        })
      ],
    );
  }

  Widget ActiveComaplitnlist(int index, RxList<CMSComplaintList> cmsComplaintActiveList) {
    return GestureDetector(
      child: Card(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child:Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Complaint ID: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintActiveList[index].complaintId.toString()
                    ))
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Complaint Name: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintActiveList[index].name.toString()
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Complaint Status: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                      parentprofilecontroller.CmsComplaintActiveList[index].detailComplaintstatus.toString(),
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Created Date: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                      parentprofilecontroller.CmsComplaintActiveList[index]
                          .createddate.toString(),
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Discription: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintActiveList[index]
                            .description.toString()
                    ))
                  ],
                ),
              ],
            ),
          )
      ),

    );
  }
  Widget DroppedComplaintlist(int index, RxList<CMSComplaintList> cmsComplaintList) {
    return GestureDetector(
        child: Card(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
                child:Padding(
                padding: const EdgeInsets.all(9.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Complaint ID: ",
                        style: TextStyle(fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0,),
                      Flexible(child: Text(
                          parentprofilecontroller.CmsComplaintDroppedList[index].complaintId.toString()
                      ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Complaint Name: ",
                        style: TextStyle(fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0,),
                      Flexible(child: Text(
                          parentprofilecontroller.CmsComplaintDroppedList[index].name.toString()
                      ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Complaint Status: ",
                        style: TextStyle(fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0,),
                      Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintDroppedList[index].detailComplaintstatus.toString(),
                      ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Created Date: ",
                        style: TextStyle(fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0,),
                      Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintDroppedList[index]
                            .createddate.toString(),
                      ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Discription: ",
                        style: TextStyle(fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0,),
                      Flexible(child: Text(
                          parentprofilecontroller.CmsComplaintDroppedList[index]
                              .description.toString()
                      ))
                    ],
                  ),
                ],
              ),
                )
        ),

    );
  }
  Widget ResolvedComplaintlist(int index, RxList<CMSComplaintList> cmsComplaintList) {
    return GestureDetector(
      child: Card(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
              child:Padding(
              padding: const EdgeInsets.all(9.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Complaint ID: ",
                  style: TextStyle(fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5.0,),
                Flexible(child: Text(
                    parentprofilecontroller.CmsComplainResolvetList[index].complaintId.toString()
                ))
              ],
            ),
            Row(
             // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Complaint Name: ",
                  style: TextStyle(fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5.0,),
                Flexible(child: Text(
                    parentprofilecontroller.CmsComplainResolvetList[index].name.toString()
                ))
              ],
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Complaint Status: ",
                  style: TextStyle(fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5.0,),
                Flexible(child: Text(
                  parentprofilecontroller.CmsComplainResolvetList[index].detailComplaintstatus.toString(),
                ))
              ],
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Created Date: ",
                  style: TextStyle(fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5.0,),
                Flexible(child: Text(
                  parentprofilecontroller.CmsComplainResolvetList[index]
                      .createddate.toString(),
                ))
              ],
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Discription: ",
                  style: TextStyle(fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5.0,),
                Flexible(child: Text(
                    parentprofilecontroller.CmsComplainResolvetList[index]
                        .description.toString()
                ))
              ],
            ),
          ],
        ),
              )
      ),

    );
  }
  Widget ReopenComaplitnlist(int index, RxList<CMSComplaintList> cmsComplaintList) {
    return GestureDetector(
      child: Card(
          color: Colors.orange,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child:Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Complaint Name: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintReopenedList[index].complaintName.toString()
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Complaint Status: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                      parentprofilecontroller.CmsComplaintReopenedList[index].currentstatus.toString(),
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Created Date: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                      parentprofilecontroller.CmsComplaintReopenedList[index]
                          .createddate.toString(),
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Discription: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintReopenedList[index]
                            .description.toString()
                    ))
                  ],
                ),
              ],
            ),
          )
      ),

    );
  }
  Widget ClosedComaplitnlist(int index, RxList<CMSComplaintList> cmsComplaintList) {
    return GestureDetector(
      child: Card(
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child:Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Complaint Name: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintClosedList[index].complaintName.toString()
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Complaint Status: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                      parentprofilecontroller.CmsComplaintClosedList[index].currentstatus.toString(),
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Created Date: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                      parentprofilecontroller.CmsComplaintClosedList[index]
                          .createddate.toString(),
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Discription: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0,),
                    Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintClosedList[index]
                            .description.toString()
                    ))
                  ],
                ),
              ],
            ),
          )
      ),

    );
  }
Widget ComplaintCount(BuildContext context){
    return Text
      ("${parentprofilecontroller.CmsComplaintActiveList.length}");

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
    }
  }

}


