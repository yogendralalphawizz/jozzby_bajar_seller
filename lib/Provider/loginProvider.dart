import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Helper/ApiBaseHelper.dart';
import '../Screen/Authentication/Login.dart';
import '../Screen/DeshBord/dashboard.dart';
import '../Widget/api.dart';
import '../Widget/parameterString.dart';
import '../Widget/sharedPreferances.dart';

class LoginProvider extends ChangeNotifier {
  String? mobile, password, username, id, address, pinCode , lat, lng;
  AnimationController? buttonController;

  get getMobilenumber => mobile;
  get getPassword => Password;

  Future<void> getLoginUser(
    BuildContext context,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    Function updateNow,
  ) async {
    var data = {
      'email': mobile,
      Password: password,
    };

    ApiBaseHelper().postAPICall(getUserLoginApi, data).then(
      (getdata) async {
        print(getdata.toString()) ;
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          setSnackbarScafold(scaffoldMessengerKey, context, msg!);
          var data = getdata["data"][0];
          id = data[Id];
          username = data[Username];
          mobile = data[Mobile];
          address = data[Address];
          pinCode = data[Pincode];
          lat = data[Latitude];
          lng = data[Longitude];
          saveUserDetail(
            id!,
            username!,
            mobile!,
            address!,
            pinCode!,
            lat!,
            lng!
          );
          setPrefrenceBool(isLogin, true);
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) =>  const Dashboard(),
            ),
          );
        } else {
          await buttonController!.reverse();
          setSnackbarScafold(scaffoldMessengerKey, context, msg!);
          updateNow();
        }
      },
      onError: (error) {
        setSnackbarScafold(scaffoldMessengerKey, context, error.toString());
      },
    );
  }
}
