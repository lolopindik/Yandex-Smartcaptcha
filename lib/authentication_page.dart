import 'package:flutter/material.dart';
import 'package:flutter_yandex_smartcaptcha/flutter_yandex_smartcaptcha.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  //todo add sitekey
  String siteKey = '';
  late final CaptchaConfig captchaConfig;
  final Controller _controller = Controller();
  String? _token;

  @override
  void initState() {
    super.initState();
    captchaConfig = CaptchaConfig(
      siteKey: siteKey,
      testMode: false,
      languageCaptcha: 'ru',
      invisible: false,
      isWebView: false,
      colorBackground: Colors.transparent,
    );
    _controller.onReadyCallback(() {
      debugPrint('SmartCaptcha controller is ready');
    });
  }

  void _handleTokenResult(String? token) {
    setState(() {
      _token = token;
    });
    debugPrint('call: tokenResultCallback $token');
  }

  void _authenticate() {
    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка аутентификации'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Аутентификация успешна'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(54, 255, 255, 0),
        title: const Text(
          'Аутентификация',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black54,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 35,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 150),
                const TextField(
                  decoration: InputDecoration(label: Text('Логин')),
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(label: Text('Пароль')),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _authenticate();
                    },
                    child: const Text('Продолжить'),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 120,
                      child: YandexSmartCaptcha(
                        captchaConfig: captchaConfig,
                        onLoadWidget: const Center(
                          child: Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        controller: _controller,
                        challengeViewCloseCallback: () {
                          debugPrint('call: challengeViewCloseCallback');
                        },
                        challengeViewOpenCallback: () {
                          debugPrint('call: challengeViewOpenCallback');
                        },
                        networkErrorCallback: () {
                          debugPrint('call: networkErrorCallback');
                        },
                        tokenResultCallback: _handleTokenResult,
                        shouldOpenPolicy: (String urlPolicy) {
                          return !urlPolicy.contains('smartcaptcha_notice');
                        },
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
