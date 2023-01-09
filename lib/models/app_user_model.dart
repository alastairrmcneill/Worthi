class AppUser {
  final String? id;
  final String name;

  AppUser({
    required this.id,
    required this.name,
  });

  // To JSON
  Map<String, Object?> toJSON() {
    return {
      AppUserFields.id: id,
      AppUserFields.name: name,
    };
  }

  // From JSON
  static AppUser fromJSON(json) {
    return AppUser(
      id: json[AppUserFields.id] as String?,
      name: json[AppUserFields.name] as String,
    );
  }
  // Copy

  AppUser copy(
    String? id,
    String? name,
  ) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class AppUserFields {
  static String id = 'id';
  static String name = 'name';
}
