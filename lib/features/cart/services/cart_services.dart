import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/globalvariable.dart';
import 'package:amazon_clone/model/product.dart';
import 'package:amazon_clone/model/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse(
            '$uri/api/remove-from-cart/${product.id}'), // in case you get path error i.e path is required it meand the name of api is incorrect or not chnaged
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            User user =
                userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      print(e.toString());
    }
  }
}
