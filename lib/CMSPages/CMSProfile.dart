// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CMSController/CMSProfileController.dart';
import '../CMSResponse/CMSProfileResponse.dart';
class CMSProfileDsgn extends StatefulWidget {
  const CMSProfileDsgn({Key? key}) : super(key: key);

  @override
  _CMSProfileDsgnState createState() => _CMSProfileDsgnState();
}

class _CMSProfileDsgnState extends State<CMSProfileDsgn> {
  final cmsprofilecontroller = Get.put(CMSProfileController());
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: Stack(
    children: [
      Column(
        children: [
          Container(
            height: 250,
            color: Colors.red,
          ),
        ],
      ),
      Container(
        child:Positioned(
          top:200,
          left: 30,
          child: Container(
            alignment: Alignment.center,
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top:80,
        left: 100,
        child: Container(
          alignment: Alignment.center,
          child: Image.asset("assets/health.png"),
          height: 50,
          width: 100,
        ),
      ),
      Positioned(
        top:200,
        left: 100,
        child: Container(
          child: Obx(() {
                  if (cmsprofilecontroller.CmsProfileList.isEmpty) {
                    return const Center(child: Text("No Task Assigned ...",
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),));
                  } else {
                    return ListView.builder(
                        controller: controller,
                        shrinkWrap: true,
                        itemCount: cmsprofilecontroller.CmsProfileList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  const Text("Doctor Name:", style: TextStyle(fontWeight: FontWeight.bold),),
                                  const SizedBox(width: 5.0,),
                                  Flexible(child: Text(cmsprofilecontroller.CmsProfileList.toString(),))
                                ],
                              ),
                            ],
                          );
                        }
                    );
                  }
                }),
        ),
      ),
      ]
    )
    );
  }
  Widget ProfileInformation(int index, List<CMSProfile> cmsProfileList) {
    return GestureDetector(
        child: Container(
            child:Card(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
        )
    );
  }
}
