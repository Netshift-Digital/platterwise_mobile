import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/request_model/split_bill_model.dart';
import 'package:platterwave/model/restaurant/reservation_bill.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/enum/split_type.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/split_bill/custom_amount.dart';
import 'package:platterwave/views/screens/restaurant/screen/split_bill/percentage_split.dart';
import 'package:platterwave/views/screens/restaurant/screen/split_bill/split_option.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SplitBill extends StatefulWidget {
  UserReservation userReservation;
  List<GuestInfo> guestInfo;
  SplitBill({Key? key, required this.userReservation, required this.guestInfo})
      : super(key: key);

  @override
  State<SplitBill> createState() => _SplitBillState();
}

class _SplitBillState extends State<SplitBill> {
  SplitType splitType = SplitType.equally;
  num amountShared = 0;
  num grandPrice = 0;
  String host = 'Host';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColor.p200,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      'Your Bill',
                      style: AppTextTheme.h3.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      (widget.userReservation.bill!.grandPrice).toCurrency(),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    'Your are splitting: ',
                    style: AppTextTheme.h3.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      RandomFunction.sheet(
                          context,
                          SplitOption(
                            splitType: splitType,
                            onSelect: (e) {
                              setState(() {
                                splitType = e;
                              });
                              Navigator.pop(context);
                              if (e == SplitType.equally) {
                                shareEqually();
                              }
                            },
                          ),
                          height: MediaQuery.of(context).size.height / 1.5);
                    },
                    child: Row(
                      children: [
                        Text(
                          splitType.name.capitalizeFirstChar(),
                          style: AppTextTheme.h3.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.p200),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColor.p200,
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.guestInfo.length,
                itemBuilder: (context, index) {
                  var data = widget.guestInfo[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (splitType == SplitType.custom) {
                          RandomFunction.sheet(
                              context,
                              CustomAmount(
                                guestInfo: data,
                                onDone: (e) {
                                  cal(e, index);
                                  Navigator.pop(context);
                                },
                                balance: grandPrice - amountShared,
                              ),
                              height: size / 1.3);
                        } else if (splitType == SplitType.percentage) {
                          RandomFunction.sheet(
                              context,
                              PercentageSplit(
                                gradPrice: num.parse(
                                    widget.userReservation.bill!.grandPrice),
                                guestInfo: data,
                                onDone: (e) {
                                  cal(e, index);
                                  Navigator.pop(context);
                                },
                                balance: grandPrice - amountShared,
                              ),
                              height: size / 1.3);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.g20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 8, bottom: 8),
                          child: ListTile(
                            trailing: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: (splitType == SplitType.percentage)
                                      ? Text(
                                          "%${RandomFunction.getPercentage(num.parse(data.amount), grandPrice)}")
                                      : Text(data.amount.toCurrency()),
                                )),
                            contentPadding: EdgeInsets.zero,
                            leading:
                                SvgPicture.asset('assets/images/avater.svg'),
                            title: Text(data.guestName.capitalizeFirstChar()),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 32,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColor.g20,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${amountShared.toString().toCurrency()} of ${grandPrice.toString().toCurrency()}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      (splitType == SplitType.percentage)
                          ? Text(
                              "%${RandomFunction.getPercentage((grandPrice - amountShared), grandPrice).toStringAsFixed(2)} left",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColor.g500,
                                  fontWeight: FontWeight.w500))
                          : Text(
                              (grandPrice - amountShared) == 0
                                  ? ""
                                  : "${(grandPrice - amountShared).toString().toCurrency()} left",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColor.g500,
                                  fontWeight: FontWeight.w500),
                            )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 41,
              ),
              PlatButton(
                  appState: context.watch<RestaurantViewModel>().appState,
                  title: "Split",
                  onTap: grandPrice == amountShared
                      ? () {
                          splitBill(context);
                        }
                      : null)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      grandPrice = num.parse(widget.userReservation.bill!.grandPrice);
      shareEqually();
    });
  }

  void cal(num e, int index) {
    num money = 0;
    widget.guestInfo[index].amount = e.toString();
    for (var data in widget.guestInfo) {
      money = money + num.parse(data.amount);
    }
    amountShared = money;
    setState(() {});
    Future.delayed(const Duration(seconds: 5), () {
      overAmount(index);
    });
  }

  overAmount(int index) {
    if (amountShared > grandPrice) {
      var extra = amountShared - grandPrice;
      for (var data in widget.guestInfo) {
        if (widget.guestInfo[index] != data && num.parse(data.amount) > extra) {
          var dataIndex = widget.guestInfo.indexOf(data);
          widget.guestInfo[dataIndex].amount =
              (num.parse(widget.guestInfo[dataIndex].amount) - extra)
                  .toString();
          setState(() {});
          break;
        }
      }
    }
  }

  void shareEqually() {
    num money = 0;
    for (int x = 0; x < widget.guestInfo.length; x++) {
      widget.guestInfo[x].amount =
          (grandPrice / widget.guestInfo.length).toStringAsFixed(2);
      money = money + grandPrice / widget.guestInfo.length;
    }
    amountShared = money;
    setState(() {});
  }

  void splitBill(BuildContext context) {
    List<BillSplit> billSplit = [];
    String ownerBill = "0";
    for (var e in widget.guestInfo) {
      // if(e.guestName.toLowerCase().contains(host.toLowerCase())){
      //   ownerBill = e.amount;
      // }else{
      //   billSplit.add(BillSplit(
      //       guestEmail: e.guestEmail,
      //       insertBill: num.parse(e.amount),
      //   ));
      // }
      billSplit.add(BillSplit(
        guestEmail: e.guestEmail,
        guestName: e.guestName,
        type: e.type,
        insertBill: e.amount,
      ));
    }
    var split = SplitBillModel(
        reservId: widget.userReservation.reservId.toString(),
        totalBill: widget.userReservation.bill!.grandPrice,
        billSplit: billSplit);
    var model = context.read<RestaurantViewModel>();
    model.splitBill(split).then((value) {
      Navigator.pop(context, true);
      //  Navigator.popUntil(context, (route) => route.settings.name=="userReservation")
    });
  }
}
