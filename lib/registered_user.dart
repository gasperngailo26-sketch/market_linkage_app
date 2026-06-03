import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

const String _registeredUsersStorageKey = 'registeredUsers';

String generateStrongPassword() {
  const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const digits = '0123456789';
  const symbols = '!@#\\u003024%^&*()-_=+[]{}<>?';
  const all = letters + digits + symbols;

  final random = Random.secure();
  final buffer = StringBuffer();
  buffer.write(letters[random.nextInt(letters.length)]);
  buffer.write(digits[random.nextInt(digits.length)]);
  buffer.write(symbols[random.nextInt(symbols.length)]);
  for (var i = 3; i < 12; i++) {
    buffer.write(all[random.nextInt(all.length)]);
  }

  final passwordChars = buffer.toString().split('')..shuffle(random);
  return passwordChars.join();
}

class RegisteredUser {
  final String role;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  String password; // Changed from final to allow password updates
  Map<String, String>
  securityAnswers; // New field for security question answers

  RegisteredUser({
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    this.securityAnswers = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'password': password,
      'securityAnswers': securityAnswers,
    };
  }

  factory RegisteredUser.fromJson(Map<String, dynamic> json) {
    return RegisteredUser(
      role: json['role'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      securityAnswers: Map<String, String>.from(
        (json['securityAnswers'] as Map<dynamic, dynamic>?) ?? {},
      ),
    );
  }
}

final List<RegisteredUser> registeredUsers = [];

String normalizeLogin(String value) => value.trim().toLowerCase();

bool looksLikeEmail(String value) {
  final trimmed = value.trim();
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+\.?$').hasMatch(trimmed);
}

RegisteredUser? findRegisteredUser(String login) {
  final normalizedLogin = normalizeLogin(login);
  for (final user in registeredUsers) {
    if (normalizeLogin(user.email) == normalizedLogin ||
        normalizeLogin(user.username) == normalizedLogin) {
      return user;
    }
  }
  return null;
}

Future<void> loadRegisteredUsers() async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString(_registeredUsersStorageKey);
  if (stored == null || stored.isEmpty) return;
  final decoded = jsonDecode(stored) as List<dynamic>;
  registeredUsers.clear();
  registeredUsers.addAll(
    decoded.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return RegisteredUser.fromJson(map);
    }),
  );
}

Future<void> saveRegisteredUsers() async {
  final prefs = await SharedPreferences.getInstance();
  final encoded = jsonEncode(registeredUsers.map((u) => u.toJson()).toList());
  await prefs.setString(_registeredUsersStorageKey, encoded);
}
