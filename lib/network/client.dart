import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:membership_card/model/card_model.dart';
import 'package:membership_card/model/user_model.dart';
import 'package:membership_card/model/card_count.dart';
import 'dart:async';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:membership_card/network/cookie.dart';

const SERVER_URL = "http://106.15.198.136";
const PORT       = "8080";


Dio initDio() {
  Dio dio = Dio(
    // This is the base options for Dio client to connect to server
    BaseOptions(
      baseUrl: "http://106.15.198.136:8080",
      connectTimeout: 3000,
      receiveTimeout: 3000,
      receiveDataWhenStatusError: false,
      sendTimeout: 3000,
    ),
  );

  return dio;
}


Future<Response<T>> dioGetAllCards<T>(Dio dio, String userId) async {
  Response res = Response();
  try {
    String url = "/v1/api/user/" + userId;
    res = await dio.get(url);

    return res;
  } on DioError catch (e) {
    if (e.response == null) {
      res.data = "Error occured before connection";
      res.statusCode = 500;
      print(e);
      return res;
    } else {
      res.statusCode = e.response.statusCode;
      print(e);
      return res;
  }
  }
}

Future<Response<T>> dioLogin<T>(Dio dio, String account, String password, String type, bool remember) async {
  dio.interceptors.add(CookieManager(await Api.cookieJar));

      Response res = Response();
      Map<String, dynamic> toJson() => {
        "account": account,
        "password": password,
        "accounttype": type,
        "remember": remember,
      };
      try {
        res = await dio.put<String>(
          "/v1/api/user/login",
          data: jsonEncode(toJson()),
        );
        print("${res.statusCode}");

      } on DioError catch (e) {
        if (e.response == null) {
          res.statusCode = 500;
          res.data = "Error from the server, meet 500 error";
      return res;
    } else {
      return e.response;
    }
  }
  return res;
}

Future<Response<T>> dioLoginWithCookie<T>(Dio dio) async {
  Response res = Response();
  try {
    res = await dio.get<String>(
      "/v1/api/user/login",
    );
    print("${res.statusCode}");

  } on DioError catch (e) {
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    } else {
      return e.response;
    }
  }
  return res;
}

Future<Response<T>> dioChangePass<T>(Dio dio, String userId, String oldPassword, String newPassword) async{
  Response res = Response();
  Map<String,dynamic> data={
    "UserId": userId,
    "OldPassword":oldPassword,
    "NewPassword":newPassword,
  };

  try {
    res = await dio.put<String>(
      "/v1/api/user/password",
      data: jsonEncode(data),
    );
    print("${res.statusCode}");
    var cj = new CookieJar();
    List<Cookie> cookies = [
      new Cookie("userId", userId),
      new Cookie("password", newPassword),
    ];

  } on DioError catch (e) {
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    } else {
      return e.response;
    }
  }
  return res;
}

Future<Response<T>> dioRegister<T>(Dio dio, User user, String verify) async {
  Response res = Response();
  Map<String, dynamic> data = {
    "Tel" : user.tel,
    "Mail" : user.mail,
    "Password" : user.password,
    "Verify" : verify
  };

  try {
    print(verify);
    res = await dio.post<String>(
      "/v1/api/user/enroll",
      data: jsonEncode(data),
    );
    print(res);

  } on DioError catch (e) {
    print(res);
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    } else {
      return e.response;
    }
  }
  return res;
}

Future<Response<T>> dioRegisterVerify<T>(Dio dio, String mail) async {
  Response res = Response();
  Map<String, String> body = {"Email" : mail};
  try {
    print(mail);
    res = await dio.post<String>(
      "/v1/api/user/verify",
      data: jsonEncode(body),
    );
    print("${res.statusCode}");
    print(res);

  } on DioError catch (e) {
    print(res);
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    } else {
      return e.response;
    }
  }
  return res;
}

Future<Response<T>> dioDelete<T>(CardInfo cardInfo, Dio dio) async {
  var res = Response();
  try {
    res = await dio.post(
      "/v1/api/user/card/${cardInfo.cardId}/delete",
      data: jsonEncode(cardInfo.idToJson()),
      queryParameters: cardInfo.idToJson(),
    );
    print("${res.statusCode}");

    return res;
  }on DioError catch(e) {
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    }else {
      res.statusCode = e.response.statusCode;
      return res;
    }
  }
}

Future<Response<T>> dioAdd<T>(Dio dio,String cardId, String eName)async {
  Response res=Response();
  Map<String,dynamic> data={
    "cardid": cardId,
    "enterprise": eName
  };
  try{
    res=await dio.post(
      "/v1/api/user/card/add",
      data: jsonEncode(data),
      queryParameters: data,
    );
    print("${res.statusCode}");
  } on DioError catch(e) {
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    }else {
      res.statusCode = e.response.statusCode;
      return res;
    }
  }
  return res;
}




