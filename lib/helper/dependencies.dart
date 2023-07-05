import 'package:untitled6/data/api/api_client.dart';
import 'package:get/get.dart';
import 'package:untitled6/data/repositories/popular_product_repo.dart';

import '../controllers/popular_product_controller.dart';

Future<void> init() async {
   Get.lazyPut(()=> ApiClient(appBaseUrl: 'https://www.dbestech.com'));
   Get.lazyPut(()=> PopularProductRepo(apiClient: Get.find()));
   Get.lazyPut(()=> PupolarProductController(popularProductRepo: Get.find()));

}