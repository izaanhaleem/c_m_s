
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CMSController/CMSProfileController.dart';
import '../CMSResponse/CMSProfileResponse.dart';
import 'ParentComplaint.dart';
import 'log_in_screen.dart';
class ComplaintProfilelist extends StatefulWidget {
  const ComplaintProfilelist({Key? key}) : super(key: key);

  @override
  _ComplaintProfilelistState createState() => _ComplaintProfilelistState();
}

class _ComplaintProfilelistState extends State<ComplaintProfilelist> {
  Future<bool?> showWarning(BuildContext context) async => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context)=>const ParentComplaint()), (Route<dynamic>route) => false);
  final cmsprofilecontroller = Get.put(CMSProfileController());
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 250,
                      color: Colors.white,
                    )
                  ],
                ),
                Positioned(
                    top:60,
                    left: 0 ,
                    child: Container(
                      height: 100,
                      width: 320,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    )
                ),
                 Positioned(
                    top: 100,
                    left: 20,
                  child:IntrinsicHeight(
                    child: Row(
                      children: [
                        Image.asset('assets/images/blueprofile.jpg',
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover),
                        VerticalDivider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                        Text("OFFICER PROFILE",style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),                
                Positioned(
                    top: 130,
                    left: 230,
                    child: PopupMenuButton<int>(
                      color: Colors.white,
                      elevation: 180,
                      shape: CircleBorder(),
                      onSelected: (item)=>onSelected(context, item),
                      child: Icon(Icons.menu,color: Colors.black,),
                      itemBuilder: (context)=>[
                        PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Home Page", style: TextStyle(fontWeight: FontWeight.bold),),
                              Icon(Icons.home, color: Colors.black,)
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Log out", style: TextStyle(fontWeight: FontWeight.bold),),
                                Icon(Icons.logout, color: Colors.black,)
                              ],
                            )
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("", style: TextStyle(fontWeight: FontWeight.bold),),
                              Icon(Icons.home, color: Colors.white,)
                            ],),
                        ),
                      ],
                    )
                ),
                Container(
                  child:Positioned(
                    top:200,
                    left: 30,
                    child: Container(
                      alignment: Alignment.center,
                      height: 200,
                      width: 310,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top:170,
                  left: 130,
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/punjab.png"),
                    height: 70,
                    width: 100,
                  ),
                ),
                Positioned(
                  top:220,
                  left: 40,
                  child: SizedBox(
                    height: 200,
                    width: 290,
                    child: Obx(() {
                      if (cmsprofilecontroller.CmsProfileList.isEmpty) {
                        return const Center(child: Text("No Task Assigned ...",
                          style: TextStyle(fontWeight: FontWeight.bold),));
                      } else {
                        return ListView.builder(
                            controller: controller,
                            shrinkWrap: true,
                            itemCount: cmsprofilecontroller.CmsProfileList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ProfileInformation(index, cmsprofilecontroller.CmsProfileList);
                            }
                        );
                      }
                    }),
                  ),
                ),

              ]
          ),
        ),


      ),
        onWillPop: () async{
          final shouldPop = await showWarning(context);
          return shouldPop ?? false;
        }
    );
  }
  onSelected(BuildContext context, int item) {
    switch(item){
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context)=>ParentComplaint()), (route) => false);
        break;
      case 1:
        _logout();
        break;
    }
  }
  _logout() async {
    SharedPreferences sharePrefs = await SharedPreferences.getInstance();
    await sharePrefs.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context)=>MyHomePage()), (Route<dynamic>route) => false);
  }
  Widget ProfileInformation(int index, List<CMSProfile> cmsProfileList) {
    return GestureDetector(
            child:Card(
              color: Colors.white,
              child:Padding(
                padding: const EdgeInsets.all(9.0),
                    child:Column(
                      children: [
                        Row(
                          children: [
                            const Text("Name :", style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(width: 5.0,),
                            Flexible(child: Text(cmsprofilecontroller.CmsProfileList[index].name.toString()))
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Post :", style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(width: 5.0,),
                            Flexible(child: Text(cmsprofilecontroller.CmsProfileList[index].post.toString()))
                          ],
                        ),
                        Row(
                          children: [
                            const Text("CNIC :", style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(width: 5.0,),
                            Flexible(child: Text(cmsprofilecontroller.CmsProfileList[index].cnic.toString()))
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Phone Number:", style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(width: 5.0,),
                            Flexible(child: Text(cmsprofilecontroller.CmsProfileList[index].phoneNumber.toString()))
                          ],
                        ),
                        Row(
                          children: [
                            const Text("District: ", style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(width: 5.0,),
                            Flexible(child: Text(cmsprofilecontroller.CmsProfileList[index].district.toString()))
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Tehsil: ", style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(width: 5.0,),
                            Flexible(child: Text(cmsprofilecontroller.CmsProfileList[index].tehsil.toString()))
                          ],
                        ),
                      ],
                    ),
              ),
            )
    );
  }
}