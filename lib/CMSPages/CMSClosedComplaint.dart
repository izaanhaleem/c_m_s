// ignore_for_file: file_names, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CMSController/CMSProfileController.dart';
import '../CMSResponse/CMSComplaintResponse.dart';
import 'CMSComplaintActiveList.dart';
import 'CMSProfileList.dart';
import 'CMSReOpenedComaplaint.dart';
import 'CMSResolvedComplaint.dart';
import 'DroppedComplaint.dart';
import 'ParentComplaint.dart';
import 'log_in_screen.dart';
class CMSClosedComplaint extends StatefulWidget {
  const CMSClosedComplaint({Key? key}) : super(key: key);

  @override
  _CMSClosedComplaintState createState() => _CMSClosedComplaintState();
}

class _CMSClosedComplaintState extends State<CMSClosedComplaint> {
  Future<bool?> showWarning(BuildContext context) async => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context)=>const ParentComplaint()), (Route<dynamic>route) => false);
  static int? ComplaintId;
  final parentprofilecontroller = Get.put(CMSProfileController());
  final controller = ScrollController();
  @override
  void initState() {
    parentprofilecontroller.CmsComplaintClosedList.length;
    TabControll();
  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('COMPLAINTS'),
              actions: <Widget>[
                PopupMenuButton<int>(
                  color: Colors.white,
                  elevation: 80,
                  shape: const CircleBorder(),
                  onSelected: (item)=>onSelected(context, item),
                  child: const Icon(Icons.menu,color: Colors.white,),
                  itemBuilder: (context)=>[
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold),),
                          const Icon(Icons.dashboard, color: Colors.black,)
                        ],),
                    ),
                    PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold),),
                            const Icon(Icons.logout, color: Colors.black,)
                          ],)
                    ),
                    PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(" ", style: TextStyle(fontWeight: FontWeight.bold),),
                            //Icon(Icons.drafts, color: Colors.black,)
                          ],)
                    )
                  ],
                )
              ],
              centerTitle: true,
            ),
            body: Column(
              // scrollDirection: Axis.vertical,
              children: [
                const SizedBox(height: 10.0,),
                TabControll(),
                const SizedBox(height: 10.0,),
                Container(
                  child: Column(
                    children: [
                      Title()
                    ],
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  child: AllClosedComplaintList(),
                ),
              ],

            )
        ),
        onWillPop: () async{
          final shouldPop = await showWarning(context);
          return shouldPop ?? false;}
    );
  }
  Widget Title(){
    return const Text("Closed Complaints",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
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
                        //  Navigator.push(context, MaterialPageRoute(builder: (context) => CMSClosedComplaint()));
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
  Widget AllClosedComplaintList(){
    return Column(
      children: [
        Obx((){
          if (parentprofilecontroller.CmsComplaintClosedList.isEmpty) {
            return const Center(child: Text("No Assign Close Complaint List"),);
          } else {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                controller: controller,
                shrinkWrap: true,
                itemCount: parentprofilecontroller.CmsComplaintClosedList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ClosedComplaintlist(index, parentprofilecontroller.CmsComplaintClosedList);
                }
            );

          }
        })

      ],

    );
  }
  Widget ClosedComplaintlist(int index, RxList<CMSComplaintList> cmsComplaintList) {
    return GestureDetector(
      child: Card(
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child:Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Complaint Name: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5.0,),
                    Flexible(child: Text(
                        parentprofilecontroller.CmsComplaintClosedList[index].complaintName.toString()
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Complaint Status: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5.0,),
                    Flexible(child: Text(
                      parentprofilecontroller.CmsComplaintClosedList[index].currentstatus.toString(),
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Created Date: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5.0,),
                    Flexible(child: Text(
                      parentprofilecontroller.CmsComplaintClosedList[index]
                          .createddate.toString(),
                    ))
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Discription: ",
                      style: TextStyle(fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5.0,),
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
            const ComplaintProfilelist()), (Route<dynamic> route) => false);
        break;
      case 1:
        _logout();
        break;
    }
  }
}
