import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/paid_guest.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:provider/provider.dart';

class PaidGuestScreen extends StatefulWidget {
  final UserReservation userReservation;
  const PaidGuestScreen({Key? key, required this.userReservation})
      : super(key: key);

  @override
  State<PaidGuestScreen> createState() => _PaidGuestScreenState();
}

class _PaidGuestScreenState extends State<PaidGuestScreen> {
  List<AllPaidList>? paidGuest;
  String amount = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          title: const Text(
            "Paid Guest",
            style: TextStyle(color: AppColor.g900),
          ),
          action: [
            IconButton(
              onPressed: () {
                getPaidGuest(context);
              },
              icon: const Icon(Icons.refresh),
            ),
            const SizedBox(
              width: 10,
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
            Expanded(
              child: paidGuest == null
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColor.p200),
                      ),
                    )
                  : paidGuest!.isEmpty
                      ? const Center(
                          child: EmptyContentContainer(
                            errorText: "No payment has been made yet",
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                           await getPaidGuest(context);
                           return;
                          },
                          child: ListView.builder(
                            itemCount: paidGuest?.length,
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                            itemBuilder: (context, index) {
                              var data = paidGuest![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.g20,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: ListTile(
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            data.totalBill.toCurrency(),
                                          ),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      leading: SvgPicture.asset(
                                        'assets/images/avater.svg',
                                      ),
                                      subtitle: Text(data.guestEmail.capitalizeFirstChar()),
                                      title: Text(
                                        data.guestName.capitalizeFirstChar(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
            const SizedBox(
              height: 10,
            ),
            PlatButton(
              title: "Done",
              onTap: () {
                //Todo
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getPaidGuest(context);
        getMoneyGuest(context);
      },
    );
  }


  Future<void> getPaidGuest(BuildContext context) async {
    var model = context.read<RestaurantViewModel>();
    var value = await model.getPaidGuest(widget.userReservation.reservId);
    if (value != null) {
      if (mounted) {
        setState(() {
          paidGuest = value;
        });
      }
    }
  }

  Future<void> getMoneyGuest(BuildContext context) async {
    var model = context.read<RestaurantViewModel>();
    var value = await model.getReservationBill(widget.userReservation.reservId);
    if (value != null) {
      if (mounted) {
        setState(() {
          amount = (value.grandPrice ?? "0").toCurrency();
        });
      }
    }
  }
}
