import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moolah/models/app_user_model.dart';

class Account {
  final String? id;
  final String name;
  final String type;
  final List<dynamic> history;

  Account({
    this.id,
    required this.name,
    required this.type,
    required this.history,
  });

  // To JSON
  Map<String, Object?> toJSON() {
    return {
      AccountFields.id: id,
      AccountFields.name: name,
      AccountFields.type: type,
      AccountFields.history: history,
    };
  }

  // From JSON
  static Account fromJSON(json) {
    return Account(
      id: json[AccountFields.id] as String?,
      name: json[AppUserFields.name] as String,
      type: json[AccountFields.type] as String,
      history: json[AccountFields.history] as List<dynamic>,
    );
  }

  // Copy
  Account copy({
    String? id,
    String? name,
    String? type,
    double? deposited,
    double? value,
    DateTime? date,
    List<Map<String, Object>>? history,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      history: history ?? this.history,
    );
  }

  updateBalance({required DateTime date, required double? deposited, required double value}) {
    Map<String, Object?> update = {
      AccountFields.date: date,
      AccountFields.deposited: deposited,
      AccountFields.value: value,
    };
    for (var i = 0; i < history.length; i++) {
      if (date.isAfter((history[i][AccountFields.date] as Timestamp).toDate())) {
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
}

class AccountFields {
  static String id = 'id';
  static String name = 'name';
  static String deposited = 'deposited';
  static String value = 'value';
  static String date = 'date';
  static String history = 'history';
  static String type = 'type';
}

class AccountTypes {
  static String all = 'All';
  static String bank = 'Current Account';
  static String investment = 'Investment';
  static String loan = 'Loan';
  static String credit = 'Credit card';
  static String pension = 'Pension';
}

/// Sample time series data type.
class TimeSeriesTotals {
  final DateTime time;
  final double total;

  TimeSeriesTotals(this.time, this.total);
}
