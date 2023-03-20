import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/restaurant/screen/add_guest.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/custom_dropdown_field.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';

class MakeReservationScreen extends StatefulWidget {
  const MakeReservationScreen({Key? key}) : super(key: key);

  @override
  State<MakeReservationScreen> createState() => _MakeReservationScreenState();
}

class _MakeReservationScreenState extends State<MakeReservationScreen> {
  int guestNumber = 1;
  List<Guest> guest = [];
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
                AppTextField(
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
                SizedBox(
                  height: 24.h,
                ),
                AppTextField(
                  prefixIcon: Container(
                    width: 31,
                    height: 31,
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: AppColor.g20, shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      "assets/icon/timer.svg",
                      width: 12,
                      height: 12,
                    ),
                  ),
                  hintText: "Time",
                  suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                ),
                SizedBox(
                  height: 24.h,
                ),
                AppTextField(
                  prefixIcon: Container(
                    width: 31,
                    height: 31,
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: AppColor.g20, shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      "assets/icon/chair.svg",
                      width: 12,
                      height: 12,
                    ),
                  ),
                  hintText: "Seats",
                  suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                ),
                SizedBox(
                  height: 24.h,
                ),
                AppTextField(
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
                  hintText: "Guests",
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
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
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                shape: BoxShape.circle),
                            child: const Center(child: Icon(Icons.remove)),
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
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                shape: BoxShape.circle),
                            child: const Center(child: Icon(Icons.add)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {
                      RandomFunction.sheet(context, AddGuest(
                        guestNumber: guestNumber,
                        onGuestSelected: (e) {
                          guest = e;
                          print(e);
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
                  title: "Book Now",
                  onTap: () {},
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
}
