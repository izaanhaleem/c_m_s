import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CMSResponse/user_info.dart';
import '../dio_client.dart';
import 'ParentComplaint.dart';

class MyHomePage extends StatefulWidget {

  @override
  _loginscreen createState() => new _loginscreen();
}
class _loginscreen extends State<MyHomePage> {

  late final TextEditingController _nameController;
  late final TextEditingController _jobController;
  final DioClient _dioClient = DioClient();
  bool isCreating = false;

  @override
  void initState() {
    _nameController = TextEditingController(text: "test@gmail.com");
    _jobController = TextEditingController(text: "Admin.123");
    super.initState();
  }
//shc.as.est@hisdu.com
  //Admin.123
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.65), BlendMode.overlay),
                  image: AssetImage(""),
                  fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Container(
                  //   padding: EdgeInsets.only(left: 20, top: 40),
                  //   alignment: Alignment.topLeft,
                  //   child: Icon(
                  //     Icons.menu,
                  //     size: 35,
                  //     color: Colors.pink[100],
                  //   ),
                  // ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: <Widget>[

                      new Image.asset(
                        'assets/images/punjab.png',
                        width: 150,
                        height: 150,
                      ),

                      Text(
                        "CMS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[400]),

                      ),
                    ],
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  _formField(
                      controller: _nameController,
                      validate: (_nameController){
                        if(_nameController.isEmpty){
                          return 'Enter user Name';
                        }else{
                          return null;
                        }
                      },
                      prefixIcon: Icons.person_outline,
                      hintText: "Enter Name",
                  labelText: "Enter Name"
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  _formField(
                      controller: _jobController,
                      prefixIcon: Icons.lock_outline,
                      hintText: "Enter Password",
                      labelText: "Enter Password",
                      sulfixIcon: Icons.info_outline,
                      obscureText: true),

                  ListTile(
                    contentPadding:
                    EdgeInsets.only(top: 50, left: 70, right: 70),
                    title: RaisedButton(
                      padding: EdgeInsets.all(20),
                      color: Colors.grey[700],
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),

                      onPressed: () async {
                        if (_nameController.text != '' &&
                                 _jobController.text != '') {
                          UserInfo userInfo = UserInfo(
                            userName: _nameController.text,
                            password: _jobController.text,
                          );

                          UserInfo? retrievedUser =
                          await _dioClient.createUser(userInfo: userInfo);

                          if (retrievedUser != null) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('token', retrievedUser.token.toString());
                            prefs.setString('id', retrievedUser.id.toString());
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ParentComplaint()));

                          }else{
                            // showDialog(
                            //   context: context,
                            //   builder: (context) =>
                            //       Dialog(
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //             color: Colors.white,
                            //             borderRadius: BorderRadius.circular(20),
                            //           ),
                            //           child: Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: Column(
                            //               crossAxisAlignment: CrossAxisAlignment
                            //                   .start,
                            //               mainAxisSize: MainAxisSize.min,
                            //               children: [
                            //                 Text('Name: ${retrievedUser
                            //                     .username}'),
                            //                 Text('Job: ${retrievedUser
                            //                     .password}'),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            // );
                            Alert(context: context, title: "oops", desc: "Incorrect credentials.").show();
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     alignment: Alignment.bottomCenter,
          //     padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: <Widget>[
          //         IconButton(
          //           onPressed: () {},
          //           icon: Icon(Icons.remove_red_eye,
          //               size: 35, color: Colors.pink[300]),
          //         ),
          //         IconButton(
          //           onPressed: () {},
          //           icon: Icon(Icons.dashboard,
          //               size: 35, color: Colors.pink[300]),
          //         ),
          //         IconButton(
          //           onPressed: () {},
          //           icon:
          //           Icon(Icons.gradient, size: 35, color: Colors.pink[300]),
          //         ),
          //         IconButton(
          //           onPressed: () {},
          //           icon: Icon(Icons.group, size: 35, color: Colors.pink[300]),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _formField({IconData? prefixIcon,
    String? hintText,
    String? labelText,
    IconData? sulfixIcon,
    bool obscureText = false,
    FormFieldValidator? validate,
    required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        elevation: 7,
        child: TextFormField(
          obscureText: obscureText,
          controller: controller,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.purple,
                width: 2.0,
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 25),
              child: Icon(
                prefixIcon,
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: EdgeInsets.all(15),
            suffixIcon: sulfixIcon != null
                ? Padding(
              padding: const EdgeInsets.only(left: 25, right: 12),
              child: Icon(
                sulfixIcon,
              ),
            )
                : SizedBox(
              width: 1,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

