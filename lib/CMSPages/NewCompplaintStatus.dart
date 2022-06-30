// ignore_for_file: prefer_const_literals_to_create_immutables, deprecated_member_use, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:c_m_s/CMSController/CMSProfileController.dart';
import 'package:c_m_s/CMSPages/ParentComplaint.dart';
import 'package:c_m_s/CMSResponse/CMSComplaintStatus.dart';
import 'package:video_player/video_player.dart';
import '../dio_client.dart';
import 'CMSComplaintActiveList.dart';
class NewCMStatus extends StatefulWidget {
  final int ComplaintId;
  final String? ComplaintuserId;
  const NewCMStatus({Key? key, this.ComplaintId=0, this.ComplaintuserId}) : super(key: key);

  @override
  State<NewCMStatus> createState() => _NewCMStatusState();
}

class _NewCMStatusState extends State<NewCMStatus> {
  Future<bool?> showWarning(BuildContext context) async => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context)=>ParentComplaint()), (Route<dynamic>route) => false);
  VideoPlayerController? _controller;
  String? _retrieveDataError;
  bool isVideo = false;
  bool isUserNameValidate = false;
  //List<Asset> images = [];
  final List<XFile> _imageFileList = [];
  Future<void>? _launched;
  Map<String, String>? paths;
  FilePickerResult? fileresult;
  PlatformFile? objFile = null;
  String? _fileName;
   List<PlatformFile>? _paths =[];
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = true;
  String? _saveAsFileName;
  FileType _pickingType = FileType.any;
  File? file;
  List<File> _documnet = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;
  PDFDocument? _pdf;
  bool _showTextField = false;
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addresController = TextEditingController();
  // FormFieldValidator? validate;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _userAborted = false;
  String? _error;
  DateTime selectedDatee = DateTime.now();
  int? key;
  List<String> selectedVaccination = [];
  String? epino, name, contactno, address, cnic, marital, pass,_Pathname;

  String? fileName;
  String? path;
  String? _path = "";
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
    // 'خاندان نمبر سے تلاش کریں۔'
  ];
  String? _dropdown;
  String? _school;
  File? imageFile;
  String selectedChildAddress = 'Resolved';
  var _openResult = 'Unknown';
  final complaintstatuscontroller = Get.put(CMSProfileController());
  startTime() async {
    var _duration = const Duration(seconds: 3);

    return Timer(_duration, navigationPage);

  }
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
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
  Future<void> openFile(String _Pathname) async {
/*    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (_Pathname != null) {
      _Pathname =result!.files.single.path!;
    } else {
      // User canceled the picker
    }*/
    final _result = await OpenFile.open(_Pathname);

    setState(() {
      _openResult = "type=${_result.type}  message=${_result.message}";
    });
  }
  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
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
      //device must move horizontally before an update event is generated;
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

  String? get _PicturErrorText {

    final text = phoneController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths != null;
      _saveAsFileName = null;
      _userAborted = false;
    });
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
                colorFilter: new ColorFilter.mode(Colors.grey.withOpacity(.5),BlendMode.dstATop),
                image: new AssetImage(
                    " "
                ),
              ),
            ),
            height: height,
            width: width,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Form(
                    key: _formkey,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.white,
                            elevation: 30,
                            child: Column(
                              children: [
                                Container(
                                  width: 350,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    border: Border.all(color: Colors.blueAccent, width: 4.0,),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: const Text(
                                    "Select Complaint Status",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  ),
                                SizedBox(height: 10.0,),
                                 DecoratedBox(
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
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                      child:Row(
                                        children: [
                                          Text(
                                            "Choose Image *",
                                            textAlign: TextAlign.left,style: TextStyle(color: Colors.blueAccent,fontSize: 20),
                                          ),
                                          SizedBox(width: 10.0,),
                                          ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => _buildPopupDialog(context),
                                              );
                                            },
                                            child: Text('Select Images'),
                                          ),
                                        ],
                                      ),
                                ),
                                SizedBox(height: 20.0,),
                                Container(
                                  child: getImageGridView()
                            ),
                                Container(
                                  child:Row(
                                    children: [
                                      Text(
                                        "Choose Document*",
                                        textAlign: TextAlign.left,style: TextStyle(color: Colors.blueAccent,fontSize: 20),
                                      ),
                                      SizedBox(width: 10.0,),
                                      ElevatedButton(
                                        onPressed: () {
                                          _pickFiles();
                                          /*showDialog(
                                            context: context,
                                            builder: (BuildContext context) => _buildPopupDialog(context),
                                          );*/
                                        },
                                        child: Text('Select Doc*'),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Container(
                                  child: getDocumentGridView(),
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
                        ],
                      ),
                    )
                )
              ),
            ),
          )

        ),   onWillPop: () async{
      final shouldPop = await showWarning(context);
      return shouldPop ?? false;}
    );
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 100,
    );
