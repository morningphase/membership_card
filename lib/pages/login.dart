import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:membership_card/model/user_model.dart';
import 'package:membership_card/network/client.dart';
import 'package:provider/provider.dart';
import 'package:membership_card/model/card_model.dart';
import 'package:membership_card/model/card_count.dart';
import 'package:membership_card/model/user_count.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  var _passwordController = TextEditingController();
  var _userIdController = TextEditingController();

  bool isSent = false;
  bool _userIdCorrect = false;
  bool _passwordCorrect = false;
  String _loginMsg;
  String _userIdErrMsg;
  String _passwordErrMsg;
  bool remember = false;
  bool _checkboxSelected=true; //维护复选框状态

  var dio = initDio();
  Response res1;
  Response res2;

  @override
  void dispose() {
    _passwordController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      if (_passwordController.text.contains(RegExp(r"\W"))) {
        setState(() {
          _passwordCorrect = false;
          _passwordErrMsg = "Can only input 0-9, a-z and A-Z";
        });
      } else if (_passwordController.text.isEmpty) {
        setState(() {
          _passwordCorrect = false;
          _passwordErrMsg = "Password can not be empty";
        });
      } else if (_passwordController.text.length <= 6) {
        setState(() {
          _passwordCorrect = false;
          _passwordErrMsg = "Password is too short";
        });
      } else {
        setState(() {
          _passwordCorrect = true;
          _passwordErrMsg = null;
        });
      }
    });
    _userIdController.addListener(() {
      if (_userIdController.text.isEmpty) {
        setState(() {
          _userIdCorrect = false;
          _userIdErrMsg = "Can not be empty";
        });
      } else if (_userIdController.text.contains(RegExp(r"\W"))) {
        setState(() {
          _userIdCorrect = false;
          _userIdErrMsg = "Can only input 0-9, a-z and A-Z";
        });
      } else {
        setState(() {
          _userIdCorrect = true;
          _userIdErrMsg = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _IdTextField = TextField(
      decoration: InputDecoration(
        labelText: "userId",
        errorText: _userIdErrMsg,
      ),
      controller: _userIdController,
      maxLength: 24,
    );

    var _passwordTextField = TextField(
      obscureText: true,
      decoration: InputDecoration(
        errorText: _passwordErrMsg,
        labelText: "Password",
      ),
      controller: _passwordController,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
          children:<Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: <Widget>[
                  _IdTextField,
                  _passwordTextField,
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _checkboxSelected,
                        activeColor: Colors.red, //选中时的颜色
                        onChanged:(value){
                          setState(() {
                            _checkboxSelected=value;
                            remember=true;
                          });
                        } ,
                      ),
                      Text("Remember Password"),
                    ],
                  ),

                  Consumer<User>(
                    builder: (context, user, child) => Flex(
                      mainAxisAlignment: MainAxisAlignment.center,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: _userIdCorrect && _passwordCorrect
                              ? () async {
                            _loginMsg = "";
                            setState(() {
                              isSent = true;
                            });
                            user.userId = _userIdController.text;
                            user.password = _passwordController.text;
                            List userList = Provider.of<UserCounter>(context).userList;
                            int i=0;
                            for(; i < userList.length; i++){
                              if(user.userId == userList[i].userId){   //之前保存了这个账号的信息了
                                user = userList[i];
                                res1 = await dioLoginRmb(dio,user);
                                break;
                              }
                            }
                            //判断是否使用cookie直接登录
                            if(i == userList.length){          //之前没有保存这个用户的账号
                              if(remember=true){             //当前选中记住密码
                                res1 = await dioLoginRmb(dio, user);
                              }
                              else{                          //当前没有选择记住密码
                                res1 = await dioLoginNRmb(dio, user);
                              }
                              setState(() {
                                isSent = false;
                              });
                            }

                            ///登录成功
                            if (res1.statusCode == 200) {
                              try {
                                user = User.fromJson(json.decode(res1.data));
                                if(remember == true && i == userList.length){    //当前选择记住密码且之前没有保存这个用户的账号
                                  Provider.of<UserCounter>(context).addUser(user);
                                }

                                dioGetAllCards(dio, user.userId).then((res2){

                                  var list = json.decode(res2.data) as List;
                                  List<CardInfo> cards = list.map((i)=> CardInfo.fromJson(i)).toList();
                                  Provider.of<CardCounter>(context,listen:false).cardList = cards;

                                  if(cards.length==0){
                                    Navigator.pushNamed(context, "/allCardsMainPage",arguments: {
                                      "user": user,
                                    });
                                  }
                                  else{
                                    Navigator.pushNamed(context, "/allCardsPage",arguments: {
                                      "user": user,
                                    });
                                  }
                                });
                                _loginMsg = "Login Succeeded";

                              } on FormatException {
                                _loginMsg = "Login Failed";
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text("Alert"),
                                      content: Text(_loginMsg),
                                    ));
                              }
                            }

                            //登录失败
                            else if (res1.statusCode == 400) {
                              _loginMsg =
                              "Network connection failed, "
                                  "check your network";
                              showDialog(context: context, builder: (_) => AlertDialog(
                                title: Text("Alert"),
                                content: Text(_loginMsg),
                              ));
                            }
                            else if (res1.statusCode == 406) {
                              _loginMsg = "Account does not exist Or Password error";
                              showDialog(context: context, builder: (_) => AlertDialog(
                                title: Text("Alert"),
                                content: Text(_loginMsg),
                              ));
                            }
                            else{
                              _loginMsg = "Server error";
                              showDialog(context: context, builder: (_) => AlertDialog(
                                title: Text("Alert"),
                                content: Text(_loginMsg),
                              ));
                            }
                          }
                              : null,
                          color: Colors.amber,
                          child: Container(
                            child: Text(
                              "Sign In",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.of(context).pushNamed("/registerPage");
                          },
                          child: Container(
                            child: Text("Sign Up"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: isSent
                        ? CircularProgressIndicator()
                        : Text(
                      _loginMsg == null ? "" : _loginMsg,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/forgetPage");
                        },
                        child: Text("Forget password?",
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline
                            )
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }
}
