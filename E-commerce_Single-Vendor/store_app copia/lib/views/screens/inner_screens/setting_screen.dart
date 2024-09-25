import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return Scaffold(
      appBar: AppBar(title: Text(translate('select language'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
            child: DropdownButton<String>(
              value: localizationDelegate.currentLocale.languageCode,
              onChanged: (String? locale) {
                if (locale != null) {
                  // Change the locale
                  changeLocale(context, locale);
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(translate('en')),
                ),
                DropdownMenuItem(
                  value: 'it',
                  child: Text(translate('it')),
                ),
                DropdownMenuItem(
                  value: 'zh',
                  child: Text(translate('zh')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
