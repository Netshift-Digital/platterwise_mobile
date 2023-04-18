import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';


class CustomAmount extends StatefulWidget {
  final GuestInfo guestInfo;
  final num balance;
  final Function(num amount) onDone;
   const CustomAmount({Key? key, required this.guestInfo, required this.onDone, required this.balance}) : super(key: key);

  @override
  State<CustomAmount> createState() => _CustomAmountState();
}

class _CustomAmountState extends State<CustomAmount> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 18,right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height:4,
                      width: 69,
                      decoration: BoxDecoration(
                        color:const Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const ImageCacheCircle(
                      'https://static.vecteezy.com/system/resources/previews/009/734/564/original/default-avatar-profile-icon-of-social-media-user-vector.jpg',
                      height: 42,
                      width: 42,
                    ),
                    const SizedBox(width: 12,),
                    Text(widget.guestInfo.guestName),
                  ],
                ),
                const SizedBox(height: 10,),
                const Divider(thickness: 1.5,),
                const SizedBox(height: 32,),
                Text('Input split amount',style: AppTextTheme.h3.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),),
                const SizedBox(height: 24,),
               TextField(
                 controller: textEditingController,
                 onChanged: (e){
                   setState(() {});
                 },
                 keyboardType: TextInputType.number,
                 decoration: const InputDecoration(
                   border: InputBorder.none,
                   filled: true,
                   hintText: 'Enter amount',
                   fillColor: Color(0xffF2F2F2)
                 ),
               ),
                const SizedBox(height: 12,),
                 Text('Balance: ${widget.balance.toString().toCurrency()}'),
                const SizedBox(height: 42,),
                PlatButton(
                    title: 'Done',
                    onTap: textEditingController.text.isEmpty?null:(){
                      var amount = num.parse(textEditingController.text.trim());
                      widget.onDone(amount);
                    },
                )

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
    textEditingController.text = widget.guestInfo.amount;
  }
}
