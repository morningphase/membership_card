import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:membership_card/model/card_model.dart';
import 'package:membership_card/model/user_model.dart';
import 'package:membership_card/model/card_count.dart';
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

Future<Response<T>> dioGetAllCards<T>(Dio dio) async {
  Response res = Response();
  try {
    res = await dio.get("/v1/api/user/");
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

Future<Response<T>> dioLogin<T>(Dio dio, User user) async {
  Response res = Response();
  try {
    res = await dio.put<String>(
      "/v1/api/user/login",
      data: jsonEncode(user.toJson()),
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

Future<Response<T>> dioChangePass<T>(Dio dio, User user) async{
  Response res = Response();
  try {
    res = await dio.put<String>(
      "/v1/api/user/",
      data: jsonEncode(user.toJson()),
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

Future<Response<T>> dioRegister<T>(Dio dio, User user) async {
  Response res = Response();
  try {
    res = await dio.post<String>(
      "/v1/api/user/register",
      data: jsonEncode(user.toJson()),
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

Future<Response<T>> dioRegisterVerify<T>(Dio dio, User user) async {
  Response res = Response();
  try {
    res = await dio.get<String>(
      "/v1/api/user/enroll",
//      queryParameters: {"email" : user.email},
    );
//    print("${res.statusCode}");

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

Future<Response<T>> dioDelete<T>(CardInfo cardInfo, Dio dio) async {
  var res = Response();
  try {
    res = await dio.post(
      "/v1/api/user/card/{id}/delete",
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

  try{
    res=await dio.post(
   " /v1/api/user/card/add",
       data: jsonEncode(cardInfo.idToJson()),
      queryParameters: cardInfo.idToJson(),
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




Future<Response<T>> dioModify<T>(Dio dio,CardInfo cardInfo)async{
  Response res=Response();

  try{
    res=await dio.put(
      "/v1/api/user/card/{id}/info",
      data: jsonEncode(cardInfo.toJson()),
      queryParameters: cardInfo.toJson(),
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
