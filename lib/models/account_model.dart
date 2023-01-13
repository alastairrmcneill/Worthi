import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moolah/models/app_user_model.dart';

class Account {
  final String? id;
  final String name;
  final String type;
  final int? deposited;
  final int value;
  final DateTime date;
  final List<dynamic> history;

  Account({
    this.id,
    required this.name,
    required this.type,
    required this.deposited,
    required this.value,
    required this.date,
    required this.history,
  });

  // To JSON
  Map<String, Object?> toJSON() {
    return {
      AccountFields.id: id,
      AccountFields.name: name,
      AccountFields.type: type,
      AccountFields.deposited: deposited,
      AccountFields.value: value,
      AccountFields.date: date,
      AccountFields.history: history,
    };
  }

  // From JSON
  static Account fromJSON(json) {
    return Account(
      id: json[AccountFields.id] as String?,
      name: json[AppUserFields.name] as String,
      type: json[AccountFields.type] as String,
      deposited: json[AccountFields.deposited] as int?,
      value: json[AccountFields.value] as int,
      date: (json[AccountFields.date] as Timestamp).toDate(),
      history: json[AccountFields.history] as List<dynamic>,
    );
  }

  // Copy
  Account copy({
    String? id,
    String? name,
    String? type,
    int? deposited,
    int? value,
    DateTime? date,
    List<Map<String, Object>>? history,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      deposited: deposited ?? this.deposited,
      value: value ?? this.value,
      date: date ?? this.date,
      history: history ?? this.history,
    );
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
