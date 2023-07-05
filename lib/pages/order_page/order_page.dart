import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import 'cart_history/cart_history.dart';
import 'running_orders/running_orders.dart';

class OrderPage extends StatelessWidget {
  OrderPage({Key? key}) : super(key: key);

  final OrderController orderController = Get.put(OrderController());

  final orderPages = [
    RunningOrder(),
    CartHistory(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: BigText(text: 'Orders',color: Colors.white),
            centerTitle: true,
            backgroundColor: AppColors.mainColor,
          ),
          body: Column(
            children: [
              TabBar(
                dividerColor: Colors.red,
                indicatorColor: AppColors.mainColor,
                indicatorWeight: Dimensions.height10/2,
                onTap: (value){
                  orderController.changeTabOrderselector(value);
                },
                tabs: [
                  Tab(child: BigText(text: 'running',color: AppColors.mainColor,)),
                  Tab(child: BigText(text: 'history',color: AppColors.mainColor,)),
                ],
              ),
              Obx(() => orderPages[orderController.tabSelector.value]),
            ],
          )
      ),
    );
  }
}
