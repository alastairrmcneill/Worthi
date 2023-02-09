import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moolah/models/app_user_model.dart';
import 'package:moolah/services/services.dart';

class Account {
  final String? id;
  final String name;
  final String type;
  final bool archived;
  final List<dynamic> history;

  Account({
    this.id,
    required this.name,
    required this.type,
    required this.archived,
    required this.history,
  });

  // To JSON
  Map<String, Object?> toJSON() {
    return {
      AccountFields.id: id,
      AccountFields.name: name,
      AccountFields.type: type,
      AccountFields.archived: archived,
      AccountFields.history: history,
    };
  }

  // From JSON
  static Account fromJSON(json) {
    List<dynamic> history = json[AccountFields.history] as List<dynamic>;
    List<Map<String, Object?>> convertedHistory = [];

    for (var entry in history) {
      Map<dynamic, dynamic> mapEntry = entry as Map<dynamic, dynamic>;
      Map<String, Object?> convertedEntry = {};
      for (var item in mapEntry.keys) {
        convertedEntry[item.toString()] = mapEntry[item];

        if (item.toString() == AccountFields.value || item.toString() == AccountFields.deposited) {
          if (mapEntry[item] is String) {
            // number in string format
            double? number = double.tryParse(mapEntry[item] as String);

            // if decrypting needed
            number ??= EncryptionService.decryptToDouble(mapEntry[item] as String);

            convertedEntry[item.toString()] = number;
          } else if (mapEntry[item] is int) {
            convertedEntry[item.toString()] = (mapEntry[item] as int).toDouble();
          }
        }
      }
      convertedHistory.add(convertedEntry);
    }

    return Account(
      id: json[AccountFields.id] as String?,
      name: json[AppUserFields.name] as String,
      type: json[AccountFields.type] as String,
      archived: json[AccountFields.archived] as bool? ?? false,
      history: convertedHistory,
    );
  }

  // Copy
  Account copy({
    String? id,
    String? name,
    String? type,
    bool? archived,
    List<Map<String, Object?>>? history,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      archived: archived ?? this.archived,
      history: history ?? this.history,
    );
  }

  updateBalance({required Timestamp date, required double? deposited, required double value}) {
    Map<String, Object?> update = {
      AccountFields.date: date,
      AccountFields.deposited: deposited,
      AccountFields.value: value,
    };
    for (var i = 0; i < history.length; i++) {
      if (date.toDate().isAfter((history[i][AccountFields.date] as Timestamp).toDate())) {
        history.insert(i, update);
        break;
      } else {
        if (i == history.length - 1) {
          history.insert(i + 1, update);
          break;
        }
      }
    }
    if (history.isEmpty) {
      history.insert(0, update);
    }
  }

  sortHistory() {
    history.sort((a, b) => (b[AccountFields.date] as Timestamp).toDate().compareTo((a[AccountFields.date] as Timestamp).toDate()));
  }

  Account encryptData() {
    List<Map<String, Object?>> encryptedHistory = [];
    for (var entry in history) {
      Map<String, Object?> newEntry = entry;
      if (entry[AccountFields.value] is! String) {
        newEntry[AccountFields.value] = EncryptionService.encryptDouble(entry[AccountFields.value]);
      }
      if (entry[AccountFields.deposited] is! String) {
        if (entry[AccountFields.deposited] != null) {
          newEntry[AccountFields.deposited] = EncryptionService.encryptDouble(entry[AccountFields.deposited]);
        }
      }

      encryptedHistory.add(entry);
    }
    return copy(history: encryptedHistory);
  }
}

class AccountFields {
  static String id = 'id';
  static String name = 'name';
  static String deposited = 'deposited';
  static String value = 'value';
  static String date = 'date';
  static String history = 'history';
  static String type = 'type';
  static String archived = 'archived';
}

class AccountTypes {
  static String bank = 'Current Account';
  static String investment = 'Investment';
  static String loan = 'Loan';
  static String credit = 'Credit card';
  static String pension = 'Pension';

  static List<String> allTypes() {
    return [
      bank,
      investment,
      loan,
      credit,
      pension,
    ];
  }
}

/// Sample time series data type.
class TimeSeriesTotals {
  final DateTime time;
  final double total;

  TimeSeriesTotals(this.time, this.total);
}
