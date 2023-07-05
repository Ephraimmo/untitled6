import 'package:flutter/material.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/small_text.dart';

class ExpendableTextWidget extends StatefulWidget {
  final String text;
  const ExpendableTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpendableTextWidget> createState() => _ExpendableTextWidgetState();
}

class _ExpendableTextWidgetState extends State<ExpendableTextWidget> {
  late String firstHalf;
  late String secondHalf;
  bool hiddenText = true;
  double textHeight = Dimensions.screenHeight/5.63;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.text.length > textHeight){
      firstHalf = widget.text.substring(0,textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    }else{
      firstHalf = widget.text;
      secondHalf = '';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty ? SmallText(text: firstHalf,size: Dimensions.font20,color: AppColors.paraColor,height: 1.6,)
             : Column(
                  children: [
                    SmallText(text: hiddenText ? (firstHalf + "...") : (firstHalf + secondHalf),size: Dimensions.font15,color: AppColors.paraColor,height: 1.6,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          hiddenText = !hiddenText;
                        });
                      },
                      child: Row(
                        children: [
                          SmallText(text: hiddenText ? 'Show more' : "show less",color: AppColors.mainColor,size: Dimensions.font26/2,),
                          Icon(hiddenText ? Icons.arrow_drop_down : Icons.arrow_drop_up ,color: AppColors.mainColor,size: Dimensions.iconSize24,)
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}

