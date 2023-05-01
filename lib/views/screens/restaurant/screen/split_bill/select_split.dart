import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/reservation_bill.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/views/screens/restaurant/screen/split_bill/split_bill.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class SelectSplit extends StatefulWidget {
  final UserReservation userReservation;
  final ReservationBillElement reservationBillElement;
  const SelectSplit(
      {Key? key,
      required this.userReservation,
      required this.reservationBillElement})
      : super(key: key);

  @override
  State<SelectSplit> createState() => _SelectSplitState();
}

class _SelectSplitState extends State<SelectSplit> {
  List<GuestInfo> guest = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 4,
                  width: 69,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Select Guest to split with',
              style: AppTextTheme.h3
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              'Tap to select who to split with',
              style: AppTextTheme.h3.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.g800),
            ),
            const SizedBox(
              height: 45,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.userReservation.guestInfo.length,
                itemBuilder: (context, index) {
                  var data = widget.userReservation.guestInfo[index];
                  var value = guest
                      .any((element) => element.guestName == data.guestName);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        if (value) {
                          guest.remove(data);
                        } else {
                          guest.add(data);
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: value ? AppColor.g20 : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: ListTile(
                            trailing: value
                                ? SvgPicture.asset('assets/images/mark.svg')
                                : const SizedBox(),
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset('assets/images/avater.svg'),
                            title: Text(data.guestName),
                            subtitle: Text(data.guestEmail),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            PlatButton(
              title: 'Next',
              onTap: guest.isEmpty
                  ? null
                  : () {
                      nav(
                          context,
                          SplitBill(
                              userReservation: widget.userReservation,
                              reservationBillElement:
                                  widget.reservationBillElement,
                              guestInfo: guest));
                    },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
