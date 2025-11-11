import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// تحاول تحقق بالبصمة/الوجه
  Future<bool> authenticateUser() async {
    try {
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final available = await _auth.getAvailableBiometrics();

      print('--- LocalAuth debug ---');
      print('isDeviceSupported: $isDeviceSupported');
      print('canCheckBiometrics: $canCheckBiometrics');
      print('available biometrics: $available');

      if (!isDeviceSupported || !canCheckBiometrics || available.isEmpty) {
        return false; // الجهاز لا يدعم البصمة
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'قم بالتوثيق للوصول إلى اليوميات',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      print('PlatformException in local_auth: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Unknown error in local_auth: $e');
      return false;
    }
  }
}
