import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_paystack_payment_plus/flutter_paystack_payment_plus.dart';
//import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:platterwave/utils/random_functions.dart';

import '../data/local/local_storage.dart';

/*
class PayStackPayment {
//pk_test_4df123d7c9cbf1c84bf49dfb96c1892e74aa649e
//pk_live_e24730c309b966bf9964887f7d83381ea3d559a0
  static Future<bool?> investmentPlanPayment(
      int amount, String txnId, BuildContext context) async {
    try {
      final plugin = PaystackPayment();
      await plugin.initialize(
          publicKey: 'pk_test_8cdde2c25bcc9cc2287ca0417841bd73fca256c1');
      Charge charge = Charge()
        ..amount = amount * 100
        ..putMetaData('transactionId', txnId)
        ..putMetaData("mode_of_payment", "card")
        ..putCustomField(FirebaseAuth.instance.currentUser!.email ?? "",
            (amount * 100).toString())
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
    } catch (e) {
      RandomFunction.toast('something went wrong');
    }
    return null;
  }

  static Future<bool?> makePayment(
      int amount, String reserveId, BuildContext context,
      {String? txnId}) async {
    try {
      var status = true;
      var data = await PayWithPayStack().now(
          context: context,
          secretKey: "sk_test_eeaf2c0b53be26ccb9371d46c1af742f2376bbb6",
          customerEmail: LocalStorage.getEmail(),
          reference: DateTime.now().microsecondsSinceEpoch.toString(),
          currency: "NGN",
          paymentChannel: ["mobile_money", "card", 'ussd', 'bank_transfer'],
          amount: (amount * 100).toString(),
          transactionCompleted: () {
            status = true;
          },
          metaData: {
            "transactionId":
                txnId ?? DateTime.now().millisecondsSinceEpoch.toString(),
            "mode_of_payment": "single",
            "reserv_id": reserveId
          },
          transactionNotCompleted: () {
            status = false;
          });
      return true;
    } catch (e) {
      RandomFunction.toast('something went wrong');
      print(e.toString());
    }
    return null;
  }
}
*/