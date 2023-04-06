import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/succesful.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/add_guest.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:provider/provider.dart';

class MakeReservationScreen extends StatefulWidget {
  final RestaurantData restaurantData;
  const MakeReservationScreen({Key? key, required this.restaurantData})
      : super(key: key);

  @override
  State<MakeReservationScreen> createState() => _MakeReservationScreenState();
}

class _MakeReservationScreenState extends State<MakeReservationScreen> {
  int guestNumber = 1;
  List<Guest> guest = [];
  DateTime? dateTime;
  String? sitType;
  final TextEditingController _date = TextEditingController();
  final TextEditingController _seat = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 48,
                ),
                GestureDetector(
                  onTap: () async {
                    dateTime = await showOmniDateTimePicker(context: context);
                    if (dateTime != null) {
                      _date.text =
                          RandomFunction.date(dateTime.toString()).MMMEd;
                    }
                  },
                  child: AppTextField(
                    controller: _date,
                    enabled: false,
                    prefixIcon: Container(
                      width: 31,
                      height: 31,
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: AppColor.g20, shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        "assets/icon/calendar.svg",
                        width: 12,
                        height: 12,
                      ),
                    ),
                    hintText: "Date",
                    suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                DropdownButtonFormField<String>(
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "select seat type";
                      }
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(width: 0.6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        )),
                    value: sitType,
                    hint: const Text("Select sit type"),
                    items: ['vip', 'regular'].map((e) {
                      return DropdownMenuItem<String>(
                          value: e,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icon/chair.svg",
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(e),
                            ],
                          ));
                    }).toList(),
                    onChanged: (e) {
                      sitType = e;
                    }),
                SizedBox(
                  height: 24.h,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 0.7, color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/avatar-plus.svg",
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Guests'),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (guestNumber != 1) {
                                  setState(() {
                                    guestNumber = guestNumber - 1;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    shape: BoxShape.circle),
                                child: const Center(
                                    child: Icon(
                                  Icons.remove,
                                  size: 18,
                                )),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(guestNumber.toString()),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  guestNumber = guestNumber + 1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    shape: BoxShape.circle),
                                child: const Center(
                                    child: Icon(
                                  Icons.add,
                                  size: 18,
                                )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                guest.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        width: double.maxFinite,
                        height: 65,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: guest.map((e) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      const SizedBox(
                                        height: 36,
                                        width: 36,
                                      ),
                                      ImageCacheCircle(
                                        e.profilePic,
                                        height: 36,
                                        width: 36,
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            guest.remove(e);
                                            setState(() {});
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[500]),
                                              child: const Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: Icon(
                                                  Icons.clear,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    e.guestName.split(' ').first,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {
                      RandomFunction.sheet(
                          context,
                          AddGuest(
                            guestNumber: guestNumber - 1,
                            onGuestSelected: (e) {
                              guest = e;
                              setState(() {});
                            },
                          ));
                    },
                    child: Text(
                      "Add Guest Details",
                      style: AppTextTheme.h3.copyWith(color: AppColor.p200),
                    ),
                  ),
                ),
                //const Spacer(),
                const SizedBox(
                  height: 20,
                ),
                PlatButton(
                  appState: context.watch<RestaurantViewModel>().appState,
                  title: "Book Now",
                  onTap: validate()
                      ? null
                      : () {
                          book(context);
                        },
                ),
                const SizedBox(
                  height: 24,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (sitType != null &&
        dateTime != null &&
        guestNumber > 1 &&
        guest.length == guestNumber-1) {
      return false;
    } else {
      return true;
    }
  }

  book(BuildContext context) {
    var user = context.read<UserViewModel>().user!.userProfile;
    List<Guest> g = [];
    g.addAll(guest);
    g.add(
      Guest(
        guestName: user.fullName,
        guestEmail: user.email,
      ),
    );
    var bookData = ReservationData(
        firebaseAuthId: FirebaseAuth.instance.currentUser?.uid ?? "",
        reservationDate: dateTime.toString(),
        restId: widget.restaurantData.restId,
        sitType: sitType ?? "",
        guestNo: guestNumber.toString(),
        guest: g);
    var model = context.read<RestaurantViewModel>();
    model.makeReservation(bookData).then((value){
      if(value){
        nav(context, const Successful());
      }
    });
  }
}
