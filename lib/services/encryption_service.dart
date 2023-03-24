import 'package:encrypt/encrypt.dart';

// Ecryption service to encrypy the account data that gets stored in the database
class EncryptionService {
  static final _key = Key.fromLength(32);
  static final _iv = IV.fromLength(8);
  static final _encrypter = Encrypter(Salsa20(_key));

  static String encryptDouble(double value) {
    return _encrypter.encrypt(value.toString(), iv: _iv).base64;
  }

  static double decryptToDouble(String value) {
    String result = _encrypter.decrypt64(value, iv: _iv);

    return double.parse(result);
  }
}
