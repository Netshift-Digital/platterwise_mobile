import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/views/screens/restaurant/widget/form_widget.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';

class AddGuestForm extends StatefulWidget {
  final int guestNumber;
  final Function(List<Guest> guest) onDone;
  const AddGuestForm(
      {Key? key, required this.guestNumber, required this.onDone})
      : super(key: key);

  @override
  State<AddGuestForm> createState() => _AddGuestFormState();
}

class _AddGuestFormState extends State<AddGuestForm> {
  List<Guest> guest = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.guestNumber,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: FormWidget(
                            onChange: (String name, String email) {
                              if (guest.length >= index + 1) {
                                guest[index] = Guest(
                                  guestName: name,
                                  guestEmail: email,
                                );
                              } else {
                                guest.add(
                                  Guest(
                                    guestName: name,
                                    guestEmail: email,
                                  ),
                                );
                              }
                              setState(() {});
                            },
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                PlatButton(
                  title: 'Done',
                  onTap: guest.length == widget.guestNumber ? () {
                    if(validate()){
                      widget.onDone(guest);
                      Navigator.pop(context);
                    }else{
                      RandomFunction.toast("Invalid Email");
                    }
                  } : null,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    bool valid = true;
    for (var e in guest) {
      if (e.guestEmail.isValidEmail() == false || e.guestName.isEmpty) {
        valid = false;
      }
    }
    return valid;
  }
}
