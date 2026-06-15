import 'package:get/get.dart';
import 'package:supervisors/models/RewardModel.dart';
import 'RewardsController.dart';

class RewardDetailsController
    extends GetxController {

  final RewardsController
  rewardsController =
  Get.find<RewardsController>();

  Rxn<RewardModel> reward =
  Rxn<RewardModel>();

  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();


    final int rewardId =
        Get.arguments ?? 0;


    if(rewardId != 0){

      loadReward(rewardId);

    }

  }

  Future<void> loadReward(
      int rewardId) async {

    loading(true);

    try {

      reward.value =
      await rewardsController
          .getReward(
        rewardId,
      );

    } finally {

      loading(false);
    }
  }
}