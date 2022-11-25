import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController token = TextEditingController();

  late final provider = Provider.of<AuthProvider>(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    provider.stream.listen((event) {
      if (event.loggedIn) {
        Navigator.pushNamedAndRemoveUntil(context, HOME_ROUTE, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 480,
          child: StreamBuilder(
            stream: provider.stream,
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    enabled: !provider.loading,
                    controller: token,
                    decoration: const InputDecoration(
                      hintText: "WaniKani Token",
                      labelText: "WaniKani Token",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.loading
                          ? null
                          : () {
                              if (token.text.isNotEmpty) {
                                provider.login(token.text);
                              }
                            },
                      child: const Text(
                        "LOGIN",
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