/*    FilePickerResult? selectedImages = await FilePicker.platform.M(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],);*/
  if (selectedImages!=null) {
      _imageFileList.addAll(selectedImages);
      //_imageFileList.addAll(selectedImages.paths.map((e) => XFile(e!)).toList());
    }
    setState((){
      Navigator.of(context).pop();
    });
  }
  _getDocument() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],);
    if (result != null) {
          _imageFileList.addAll(result.paths.map((e) => XFile(e!)).toList());

    } else {
      // User canceled the picker
    }
    final _result = await OpenFile.open(_Pathname);
    print(_result.message);

    setState(() {
      _openResult = "type=${_result.type}  message=${_result.message}";
    });
    Navigator.of(context);
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
    if(_imageFileList.isEmpty){
      Fluttertoast.showToast(msg: "Images Must be requierd");
      /*SweetAlertV2.show(context,
          title: "Just show a message",
          subtitle: "Sweet alert is pretty",
          style: SweetAlertV2Style.success);*/
    }else if(_paths==null){
      Fluttertoast.showToast(msg: "Document Must be requierd");
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
              contentType: MediaType("images", "jpeg"),),},}
             else if(_paths!.length>0 && _paths !=null){

            for (int i = 0; i < _paths!.length; i++) {
              await MultipartFile.fromFile(_paths![i].path!,filename:_paths![i].path!.split("/").last,
                contentType: MediaType('application', 'pdf'),),},
          }]
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
    /*   final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }*/
    // String fileName = _imageFileList!.length.pa('/').last;
    //String fileName = _imageFileList!.single.path.split('/').last;
    // var fileName = file!.path.split('/').last;
  }
  showAlertDialog(BuildContext context) {

    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        startTime();
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ParentComplaint()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Action"),
      content: Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
  Widget getDocumentGridView(){
    return (_paths!.length !=0)?
   GridView.builder(
      itemCount: _paths!.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 2,
          mainAxisSpacing: 5),
      itemBuilder: (BuildContext context,
          int index){
        final bool isMultiPath =
            _paths != null &&
                _paths!.isNotEmpty;
        _Pathname =
            'File $index: ' +
                (isMultiPath
                    ? _paths!.map((e) => e.name)
                    .toList()[index]
                    : _fileName ?? '...');
        final path = kIsWeb
            ? null
            : _paths?.map((e) => e.path)
            .toList()[index]
            .toString();
        return InkWell(
            onTap: () {
              /*_launched = _launchInBrowser('/storage/emulated/0/Download/${
                                              _Pathname}');*/
              openFile(_Pathname!);
            },
            child: Stack(
              children: [
                Ink.image(
                  image: AssetImage('assets/images/document.png'),
                  fit: BoxFit.fitWidth,
                  width: 500,
                  height: 500,
                ),
                Positioned(
                  right: 5,
                  top: -2,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        _paths!.removeAt(index);
                      });
                    },
                  ),
                ),
              ],
            )
        );
      },
    ): Text("Document Must be Required");
  }
  Widget getImageGridView(){
    return (_imageFileList.length != 0)?
    GridView.builder(
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
                width: 300,
                height: 300,),
              Positioned(
                right: -1,
                top: -2,
                child: InkWell(
                  child: Icon(
                    Icons.remove_circle,
                    size: 20,
                    color: Colors.red,
                  ),
                  onTap: () {
                    setState(() {
                      _imageFileList.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          );
        }
    ): Text("Picture Must be Required");
  }
  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Catagory'),
      content: Column(
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
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)
                  ),
                  child:InkWell(
                    onTap: (){
                      selectImages();
                      // _getFromGallery();
                      /*   _onImageButtonPressed(
                      );*/
                    },
                    child: Text("Choose From Gallery"),
                  )
              ),
            ],
          )

        ],
      ),
      actions: <Widget>[
        FlatButton(
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


