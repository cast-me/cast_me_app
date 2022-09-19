import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberMeView extends StatefulWidget {
  const RememberMeView({Key? key}) : super(key: key);

  static const toggleKeyString = 'remember_me';
  static const emailKeyString = 'remembered_email';

  @override
  State<RememberMeView> createState() => _RememberMeViewState();
}

class _RememberMeViewState extends State<RememberMeView> {
  final Future<SharedPreferences> preferencesFuture =
      SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: preferencesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final SharedPreferences preferences = snapshot.data!;
        return Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              setState(() {
                preferences.setBool(
                  RememberMeView.toggleKeyString,
                  !(preferences.getBool(RememberMeView.toggleKeyString) ??
                      false),
                );
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  activeColor: Colors.black,
                  value: preferences.getBool(RememberMeView.toggleKeyString) ??
                      false,
                  onChanged: (newValue) {
                    setState(() {
                      preferences.setBool(
                          RememberMeView.toggleKeyString, newValue!);
                      if (!newValue) {
                        preferences.setString(
                            RememberMeView.emailKeyString, '');
                      }
                    });
                  },
                ),
                const AdaptiveText('Remember me'),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
