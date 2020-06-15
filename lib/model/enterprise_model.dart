import 'package:flutter/material.dart';

class EnterpriseInfo extends ChangeNotifier{
  static const String ADDRESS_JSON           = "Addr";
  static const String ENTERPRISE_ID_JSON     = "Id";
  static const String IS_LOCAL_JSON          = "IsLocal";
  static const String TYPE_JSON              = "Type";
  static const String REGISTER_NUM_JSON      = "RegisterNum";
  static const String ENTERPRISE_NAME_JSON   = "Name";
  static const String HELP_MESSAGE_JSON      = "HelpMsg";
  static const String WEBSITE_JSON           = "Website";
  static const String LICENSE_ID_JSON        = "LicenseId";
  static const String CONTACT_NUM_JSON       = "ContactNum";

  String _enterpriseId;
  String _addr;
  String _type;
  String _enterpriseName;
  String _helpMsg;
  String _website;
  String _licenseId;
  String _contactNum;
  int _registerNum;
  bool _isLocal;

  String get enterpriseId => _enterpriseId;
  String get addr => _addr;
  String get type => _type;
  String get enterpriseName => _enterpriseName;
  String get helpMsg => _helpMsg;
  String get website => _website;
  String get licenseId => _licenseId;
  String get contactNum => _contactNum;
  bool get isLocal => _isLocal;

  EnterpriseInfo([this._enterpriseId, this._enterpriseName]);

  set enterpriseId(String value) {
    _enterpriseId = value;
  }
  set enterpriseName(String value) {
    _enterpriseName = value;
  }

  EnterpriseInfo.fromJSON(Map<String, dynamic> json){
    _enterpriseName = json[ENTERPRISE_NAME_JSON];
    _enterpriseId = json[ENTERPRISE_ID_JSON];
    _addr = json[ADDRESS_JSON];
    _isLocal = json[IS_LOCAL_JSON];
    _type = json[TYPE_JSON];
    _registerNum = json[REGISTER_NUM_JSON];
    _helpMsg = json[HELP_MESSAGE_JSON];
    _website = json[WEBSITE_JSON];
    _licenseId = json[LICENSE_ID_JSON];
  }


}