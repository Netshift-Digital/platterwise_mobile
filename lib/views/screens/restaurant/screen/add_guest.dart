import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/model/vblog/user_search.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/add_guest_form.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:provider/provider.dart';

class AddGuest extends StatefulWidget {
  final int guestNumber;
  final Function(List<Guest> guest) onGuestSelected;
  const AddGuest({
    Key? key,
    required this.onGuestSelected,
    required this.guestNumber,
  }) : super(key: key);

  @override
  State<AddGuest> createState() => _AddGuestState();
}

class _AddGuestState extends State<AddGuest> {
  List<SearchResultElement> searchUserResult = [];
  List<Guest> guest = [];
  TextEditingController searchController = TextEditingController();
  bool addManuel = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 24),
            child: PlatButton(
              title: 'Done',
              onTap: widget.guestNumber != guest.length
                  ? null
                  : () {
                      widget.onGuestSelected(guest);
                      Navigator.pop(context);
                    },
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Column(
              children: [
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
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                  controller: searchController,
                  fillColor: AppColor.g30,
                  isSearch: true,
                  hasBorder: false,
                  onChanged: (e) {
                    if (searchController.text.length > 1) {
                      context
                          .read<VBlogViewModel>()
                          .searchUser(searchController.text)
                          .then((value) {
                        if (value != null) {
                          if (mounted) {
                            setState(() {
                              searchUserResult = value;
                            });
                          }
                        }
                      });
                    }
                  },
                  hintText: "Search for a post or people",
                  prefixIcon: SvgPicture.asset("assets/icon/search-normal.svg"),
                ),
                const SizedBox(
                  height: 20,
                ),
                (widget.guestNumber == guest.length)
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomLeft,
                        child: InkWell(
                          onTap: () {
                            RandomFunction.sheet(
                              context,
                              AddGuestForm(
                                guestNumber: widget.guestNumber - guest.length,
                                onDone: (List<Guest> g) {
                                  guest.addAll(g);
                                  setState(() {});
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Add Other Guests",
                            style: AppTextTheme.h3.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColor.p200,
                            ),
                          ),
                        ),
                      ),
                guest.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
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
                      ),
                Expanded(
                    child: ListView.builder(
                        //padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: searchUserResult.length,
                        itemBuilder: (context, index) {
                          var data = searchUserResult[index];
                          if (data.email ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            return const SizedBox();
                          }
                          return ListTile(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              if (guest.any((element) =>
                                          element.guestEmail == data.email) ==
                                      false &&
                                  guest.length < widget.guestNumber) {
                                guest.add(Guest(
                                    guestName: data.fullName,
                                    guestEmail: data.email,
                                    profilePic: data.profileUrl));
                                setState(() {});
                              }
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: ImageCacheCircle(
                              data.profileUrl,
                              height: 40,
                              width: 40,
                            ),
                            title: Text(data.fullName),
                            subtitle: Text("@${data.username}"),
                          );
                        })),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
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
      context.read<VBlogViewModel>().searchUser('chi').then((value) {
        if (value != null) {
          if (mounted) {
            setState(() {
              searchUserResult = value;
            });
          }
        }
      });
    });
  }
}
