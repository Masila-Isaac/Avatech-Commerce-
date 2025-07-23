import 'package:flutter/material.dart';
import 'package:tempo/screens/Homescreen.dart';

void main() {
  runApp(const Registration());
}

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avatech Commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const AvatechLoginScreen(),
    );
  }
}

class AvatechLoginScreen extends StatefulWidget {
  const AvatechLoginScreen({super.key});

  @override
  State<AvatechLoginScreen> createState() => _AvatechLoginScreenState();
}

class _AvatechLoginScreenState extends State<AvatechLoginScreen> {
  final TextEditingController _mpesaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _mpesaController.dispose();
    super.dispose();
  }

  void _submitPhone() {
    if (_formKey.currentState!.validate()) {
      final phone = _mpesaController.text.trim();
      print("M-Pesa Number Submitted: +254$phone");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('M-Pesa number submitted successfully')),
      );

      // Navigate after short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Homescreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101820),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag, size: 80, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Avatech Commerce',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _mpesaController,
                    keyboardType: TextInputType.number,
                    maxLength: 9,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixText: '+254 ',
                      hintText: 'Enter your registered M-Pesa No.',
                      filled: true,
                      fillColor: Colors.white,
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your M-Pesa number';
                      }
                      if (!RegExp(r'^[17]\d{8}$').hasMatch(value.trim())) {
                        return 'Enter a valid 9-digit M-Pesa number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitPhone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
