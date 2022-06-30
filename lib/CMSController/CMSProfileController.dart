// ignore_for_file: file_names
import 'package:get/get.dart';
import 'package:c_m_s/CMSPages/CMSComplaintActiveList.dart';
import 'package:c_m_s/CMSResponse/CMSComplaintResponse.dart';
import 'package:c_m_s/CMSResponse/CMSComplaintStatus.dart';
import 'package:c_m_s/CMSResponse/CMSProfileResponse.dart';
import '../dio_client.dart';
class CMSProfileController extends GetxController{

  var isLoading = true.obs;
  var CmsProfileList = <CMSProfile>[].obs;

  var posts = <CmsStatus>[].obs;

  //All Complaint List;
  var CmsComplaintList = <CMSComplaintList>[].obs;

  //Active Complaint List;
  var CmsComplaintActiveList = <CMSComplaintList>[].obs;
  var CmsComplaintCountActiveList = <CMSComplaintList>[].obs;
 //Resolved Complaint List;
  var CmsComplainResolvetList = <CMSComplaintList>[].obs;
  //Cancel Complaint List;
  var CmsComplaintCancelList = <CMSComplaintList>[].obs;
  //ClosedList Complaint;
  var CmsComplaintClosedList = <CMSComplaintList>[].obs;
  //Reopened Complaint List;
  var CmsComplaintReopenedList = <CMSComplaintList>[].obs;
  //Dropped Complaint List;
  var CmsComplaintDroppedList = <CMSComplaintList>[].obs;

  @override
  void onInit() {
   fetchProfileList();
    fetchComplaintList();
    //userform();
    super.onInit();
  }
  void fetchProfileList() async {
    try {
      isLoading(true);
      var cmsprofile = await DioClient.getProfile();
      CmsProfileList.value = cmsprofile;
    } finally {
      isLoading(false);
    }
  }
  void fetchComplainCounttList( ) async {
    try {
      isLoading(true);
      var cmscomplaintlist = await DioClient.fetchComplaint();
      CmsComplaintList.clear();
      CmsComplaintCountActiveList.clear();

      CmsComplaintList.value = cmscomplaintlist;

      CmsComplaintCountActiveList.length;

      CmsComplaintCountActiveList.assignAll(CmsComplaintList.value.where((active) => active.detailComplaintstatus =="Active").toList());
    } finally {
      isLoading(false);
    }
  }
  void fetchComplaintList( ) async {
    try {
      isLoading(true);
      var cmscomplaintlist = await DioClient.fetchComplaint();
      CmsComplaintList.clear();
      CmsComplaintActiveList.clear();
      CmsComplainResolvetList.clear();
      CmsComplaintCancelList.clear();
      CmsComplaintClosedList.clear();
      CmsComplaintReopenedList.clear();
      CmsComplaintDroppedList.clear();



      CmsComplaintList.value = cmscomplaintlist;

      CmsComplaintActiveList.assignAll(CmsComplaintList.value.where((active) => active.detailComplaintstatus =="Active").toList());

      CmsComplainResolvetList.assignAll(CmsComplaintList.value.where((resolved) => resolved.detailComplaintstatus =="Resolved").toList());

      CmsComplaintDroppedList.assignAll(CmsComplaintList.value.where((dropped) => dropped.detailComplaintstatus=="Dropped").toList());

      CmsComplaintReopenedList.assignAll(CmsComplaintList.where((reopen) => reopen.detailComplaintstatus=="Reopened").toList());

      CmsComplaintClosedList.assignAll(CmsComplaintList.value.where((closed) => closed.detailComplaintstatus=="Closed").toList());
    } finally {
      isLoading(false);
    }
  }
}