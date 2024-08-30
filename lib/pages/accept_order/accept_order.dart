import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import 'accected_orders.dart';
import 'incoming_order.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  int selectPageVale = 0;

  final orderPages = [
    IncomingOrders(),
    AcceptedOrders()
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
                  setState(() {
                    selectPageVale = value;
                  });
                },
                tabs: [
                  Tab(child: BigText(text: 'Incoming',color: AppColors.mainColor,)),
                  Tab(child: BigText(text: 'Accepted',color: AppColors.mainColor,)),
                ],
              ),
              orderPages[selectPageVale],
            ],
          )
      ),
    );
  }
}

