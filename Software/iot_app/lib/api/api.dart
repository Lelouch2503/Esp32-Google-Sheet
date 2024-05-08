import 'package:gsheets/gsheets.dart';
import 'package:iot_app/model/user.dart';

class UserSheetApi {
  static const _credentials = r'''
  {
    "type": "service_account",
  "project_id": "smart-farm-iot-2",
  "private_key_id": "df5b05cce4eaea6800dfccf8fd33ca348685ae1a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2WMYDOfVMgKEg\n8j5PwiTkrCNU45YLzZcWZjrZhqTMxtUNh3Fb3Yr3Zm7/Cf1jM8ovkarbHhqTXg9i\nZpFZQKWO8K1nTNofhUSh0qiE9GTix//26tVz7FrBa0G8Ql3iW6FbmbQ74sOCqmgM\nDm999ssaVy2qUtZjvAyy02AB4gr+YyG6nPnSuVop1Q01DbHmu0nriLa4EmL/YpWX\nz1rQWJDTuMetUA2CeUJLc8MydstEdxV74io/trOiU6pZ2bNOo0/jqRyrLDqgsNlA\nbm6CZefAdxv62Y3DALhRq5T8M1kgcPsKUbDUw38fSNZiAAE9HZi+H3Q9rwRd2P7L\nA5md9rtpAgMBAAECggEALYqeac/f4+t8Uq4twd3LORGFAX6Vyvzd70o5CHsITdya\n+XYKadc7De8Xabsk/dHBfX/0HCW4nXWwgfL7+j6bGsghhts63wR5z7C9RfeD+t/Y\nneKozPsK76PKFyq8J/yaoDYTPaG1Er1cnyY70koBD+MWFKP7x4z/3unL4KyD8mSD\n67KW2mVCFKw8oXRzUH+jyD0iTdXFQgLLZ57lyxPna51vZitck+XajUTp3qN5IQGO\n9Z19TvBT7JYfWWRlMLLwCpIwChxR8I6tt/Zt8wbqjkA+aim1JL4ldMBGCBRbJoff\nfIXfWNbDSG2wZaOPuFoZAcwDRqVd8Jq9gx5vqXuCwQKBgQDYFJCAUjTaz2/u0CNs\ngAkZo7Fo8jOIB0rvO7xUOf51VzqqMNlyL8pRPothJBaMYE5UY0XWueLo5IBB+VdT\n52KxDALos/H8e6RlQtcLDX4IIrGQ+quA6N/7Ui9EjjTYb44CCiiqxg8hrvSCZVZH\nJP/6r7HKVBRN05g39rhHH07jdwKBgQDYCMse9fForQCABo5bWGLLTxVzI1XsXVC+\n+JDwaOf09MjEF7JfRqI0ESuWTTqWaB7+y1c2jN8CGAHEOWme4r77eMWRXWJX9/63\nc+RfDfqt/LITeKuvCN9D1Zrs87ZhvZoOtACMdXWdQ4U86ZUfgdDFaLAmPg1A1PC6\nWbzjw0xQHwKBgQDXfKKipdi6Abbh1UYOdR0eKaXKQAft9z/elpb49CD0Sjph8XdY\nrZo5LYN4K7Ik6gITnDDQs+47TW0u3gcd0JoWcCESiimgHnnS1jZ4ekset+KW77VL\nSHHeQ5aJ6rt+wLlBBXqK3BvI/p4uz/qb1qVFDiPi37ij6Ilb/jrGCs30fwKBgHOE\noDi6ApCakb3jw5OMu6dDbpDWwEdXzqmPeNFVB1Ow4PoaQcM4nduBovEH8uAiZRCR\n4tzEjysrcyZeHOBdFwqZFewZJ1EqxwWJ7v/1FaqbiQ1oZUV/VQOM4P77gvbYz9w0\n3GY/GNkzFbfwn1DttZkZ1bddTvDv7Jl5Cswvzkq5AoGBAL5roe3g2Yzd9a2usWBP\nKPD0ZTBnJCnNyUeJgiLn5wxwXgtM2vQicaco+o5OvVblUVMDFaVgNutTMs9qwuJm\nbL0yuhUxYxlz/ub/1KqAOQfQtG5vAjpLhJUilpSyag66W35yP0RJWaYTuH2iXdxK\nzcvuEkjkYs8qyXp9D8pAxZym\n-----END PRIVATE KEY-----\n",
  "client_email": "smart-farm@smart-farm-iot-2.iam.gserviceaccount.com",
  "client_id": "104321056185542448172",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/smart-farm%40smart-farm-iot-2.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  }
  ''';
  static const _spreadsheetID = '1pSCDBGX5VT5HBcty3SGcYMSJH0EK0XFU5km0sJ1wURg';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetID);
      _userSheet = await _getWorkSheet(spreadsheet, title: 'Users');

      final firstRow = UserFields.getFields();
      _userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Init Error: $e');
    }
  }

  static Future<Worksheet?> _getWorkSheet(
      Spreadsheet spreadsheet, {
        required String title,
      }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title);
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return;
    _userSheet!.values.map.appendRows(rowList);
  }


  static Future<List<Map<String, dynamic>>?> retrieveData() async {
    try {
      if (_userSheet == null) return null;
      final values = await _userSheet!.values.map.allRows();
      return values;
    } catch (e) {
      print('Error retrieving data: $e');
      return null;
    }
  }

}