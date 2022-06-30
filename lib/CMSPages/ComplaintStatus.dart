// ignore_for_file: file_names, prefer_const_constructors, unnecessary_new, non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:c_m_s/CMSController/CMSProfileController.dart';
import 'package:c_m_s/CMSPages/ParentComplaint.dart';
import 'package:c_m_s/CMSResponse/CMSComplaintStatus.dart';
import '../dio_client.dart';
import 'CMSComplaintActiveList.dart';

class ComplaintStatus extends StatefulWidget {
  final int ComplaintId;
  final String? ComplaintuserId;
  const ComplaintStatus({Key? key, this.ComplaintId=0, this.ComplaintuserId}) : super(key: key);
  @override
  _ComplaintStatusState createState() => _ComplaintStatusState();
}

class _ComplaintStatusState extends State<ComplaintStatus> {

  Future<bool?> showWarning(BuildContext context) async => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context)=>ParentComplaint()), (Route<dynamic>route) => false);
  bool isVideo = false;
  bool isUserNameValidate = false;
  final List<XFile> _imageFileList = [];
  Map<String, String>? paths;
  FilePickerResult? fileresult;
  PlatformFile? objFile = null;
  File? file;
  final ImagePicker _picker = ImagePicker();
  final DioClient _dioClient = DioClient();
  bool _showTextField = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController addresController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  DateTime selectedDatee = DateTime.now();
  int? key;
  List<String> selectedVaccination = [];
  String? epino, name, contactno, address, cnic, marital, pass;
  String? fileName;
  String? path;
  String? _path = "";
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  final _extensionController = TextEditingController(
    text: 'mwfbak',
  );

  final _mimeTypeController = TextEditingController(
    text: 'application/pdf image/png',
  );
    double? long;
  double? lat;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String? statusdropdown;
  List<String> dropdown = [
    'Resolved',
    'Dropped',
  ];
  String? _dropdown;
  File? imageFile;
  String selectedChildAddress = 'Resolved';
  final complaintstatuscontroller = Get.put(CMSProfileController());
  startTime() async {
    var _duration = const Duration(seconds: 3);

    return Timer(_duration, navigationPage);

  }
  @override
  void initState() {
    FLutter();
    checkGps();
    Future.delayed(
        const Duration(seconds: 0),
            () =>
            setState((){
              complaintstatuscontroller.fetchComplaintList();
            }));
    super.initState();
    print(widget.ComplaintId);
  }
    checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    long = position.longitude.toDouble();
    lat = position.latitude.toDouble();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a

    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {

      long = position.longitude.toDouble();
      lat = position.latitude.toDouble();

      setState(() {
        //refresh UI on update
      });
    });
  }
  String? get _errorText {

    final text = phoneController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Complaint Status"),
            backgroundColor: Colors.black,
          ),
          body:Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(.5), BlendMode.dstATop),
                  image: new AssetImage("assets/images/health.png"),
                ),
              ),
              width: width,
              height: double.infinity,
              child:Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formkey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          elevation: 20,
                          child: Column(
                            children: [
                              Text("Select Complaint Status"),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: new Border.all(
                                          color: Colors.blueAccent, width: 2.0),
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                  child: Stack(
                                    children: [
                                      const Text(
                                        "",
                                        //textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                      ),
                                      DropdownButtonFormField<String>(
                                        value: _dropdown,
                                        isExpanded: true,
                                        items: dropdown.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (dropdown) {
                                          setState(() {
                                            selectedChildAddress = dropdown!;
                                          });
                                          if (dropdown == 'Resolved') {
                                            _dropdown = 'Resolved';
                                            _showTextField = true;
                                          } else if (dropdown == 'Dropped') {
                                            _dropdown = 'Dropped';
                                            _showTextField = true;
                                          }
                                          else{
                                            _dropdown = 'Resolved';
                                          }
                                        },
                                        validator: (_dropdown) {
                                          if (_dropdown == null || _dropdown.trim().isEmpty) {
                                            return 'Please Select Complaint Status';
                                          }
                                          // Return null if the entered username is valid
                                          return null;
                                        },
                                        hint:Text('Complaint Mark As'),
                                      ),

                                    ],
                                  ),
                                ),

                              ),
                              SizedBox(height: 10,),
                              Visibility(
                                visible: _showTextField,
                                child: SizedBox(
                                  child: AutoSizeTextField(
                                    controller: phoneController,
                                    onChanged: (val) {
                                      if(val!=null){
                                        epino = val;}
                                    },
                                    fullwidth: true,
                                    minFontSize: 0,
                                    maxLines: null,
                                    style: TextStyle(fontSize: 15.0),
                                    decoration: InputDecoration(
                                      labelText: 'Enter Description Here',
                                      errorText: _errorText,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 10.0),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              color: Colors.white,
                              child: Text(
                                "Choose Image *",
                                textAlign: TextAlign.left,style: TextStyle(color: Colors.blueAccent,fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _buildPopupDialog(context),
                          );
                        },
                        child: Text('Select Images'),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: GridView.builder(
                              itemCount: _imageFileList.length,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 2),
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    Image.file(File(_imageFileList[index].path),
                                        fit: BoxFit.cover,
                                        width: 500,
                                        height: 500,),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: InkWell(
                                        child: Icon(
                                          Icons.remove_circle,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        onTap: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ButtonTheme(
                        height: 50,
                        minWidth: width - 200,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text('Save',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            _submitData(_imageFileList);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),

        ),   onWillPop: () async{
      final shouldPop = await showWarning(context);
      return shouldPop ?? false;}
    );
  }

  selectImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      _imageFileList.addAll(selectedImages);
    }
    setState((){
      Navigator.of(context).pop();
    });
  }

  _getDocument() async{
      FilePickerResult? document = await FilePicker.platform.pickFiles(allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'pdf', 'doc'],);
      if (document != null) {
        _imageFileList.addAll(document.paths.map((e) => XFile(e!)).toList());
      }
      setState((){
        Navigator.of(context).pop();
      });

  }

  _getFromCamera() async {
    final XFile? selectedImages = await _picker.pickImage(
        source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,);
    if (selectedImages!=null) {
      _imageFileList.add(selectedImages);
    }
    setState((){
      Navigator.of(context).pop();
    });
/*    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }*/
  }

  Future<void> _submitData(List<XFile?> imageFile) async {
    final bool? isValid = _formkey.currentState?.validate();

    if(widget.ComplaintId==null){
      Fluttertoast.showToast(msg: "Complaint ID Must be required");
    }
    else if(_imageFileList==null){
      Fluttertoast.showToast(msg: "Images Must be requierd");
    }
    else if(epino==null){
      Fluttertoast.showToast(msg: "Description Must be requierd");
    }
    else if(long==null){
      Fluttertoast.showToast(msg: "Location Must be requierd");
    }
    else if(isValid==true){
      var formData = FormData.fromMap({
        'aspuserid':widget.ComplaintuserId.toString(),
        'ComplaintID': widget.ComplaintId.toInt(),
        'status': _dropdown.toString(),
        'remarks': epino.toString(),
        'longitude' : long,
        'latitude' : lat,
        'ComplaintFiles': [if (_imageFileList.length > 0 && _imageFileList != null){
          for (int i = 0; i < _imageFileList.length; i++) {
            await MultipartFile.fromFile(_imageFileList[i].path,filename:_imageFileList[i].path.split("/").last,
              contentType: MediaType("images", "jpeg"),),},}]
      });
      CmsStatus? retrievedUser= (await DioClient.submitform(formData));
      if(retrievedUser?.status==true){
        Fluttertoast.showToast(
            msg: retrievedUser!.message.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        Navigator.of(context).pop();
       Navigator.push(context, MaterialPageRoute(builder: (context) => _buildPopupUpdateDialog(context)));
      }else{
        print(retrievedUser?.message.toString());

        Fluttertoast.showToast(
            msg: retrievedUser.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.yellow
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => CMSComplaintActiveList()));

      }
    }
  }
  Future<void> navigationPage() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ParentComplaint()));

  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDatee,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDatee) {
      setState(() {
        selectedDatee = picked;
      });
    }
  }
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
               Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                child: InkWell(
                  onTap: (){
                    _getFromCamera();
                  },
                  child: Text("Take From Camera"),
                ),
              ),
              SizedBox(height: 5.0,),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                child:InkWell(
                  onTap: (){
                    selectImages();
                  },
                  child: Text("Choose From Gallery"),
    )

              ),
              SizedBox(height: 7.0,),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                child: InkWell(
                  onTap: (){
                    _getDocument();
                  },
                  child: Text("Choose Document"),
                ),
              ),
            ],
          )

        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
void FLutter(){
  Fluttertoast.showToast(
      msg: "Complaint Status Active",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white
  );
}
  _pickDocument() async {
    String? result;
    try {
      setState(() {
        _path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList(),
        allowedMimeTypes: _checkByMimeType
            ? _mimeTypeController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList()
            : null,
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }

    setState(() {
      _path = result;
    });
  }
  Widget _buildPopupUpdateDialog(BuildContext context) {
    return  AlertDialog(
      content: Card(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
                child:Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)
                  ),
                  child: Text("Complaint Successfully Updated",style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold),),
                ),
          ),
      actions: <Widget>[
         FlatButton(
           color: Colors.blue,
           shape: RoundedRectangleBorder(
             side: const BorderSide(color: Colors.white, width: 2),
             borderRadius: BorderRadius.circular(10),
           ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ParentComplaint()));
          },
          child: const Text('OK',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
  bool validateTextField(String userInput) {
  if (userInput.isEmpty) {
    setState(() {
      isUserNameValidate = true;
    });
    return false;
  }
  setState(() {
    isUserNameValidate = false;
  });
  return true;
}
}

