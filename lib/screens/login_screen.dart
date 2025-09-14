import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'calendar_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _login() {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preencha email e senha")));
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CalendarScreen(userName: _emailCtrl.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: "Senha"), obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: const Text("Entrar")),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                },
                child: const Text("Não é cadastrado? Cadastre-se"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
