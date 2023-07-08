import 'package:flutter/material.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  void _swithAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _sumbit() {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    if(_isLogin()){
      
    } else {

    }

    formKey.currentState?.save();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 340 : 400,
        width: deviceSize.width * 0.85,
        child: Form(
            key: formKey,
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
                  validator: (password) {
                    final pass = password ?? '';
                    if (pass.isEmpty || pass.length < 5) {
                      return 'Informe uma senha válida';
                    }
                    return null;
                  },
                ),
                if (_isSignup())
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirmar Senha'),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: _isLogin()
                        ? null
                        : (password) {
                            final pass = password ?? '';
                            if (pass != passwordController.text) {
                              return 'Senhas informadas não conferem.';
                            }
                            return null;
                          },
                  ),
                const SizedBox(height: 20),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _sumbit,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 15)),
                    child: Text(
                        _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR'),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: _swithAuthMode,
                  child: Text(
                      _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?'),
                ),
              ],
            )),
      ),
    );
  }
}
