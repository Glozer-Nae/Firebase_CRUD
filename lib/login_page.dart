import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'forgot_pass.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService auth = AuthService();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool loading = false;

  void _showForgotPasswordDialog() {
  final TextEditingController resetEmailCtrl = TextEditingController();

  //for FORGOT PASSWORD UI
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Reset Password"),
        content: TextField(
          controller: resetEmailCtrl,
          decoration: const InputDecoration(
            labelText: "Enter your email address",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Send Link"),
            onPressed: () async {
              if (resetEmailCtrl.text.isEmpty) return;
              
              try {
                // Call the auth service method
                await auth.sendPasswordReset(resetEmailCtrl.text.trim());
                
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password reset link sent! Check your inbox.")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${e.toString()}")),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page - Alolod")), 
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Email Login ---
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ), 
              ), 
              SizedBox(height: 12),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ), 
              ), 

              Align( 
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog, 
                  child: const Text("Forgot Password?"),
                ),
              ),

              SizedBox(height: 12),
              ElevatedButton(
                child: loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Login with Email"),
                onPressed: () async {
                  setState(() => loading = true);
                  final user = await auth.signInWithEmail(
                      emailCtrl.text, passwordCtrl.text);
                  setState(() => loading = false);

                  if (user != null) {
                    if (!user.emailVerified) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Please verify your email before logging in."),
                        ), 
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Homepage()),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid email or password")),
                    );
                  }
                },
              ), 
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("OR"),
                  ), 
                  Expanded(child: Divider()),
                ],
              ), 
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text("Sign in with Google"),
                onPressed: () async {
                  setState(() => loading = true);
                  final user = await auth.signInWithGoogle();
                  setState(() => loading = false);
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => Homepage()),
                    );
                  }
                },
              ), 
           
              SizedBox(height: 12),
              TextButton(
                child: Text("Don't have an account? Register"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  );
                },
              ), 
            ],
          ), 
        ), 
      ), 
    ); 
  }
}