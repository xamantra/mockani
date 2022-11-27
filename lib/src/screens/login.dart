import 'package:flutter/material.dart';
import 'package:mockani/src/constants/keys.dart';
import 'package:mockani/src/providers/auth_provider.dart';
import 'package:mockani/src/providers/theme_provider.dart';
import 'package:mockani/src/utils/theme_extension.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController token = TextEditingController();

  late final provider = Provider.of<AuthProvider>(context);
  late final themeProvider = Provider.of<ThemeProvider>(context);

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
      body: Stack(
        children: [
          Center(
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: IconButton(
                onPressed: () {
                  themeProvider.switchTheme();
                },
                tooltip: "Switch theme",
                icon: StreamBuilder(
                  stream: themeProvider.stream,
                  builder: (context, snapshot) {
                    return Icon(
                      themeProvider.darkMode ? Icons.dark_mode : Icons.light_mode,
                      size: 18,
                      color: getCustomTheme(context).onBackground,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
