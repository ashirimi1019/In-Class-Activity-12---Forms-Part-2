import 'package:flutter/material.dart';

enum PasswordStrength {
  tooWeak,
  weak,
  fair,
  good,
  strong,
}

class PasswordStrengthMeter extends StatelessWidget {
  final String password;
  final double height;

  const PasswordStrengthMeter({
    super.key,
    required this.password,
    this.height = 8.0,
  });

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.tooWeak;
    if (password.length < 6) return PasswordStrength.weak;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int strength = 0;
    if (password.length >= 8) strength++;
    if (hasUppercase) strength++;
    if (hasDigits) strength++;
    if (hasSpecialCharacters) strength++;
    if (password.length >= 12) strength++;

    if (strength <= 1) return PasswordStrength.weak;
    if (strength <= 2) return PasswordStrength.fair;
    if (strength <= 3) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.tooWeak:
        return 'Enter a password';
      case PasswordStrength.weak:
        return 'Too weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong!';
    }
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.tooWeak:
        return Colors.grey[300]!;
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.fair:
        return Colors.orange;
      case PasswordStrength.good:
        return Colors.lightGreen;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  double _getStrengthPercentage(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.tooWeak:
        return 0.0;
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.fair:
        return 0.5;
      case PasswordStrength.good:
        return 0.75;
      case PasswordStrength.strong:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    final percentage = _getStrengthPercentage(strength);
    final color = _getStrengthColor(strength);
    final text = _getStrengthText(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: height,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
