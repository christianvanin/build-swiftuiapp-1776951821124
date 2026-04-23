import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../models/transaction.dart';

class WalletService {
  static const platform = MethodChannel('com.tuonome.test/backend');
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      
      if (!canAuthenticate) return true;

      return await auth.authenticate(
        localizedReason: 'Accedi al tuo Wallet in sicurezza',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  Future<String> getSystemUserName() async {
    try {
      final String name = await platform.invokeMethod('getSystemUserName');
      return name;
    } on PlatformException catch (_) {
      return "Utente";
    }
  }

  Future<String> getFormattedBalance() async {
    try {
      final String result = await platform.invokeMethod('getFormattedBalance');
      return result;
    } on PlatformException catch (_) {
      return "€ 0,00";
    }
  }

  Future<List<Transaction>> getTransactions() async {
    try {
      final String result = await platform.invokeMethod('getTransactions');
      final List<dynamic> decoded = jsonDecode(result);
      return decoded
          .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}