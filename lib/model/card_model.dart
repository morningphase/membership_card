import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:membership_card/pages/all_cards.dart';


/// This is the class defining all the card info
/// It is generally used in [AllCardsState] and [AllCardsMainPage]
/// [CardInfo] CONSTRUCTOR ORDER is {[_cardId], [_eName], [_remark]}
/// ```dart
/// // This is the basic CardInfo constructing method
/// // ATTENTION for the order of the constructor params!!!
/// CardInfo cardInfo = CardInfo(cardId, cardType, remark);
/// ```
///
/// Moreover, you can create one CardInfo using [Map] created by [JsonDecoder]
/// ```dart
/// var jsonDecoder = JsonDecoder();
/// CardInfo cardInfo = CardInfo.fromJson(jsonDecoder.convert(jsonInput));
/// ```
class CardInfo extends ChangeNotifier{
  static const String CARD_COUPON_JSON = "card_coupon";
  static const String MAX_COUPON_JSON  = "max_coupon";
  static const String COUPON_NUM_JSON = "coupon_num";
  static const String ADDRESS_JSON     = "address";
  static const String BATCH_NUM_JSON   = "batch_num";
  static const String CARD_ID_JSON     = "card_id";
  static const String CARD_TYPE_JSON     = "card_type";
  static const String CITY_JSON        = "city";
  static const String DESCRIPTION_JSON = "description";
  static const String E_NAME_JSON      = "e_name";
  static const String FACTORY_NUM_JSON = "factory_num";
  static const String REMARK_JSON      = "remark";
  static const String STYLE_JSON       = "style";
  static const String TEL_JSON         = "tel";
  static const String TYPE_JSON        = "type";
  static const String USER_ID_JSON     = "user_id";
  static const String WORK_TIME_JSON   = "work_time";
  static const String BACKGROUND_JSON  = "background";
  static const String ICON_JSON        = "icon";
  static const String EXPIRE_TIME_JSON = "expire_time";
  static const String CURRENT_SCORE_JSON = "current_score";
  static const String MAX_SCORE_JSON     = "max_score";

  int    _currentScore = 3;
  int    _maxScore = 5;
  int    _cardCoupon = 3;
  //int    _maxCoupon = _currentScore ~/ _maxCoupon;
  int    _maxCoupon;
  String _address;
  String _batchNum;
  String _cardId;
  String _cardType;
  String _city;
  String _description;
  String _eName;
  String _expireTime;
  String _factoryNum;
  String _remark;
  String _style;
  String _tel;
  String _type;
  String _userId;
  String _workTime;
  Image  _background;
  Image  _icon;

  bool _isChosen = false;
  Key _cardKey = UniqueKey();
  Color _cardColor = Color.fromARGB(255, Random().nextInt(255),
      Random().nextInt(255), Random().nextInt(255));

  void setCardId(String cardId){
    this._cardId=cardId;
  }

  void setCardStore(String cardStore){
    this._eName=cardStore;
  }


  String get cardId      => _cardId;
  String get cardType    => _cardType;
  String get remark      => _remark;
  Key    get cardKey     => _cardKey;
  String get batchNum    => _batchNum;
  String get city        => _city;
  String get factoryNum  => _factoryNum;
  String get style       => _style;
  String get type        => _type;
  String get userId      => _userId;
  String get eName       => _eName;
  bool   get isChosen    => _isChosen;
  Color  get cardColor   => _cardColor;
  int    get cardCoupon  => _cardCoupon;
  int    get maxCoupon   => _maxCoupon;
  String get address     => _address;
  String get description => _description;
  String get tel         => _tel;
  String get workTime    => _workTime;
  String get expireTime  => _expireTime;
  int    get currentScore=>_currentScore;
  int    get maxScore    => _maxScore;


  set isChosen(bool isChosen) => this._isChosen = isChosen;

  void addScore(int score) {
    if (this._currentScore <= 5)
      this._currentScore = score;
    else this._currentScore = 0;
   }

  void redeemCoupon() {
    this._cardCoupon--;
    notifyListeners();
  }

  CardInfo([this._cardId, this._eName, this._remark]);

  CardInfo.fromJson(Map<String, dynamic> json) {
    this._cardId = json[CARD_ID_JSON];
    this._eName = json[E_NAME_JSON];
    this._remark = json[REMARK_JSON];
  }

  factory CardInfo.getJson(Map<String, dynamic> json) {
    return CardInfo(json[CARD_ID_JSON],json[E_NAME_JSON]);
  }

  Map<String, dynamic> toJson() => {
    CARD_ID_JSON   : cardId,
    E_NAME_JSON : cardType,
  };

  Map<String, dynamic> idToJson()=>{
    CARD_ID_JSON : cardId,
  };


  void chooseOrNotChoose() {
    _isChosen = _isChosen? false : true;
  }
}