Future<Response<T>> dioModify<T>(Dio dio,String cardId,String eName)async{
  Response res=Response();
  Map<String,dynamic> data={
    "CardID":cardId,
    "Enterprise":eName,
  };
  try{
    res=await dio.put(
      "/v1/api/user/card/$cardId/info",
      data: jsonEncode(data),
      queryParameters: data,
    );
    print("${res.statusCode}");
  } on DioError catch(e) {
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    }else {
      res.statusCode = e.response.statusCode;
      return res;
    }
  }
  return res;
}

Future<Response<T>> dioUseCoupon<T>(Dio dio, String cardId, int increment) async{
  var res = Response();
  Map data = {
    "increment": increment
  };

  try {
    res = await dio.post(
        "/v1/api/user/card/:id/coupons",
        queryParameters: {
          "id": cardId,
        },
        data: {
          jsonEncode({"increment": increment}),
        }
    );
    return res;
  } on DioError catch (e) {
    if (e.response == null) {
      res.data = "Error occured before connection";
      res.statusCode = 500;
      return res;
    } else {
      res.statusCode = e.response.statusCode;
      return res;
    }
  }
}

Future<Response<T>>  dioScore<T>(Dio dio, String cardId, int increment)async{
  Response res=Response();

  try{
    res=await dio.put(
        " /v1/api/users/card/:id/score",
        queryParameters: {
          "id": cardId,
        },
        data: {
          "Increment": increment,
        }
    );
    print("${res.statusCode}");


  } on DioError catch(e) {
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    }else {
      res.statusCode = e.response.statusCode;
      return res;
    }
  }
  return  res;
}



Future<Response<T>> diogetenroll<T>(Dio dio,String id)async{
  Response res = Response();
  Map<String, dynamic> data = {
    'Id':id,
  };
  try {
    res = await dio.post("/v1/api/user/forgetPw", data:jsonEncode(data));
    return res;
  } on DioError catch (e) {
    if (e.response == null) {
      res.data = "Error occured before connection";
      res.statusCode = 500;
      return res;
    } else {
      res.statusCode = e.response.statusCode;
      return res;
    }
  }
}

Future<Response<T>> dioforgetpassword<T>(Dio dio,String userid,String password,String code)async{
  Response res=Response();
  Map<String, dynamic> data = {
    'Id':userid,
    "NewPassword":password,
    "Verify":code
  };
  print(data);
  try{
    res=await dio.post(
      " /v1/api/user/forgetPw/New",
      data: jsonEncode(data),
    );
    print("${res.statusCode}");
  } on DioError catch(e) {
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    }else {
      res.statusCode = e.response.statusCode;
      return res;
    }
  }
  return res;
}
Future<Response<T>> dioForgetVerify<T>(Dio dio, String mail) async {
  Response res = Response();
  Map<String, String> body = {"Email" : mail};
  try {
    print(mail);
    res = await dio.post<String>(
      "/v1/api/user/verify",
      data: jsonEncode(body),
    );
    print("${res.statusCode}");
    print(res);

  } on DioError catch (e) {
    print(res);
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    } else {
      return e.response;
    }
  }
  return res;
}

<<<<<<< HEAD
Future<Response<T>> dioGetDiscountCard<T>(Dio dio, int cardId, String eName, String cardtype) async {
  dio.interceptors.add(CookieManager(await Api.cookieJar));

  Response res = Response();
  Map<String, dynamic> toJson() => {
    "CardID": cardId,
    "Enterprise": eName,
    "CardType": cardtype,
  };
  try {
    String url ="/v1/api/user/card/get/" + cardId.toString();
    res = await dio.put<String>(url,
      data: jsonEncode(toJson()),
    );
    print("${res.statusCode}");

  } on DioError catch (e) {
    if (e.response == null) {
      res.statusCode = 500;
      res.data = "Error from the server, meet 500 error";
      return res;
    } else {
      return e.response;
    }
  }
  return res;
=======

Future<Response<T>> dioGetActivities<T>(Dio dio) async {
  Response res = Response();
  try {
    String url = "/v1/api/user/enterprise/activity" ;
    res = await dio.get(url);

    return res;
  } on DioError catch (e) {
    if (e.response == null) {
      res.data = "Error occured before connection";
      res.statusCode = 500;
      print(e);
      return res;
    } else {
      res.statusCode = e.response.statusCode;
      print(e);
      return res;
    }
  }
>>>>>>> dc6fcd758a85e0521ba49b5eed8b64a8aa7e43a2
}
