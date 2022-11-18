// Flutter imports:
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/widgets/post_page/partial_auto_complete.dart';

class TitleField extends StatelessWidget {
  const TitleField({Key? key, required this.titleText}) : super(key: key);

  final ValueNotifier<String> titleText;

  @override
  Widget build(BuildContext context) {
    return PartialAutocomplete<Profile>(
      optionsBuilder: (value) async {
        titleText.value = value.text;
        // TODO(caseycrogers): support auto complete within a string
        //  not just at the end.
        final String? startsWith =
            RegExp(r'@([^ @]+)$').firstMatch(value.text)?[1];
        if (startsWith == null || startsWith.isEmpty) {
          return [];
        }
        return AuthManager.instance.searchForProfiles(startsWith: startsWith);
      },
      displayStringForOption: (profile) {
        return '${profile.username} (${profile.displayName})';
      },
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Title*',
          ),
        );
      },
      updateTextField: (textController, selection) {
        final int lastAt = textController.value.text.lastIndexOf('@');
        final String newString =
            '${textController.value.text.substring(0, lastAt + 1)}'
            '${selection.username} ';
        textController.value = TextEditingValue(
          text: newString,
          selection: TextSelection.collapsed(offset: newString.length),
        );
      },
    );
  }
}
