import 'package:flutter/material.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final passwordController = TextEditingController();
  final AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _sumbit() {}

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 320,
        width: deviceSize.width * 0.85,
        child: Form(
            child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              onSaved: (email) => _authData['email'] = email ?? '',
              validator: (value) {
                final email = value ?? '';
                if (email.trim().isEmpty || !email.contains('@')) {
                  return 'Informe um e-mail válido.';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Senha'),
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              controller: passwordController,
              onSaved: (password) => _authData['password'] = password ?? '',
              validator: _authMode == AuthMode.login
                  ? null
                  : (password) {
                      final pass = password ?? '';
                      if (pass.isEmpty || pass.length < 5) {
                        return 'Informe uma senha válida';
                      }
                      return null;
                    },
            ),
            if (_authMode == AuthMode.signup)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                validator: (password) {
                  final pass = password ?? '';
                  if (pass != passwordController.text) {
                    return 'Senhas informadas não conferem.';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sumbit,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 15)),
              child: Text(_authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR'),
            ),
          ],
        )),
      ),
    );
  }
}
