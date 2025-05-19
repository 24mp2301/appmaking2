import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool isLoading = false;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Password reset email sent")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Reset Your Password", style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) => email = val,
                  validator:
                      (val) =>
                          val != null && val.contains('@')
                              ? null
                              : 'Enter valid email',
                ),
                SizedBox(height: 30),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text("Send Reset Email"),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
