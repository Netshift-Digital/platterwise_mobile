

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack_payment_plus/flutter_paystack_payment_plus.dart';
import 'package:platterwave/utils/random_functions.dart';


class PayStackPayment{
//pk_test_4df123d7c9cbf1c84bf49dfb96c1892e74aa649e
//pk_live_e24730c309b966bf9964887f7d83381ea3d559a0
  static Future<bool?> investmentPlanPayment(int amount ,String txnId,BuildContext context)async{
    try{
      final plugin = PaystackPayment();
      await plugin.initialize(publicKey: 'pk_test_9e168c86fa8b3746028248105ed116fd8b373404');
      Charge charge = Charge()
        ..amount = amount*100
        ..putMetaData('transactionId', txnId)
        ..putMetaData("mode_of_payment", "card")
        ..putCustomField(FirebaseAuth.instance.currentUser!.email??"",(amount*100).toString())
        ..reference = "PF${DateTime.now().microsecondsSinceEpoch.toString()}"
      // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = FirebaseAuth.instance.currentUser!.email;
      CheckoutResponse response = await plugin.checkout(
        context,
        fullscreen: true,
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
      );
      plugin.dispose();
      return response.status;
    }catch(e){
      RandomFunction.toast('something went wrong');
    }
    return null;

  }



}