import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';

  Widget build(BuildContext context) {
    final authService = ref.watch<AuthService>(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/mobile.svg',
              height: 250,
            ),
            Card(
              child: TextFormField(
                initialValue: '+91',
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _phoneNumber = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await authService.verifyPhoneNumber(_phoneNumber);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OptScreen()));
                }
              },
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

class OptScreen extends ConsumerStatefulWidget {
  const OptScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OptScreenState();
}

class _OptScreenState extends ConsumerState<OptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  late AuthService _authService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = ref.read<AuthService>(authProvider);
  }

  void _handleOtpSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.signWithOtp(_otpController.text);
        Navigator.pop(context);
      } catch (error) {
        print(error.toString());
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/otp.svg',
                height: 250,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter OTP';
                    }
                    if (value.length != 6) {
                      return 'OTP must be 6 digits';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: _isLoading ? null : _handleOtpSubmit,
                child: Chip(
                    label: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Submit OTP',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          )),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () async {
                  await _authService.resendOTP();
                },
                child: const Text('Resend OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
