import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/reservation_param.dart';
import 'package:platterwave/res/color.dart';

class FormWidget extends StatefulWidget {
  final Function(String name, String email) onChange;
  final Guest? guest;
  const FormWidget({Key? key, required this.onChange, required this.guest})
      : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColor.g300, width: 0.5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              onChanged: (e) {
                widget.onChange(
                  _name.text.trim(),
                  _email.text.trim(),
                );
              },
              decoration: const InputDecoration(hintText: 'Full Name'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
             controller: _email,
              onChanged: (e) {
                widget.onChange(
                  _name.text.trim(),
                  _email.text.trim(),
                );
              },
              decoration: const InputDecoration(
                hintText: 'Email Address',
              ),
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
    if(widget.guest!=null){
      _name.text = widget.guest?.guestName ?? "";
      _email.text = widget.guest?.guestEmail ?? "";
    }
  }
}
