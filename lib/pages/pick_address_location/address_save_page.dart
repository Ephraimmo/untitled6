

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../testMap.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';
import 'pick_address_location.dart';

class AdderssView extends StatefulWidget {
  const AdderssView({Key? key}) : super(key: key);

  @override
  State<AdderssView> createState() => _AdderssViewState();
}

class _AdderssViewState extends State<AdderssView> {
  final box = GetStorage();
  final streetName = TextEditingController();
  final CityName = TextEditingController();
  final stateName = TextEditingController();
  final zipCode = TextEditingController();
  var couter = 0;
  final markers = Set<Marker>();
  MarkerId markerId = MarkerId("PickUp");
  MarkerId UserCurrentPostion = MarkerId("User Location");
  LatLng latLng = LatLng(43.2994, 74.2179);
  late LatLng latLngPickUp = LatLng(43.2994, 74.2179);
  late Future<Position> pickupPostion;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickupPostion = _getCurrentLocation();
    Timer.periodic(Duration(seconds: 5), (timer) {setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: Dimensions.bottomHeightBar120 - Dimensions.height20*2,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.height30),
              child: Container(
                child: Center(child: BigText(
                  text: "", size: Dimensions.font26,)),
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radius20),
                      topLeft: Radius.circular(Dimensions.radius20),
                    )
                ),
              ),
            ),
            pinned: true,
            backgroundColor: AppColors.mainColor,
            expandedHeight: Dimensions.height30,
          ),
          SliverToBoxAdapter(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('AppUsers').doc('+27824815280').snapshots(),
                  builder: (context,snapshot) {
                    if (!snapshot.hasData) {
                      return  Center(child: CircularProgressIndicator(),);
                    } else {
                      return box.read("SavedAllAderss") == null ? Container( height: Dimensions.screenHeight - Dimensions.height45, child: Center(child: BigText(text: 'Please Add Delivery Adderss'),)) : Container(
                        padding: EdgeInsets.only(left: Dimensions.width30*2,right: Dimensions.width30*2,bottom: Dimensions.height45),
                        child:  Column(
                          children: [

                            snapshot.data!.get('AdderssUsed') == '' ? BigText(text: 'Select the adderss to use for delivery') : PhysicalModel(
                                color: Colors.white,
                                elevation: 5,
                                shadowColor: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(20),
                                child: Column(
                                  children: [
                                    BigText(text: "Used Delivery Adderss"),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                                      ),
                                      child: Padding(padding: EdgeInsets.all(Dimensions.width20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: List.generate(snapshot.data!.get('AdderssUsed').toString().split(',').length - 2, (index)
                                                  => SmallText(text: '${snapshot.data!.get('AdderssUsed').toString().split(',')[index]},',size: Dimensions.font15,color: AppColors.paraColor),)
                                              ),),
                                              Padding(
                                                padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
                                                child: AppIcon(icon: Icons.location_on_outlined,backgroundColor: AppColors.iconColor1),
                                              ),
                          ],
                                          )),
                                    ),

                                  ],
                                )
                            ),


                            SizedBox(height: Dimensions.height30,),
                            Align(
                              alignment: Alignment.topLeft,
                              child: SmallText(text: 'All Adderss',color: AppColors.titleColor,),
                            ),
                            Divider(height: Dimensions.height30,color: AppColors.mainColor,endIndent: Dimensions.width10),
                            Column(
                              children: List.generate(box.read("SavedAllAderss").toString().split('|').length, (index) {
                                var showAdderss = box.read("SavedAllAderss").toString().split('|')[index].split(',');
                                return Padding(
                                  padding: EdgeInsets.only(top: Dimensions.height10),
                                  child: PhysicalModel(
                                      color: Colors.white,
                                      elevation: 5,
                                      shadowColor: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Column(
                                        children: [
                                          BigText(text: "Used Delivery Adderss"),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                                            ),
                                            child: Padding(padding: EdgeInsets.all(Dimensions.width20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: List.generate(showAdderss.length - 2, (indexAdderss)
                                                        => SmallText(text: '${showAdderss[indexAdderss]},',size: Dimensions.font15,color: AppColors.paraColor),)
                                                    ),),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
                                                        child: Column(
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: (){
                                                                  FirebaseFirestore.instance.collection('AppUsers').doc('${snapshot.data!.get('phone_numbers')}').update(
                                                                      {
                                                                        'AdderssUsed' : showAdderss.toString().replaceFirst('[', '').replaceFirst(']', '',showAdderss.length-1)
                                                                      });
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    primary: Colors.green,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(Dimensions.radius15))),
                                                                child: SmallText(text: 'Select',color: Colors.white),
                                                            ),
                                                            ElevatedButton(
                                                                onPressed: (){
                                                                  var deleteAdderss = showAdderss.toString().replaceFirst('[', '').replaceFirst(']', '',showAdderss.length-1);
                                                                  var boxRemoveAdderss = box.read('SavedAllAderss').toString();

                                                                  print(boxRemoveAdderss.contains(deleteAdderss.replaceAll(', ', ',')));
                                                                  print(deleteAdderss.replaceAll(', ', ','));
                                                                  print(boxRemoveAdderss);

                                                                  if (boxRemoveAdderss.contains(deleteAdderss.replaceAll(', ', ',') + '|'))
                                                                    {
                                                                      deleteAdderss += '|';
                                                                      boxRemoveAdderss = boxRemoveAdderss.replaceAll(deleteAdderss.replaceAll(', ', ','), '');
                                                                    }else if (boxRemoveAdderss.contains('|' + deleteAdderss.replaceAll(', ', ',')))
                                                                      {
                                                                        deleteAdderss = '|' + deleteAdderss;
                                                                        boxRemoveAdderss = boxRemoveAdderss.replaceAll(deleteAdderss.replaceAll(', ', ','), '');
                                                                      }else{
                                                                    Get.snackbar('Adderss Error', 'You need at least one the address, this address can be removed');
                                                                  }

                                                                  setState(() {
                                                                    box.write('SavedAllAderss', boxRemoveAdderss);
                                                                    box.save();
                                                                  });
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    primary: Colors.red,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(Dimensions.radius15))),
                                                                child: SmallText(text: 'Delete',color: Colors.white),
                                                            ),
                                                          ],
                                                        )
                                                    ),
                                                  ],
                                                )),
                                          ),

                                        ],
                                      )
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      );
                    }
                  }

              ),
          )
        ],
      ),
      bottomNavigationBar:
      Padding(padding: EdgeInsets.all(20),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: AppColors.mainColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            key: const Key("Send the code"),
            onPressed: () async {
                 _settingModalBottomSheet(context);
            },
            child: BigText(text: "Add Delivery Adderss",color: Colors.white,)),),
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled){
      return Future.error("Location service are disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        return Future.error("Location permission are denied");
      }
    }

    if (permission == LocationPermission.deniedForever){
      return Future.error("Location permission are denied, we cannot request");
    }

    return await Geolocator.getCurrentPosition();
  }

  void _settingModalBottomSheet(context) {
    markers.clear();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.75,
            child: Container(
              child: FutureBuilder<Position>(
                future: pickupPostion, // function where you call your api
                builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {  // AsyncSnapshot<Your object type>
                  if( snapshot.connectionState == ConnectionState.waiting){
                    return  Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(height: Dimensions.height20,),
                        SmallText(text: 'Please wait its loading...'),
                      ],
                    ));
                  }else{
                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));
                    else
                      return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {

                            setState(() {
                              latLng = LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                              latLngPickUp = LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                              markers.add(
                                Marker(
                                  markerId: markerId,
                                  infoWindow: InfoWindow(title: "Pick Up Point"),
                                  position: latLng,
                                ),
                              );
                            });

                            return Container(
                               height: Dimensions.ListViewImgSize120*4,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      height: Dimensions.ListViewImgSize120*3,
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(target: latLng,zoom: 16),
                                        onMapCreated: (map){
                                          map.showMarkerInfoWindow(MarkerId("PickUp"));

                                        },
                                        markers: markers,
                                        onCameraMove: (position){
                                          setState(() {

                                            markers.add(Marker(markerId: markerId,position: position.target));
                                            latLngPickUp = LatLng(position.target.latitude, position.target.longitude);
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height10,),
                                    Container(
                                      height: 55,
                                      width: Dimensions.screenWidth - Dimensions.width20,
                                      padding: EdgeInsets.only(left: 20,right: 20),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: Colors.grey),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 40,
                                            child: Icon(Icons.phone_android),
                                          ),
                                          const Text(
                                            "|",
                                            style: TextStyle(fontSize: 33, color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: TextField(
                                                onChanged: (value) {
                                                },
                                                controller: streetName,
                                                keyboardType: TextInputType.text,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "street",
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height10,),
                                    Container(
                                      height: 55,
                                      width: Dimensions.screenWidth - Dimensions.width20,
                                      padding: EdgeInsets.only(left: 20,right: 20),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: Colors.grey),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 40,
                                            child: Icon(Icons.phone_android),
                                          ),
                                          const Text(
                                            "|",
                                            style: TextStyle(fontSize: 33, color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: TextField(
                                                onChanged: (value) {
                                                },
                                                controller: CityName,
                                                keyboardType: TextInputType.text,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "city",
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: 55,
                                          width: (Dimensions.screenWidth - Dimensions.width20)/2,
                                          padding: EdgeInsets.only(left: 20,right: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.grey),
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 40,
                                                child: Icon(Icons.phone_android),
                                              ),
                                              const Text(
                                                "|",
                                                style: TextStyle(fontSize: 33, color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: TextField(
                                                    onChanged: (value) {
                                                    },
                                                    controller: stateName,
                                                    keyboardType: TextInputType.text,
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "state",
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 55,
                                          width: (Dimensions.screenWidth - Dimensions.width20*3)/2,
                                          padding: EdgeInsets.only(left: 20,right: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.grey),
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 40,
                                                child: Icon(Icons.phone_android),
                                              ),
                                              const Text(
                                                "|",
                                                style: TextStyle(fontSize: 33, color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: TextField(
                                                    onChanged: (value) {
                                                    },
                                                    controller: zipCode,
                                                    keyboardType: TextInputType.text,
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "ZIP",
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.height10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: AppColors.mainColor,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10))),
                                                onPressed: () async {

                                                  if (   !streetName.text.trim().isNotEmpty
                                                      || !CityName.text.trim().isNotEmpty
                                                      || !stateName.text.trim().isNotEmpty
                                                      || !zipCode.text.trim().isNotEmpty)
                                                    {
                                                      Get.snackbar(
                                                          'title',
                                                          'Fill in all the mandatory Fields - streetn ame, City, state and zip code');
                                                      return;
                                                    }

                                                  var addAdderss = '';
                                                  couter++;
                                                  if (box.read("SavedAllAderss") != null){
                                                    addAdderss = box.read("SavedAllAderss");
                                                  }
                                                  if (addAdderss == ''){
                                                    addAdderss = addAdderss + '${streetName.text.trim()},${stateName.text.trim()},${CityName.text.trim()},${zipCode.text.trim()},${latLngPickUp.longitude},${latLngPickUp.latitude}';
                                                  }else{
                                                    addAdderss = addAdderss + '|${streetName.text.trim()},${stateName.text.trim()},${CityName.text.trim()},${zipCode.text.trim()},${latLngPickUp.longitude},${latLngPickUp.latitude}';
                                                  }
                                                  box.write("SavedAllAderss", addAdderss);
                                                  box.save();
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    streetName.clear();
                                                    stateName.clear();
                                                    CityName.clear();
                                                    zipCode.clear();
                                                  });
                                                },
                                                child: BigText(text: 'Save Adderss',color: Colors.white,)),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.red,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10))),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: BigText(text: 'Cancel',color: Colors.white,)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            );
                          });  // snapshot.data  :- get your object which is pass from your downloadData() function
                  }
                },
              ),
            ),
          );
        });
  }

}

