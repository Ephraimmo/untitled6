import 'package:get/get.dart';

import '../data/repositories/popular_product_repo.dart';

class PupolarProductController extends GetxController{
  final PopularProductRepo popularProductRepo;
  PupolarProductController({required this.popularProductRepo});

  List<dynamic> _popularProductList = [];
  List<dynamic> get popularProductList => _popularProductList;

  Future<void> getPopularProductList() async {
    Response reponse = await popularProductRepo.getPopularProductList();
    if (reponse.statusCode == 200){
      _popularProductList = [];
      //_popularProductList.addAll();
      update();
    }else{

    }
  }

}