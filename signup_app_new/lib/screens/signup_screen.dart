import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

import '../widgets/avatar_selector.dart';
import '../widgets/password_strength_meter.dart';
import '../models/avatar_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  bool _isPasswordVisible = false;

  late AnimationController _shakeController;
  late AnimationController _successController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ConfettiController _confettiController;

  AvatarModel? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _successController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your name';
    if (value.length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must include at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must include at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  void _updateProgress() {
    setState(() {});
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
      _updateProgress();
    }
  }

  void _submitForm() {
    if (_selectedAvatar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an avatar to proceed.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SuccessScreen(
          userName: _nameController.text,
          userEmail: _emailController.text,
          avatar: _selectedAvatar,
          strongPasswordMaster: _passwordController.text.length >= 12,
          earlyBirdSpecial: false,
          profileCompleter: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Choose an Avatar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 15),
                  AvatarSelector(
                    onAvatarSelected: (avatar) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() => _selectedAvatar = avatar);
                        _updateProgress();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    onChanged: (_) => _updateProgress(),
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: _validateName,
                  ),
                  TextFormField(
                    controller: _emailController,
                    onChanged: (_) => _updateProgress(),
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: _validateEmail,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (_) => _updateProgress(),
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  if (_passwordController.text.isNotEmpty)
                    PasswordStrengthMeter(password: _passwordController.text),
                  TextFormField(
                    controller: _confirmPasswordController,
                    onChanged: (_) => _updateProgress(),
                    obscureText: !_isPasswordVisible,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    validator: _validateConfirmPassword,
                  ),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please select your date of birth'
                        : null,
                  ),
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (_) {}),
                      const Expanded(
                        child: Text(
                          'I agree to the Terms of Service and Privacy Policy',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final AvatarModel? avatar;
  final bool strongPasswordMaster;
  final bool earlyBirdSpecial;
  final bool profileCompleter;

  const SuccessScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    this.avatar,
    this.strongPasswordMaster = false,
    this.earlyBirdSpecial = false,
    this.profileCompleter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Account Created! Welcome, $userName')),
    );
  }
}
