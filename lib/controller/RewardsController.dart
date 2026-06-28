import 'package:get/get.dart';
import 'package:supervisors/models/RewardModel.dart';

import 'package:supervisors/services/api_service.dart';


class RewardsController extends GetxController {

  final ApiService api = ApiService();

  RxList<RewardModel> rewards =
      <RewardModel>[].obs;
  RxInt currentStudentId = 0.obs;

  RxBool loading = false.obs;
  Future<void> getStudentRewards(
      int studentId) async {


    currentStudentId.value = studentId;


    loading(true);


    try {


      final response =
      await api.get(
        '/supervisor/rewards',
      );


      final List list =
      response['data']['data'];



      rewards.value = list

          .where(
            (e)=>
        e['target_id']==studentId,
      )


          .map(
            (e)=>
            RewardModel.fromJson(e),
      )


          .toList();



    }catch(e){


      Get.snackbar(
        "خطأ",
        e.toString(),
      );


    }finally{


      loading(false);

    }

  }

  Future<RewardModel> getReward(
      int rewardId) async {

    final response =
    await api.get(
      '/supervisor/rewards/$rewardId',
    );

    return RewardModel.fromJson(
      response['data'],
    );
  }

  Future<bool> updateReward({

    required int rewardId,



    required String title,

    required String description,

    required String rewardDate,




  }) async {


    loading(true);


    try {


      final response = await api.put(

        '/supervisor/rewards/$rewardId',


        {

          "title":title,

          "description":description,

        },

      );



      print(
          "UPDATE REWARD = $response"
      );



      final index =
      rewards.indexWhere(
              (e)=>e.id == rewardId
      );



      if(index!=-1){


        rewards[index] = RewardModel(

          id: rewardId,

          title:title,

          description:description,

          createdAt:
          rewards[index].createdAt,

        );


        rewards.refresh();


      }



      Get.snackbar(

          "نجاح",

          "تم تعديل المكافأة"

      );


      return true;



    }catch(e){


      Get.snackbar(

          "خطأ",

          e.toString()

      );


      return false;



    }finally{


      loading(false);


    }



  }


  Future<void> deleteReward(
      int rewardId) async {

    await api.delete(
      '/supervisor/rewards/$rewardId',
    );

    rewards.removeWhere(
          (e) => e.id == rewardId,
    );

    Get.snackbar(
      "نجاح",
      "تم حذف المكافأة",
    );
  }
}