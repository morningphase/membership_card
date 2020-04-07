import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:membership_card/model/card_model.dart';
import 'package:membership_card/model/user_model.dart';
import 'package:membership_card/model/card_count.dart';
import 'dart:async';

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
  // You can add dio interceptors here
  return dio;
}

Future<Response<T>> dioGetAllCards<T>(Dio dio, String userId) async {
  Response res = Response();
  try {
    res = await dio.get("/v1/api/user/"+userId);
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

Future<Response<T>> dioLogin<T>(Dio dio, User user, String type, bool remember) async {
  Response res = Response();
  Map<String, dynamic> toJson() => {
    "account": user.userId,
    "password": user.password,
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
      "/v1/api/user/card/:id/delete",
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

Future<Response<T>> dioAdd<T>(Dio dio,CardInfo cardInfo)async {
  Response res=Response();
 Map<String,dynamic> data={
   "CardID":cardInfo.cardId,
   "Enterprise":cardInfo.eName,
  };
  try{
    res=await dio.post(
   " /v1/api/user/card/add",
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
      "/v1/api/user/card/:id/info",
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



Future<Response<T>> diogetenroll<T>(Dio dio,String email)async{
  Response res = Response();
  try {
    res = await dio.get("/v1/api/user/enroll",
        queryParameters:{'Mail':email}
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

Future<Response<T>> dioforgetpassword<T>(Dio dio,String userid,String password)async{
  Response res=Response();

  try{
    res=await dio.put(
      " /v1/api/user/ForgetPassword/New",
      data: {'Id':userid,"Password":password},
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
