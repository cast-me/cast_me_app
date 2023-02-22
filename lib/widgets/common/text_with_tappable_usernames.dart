import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TappableUsernameText extends StatelessWidget {
  const TappableUsernameText(
    this.text, {
    super.key,
    this.style,
    this.taggedUsernames,
    this.maxLines,
    this.textAlign,
    this.overflow,
  });

  final String text;
  final List<String>? taggedUsernames;

  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      _constructSpan(),
      style: const TextStyle(color: Colors.white),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  List<String> getTaggedUsernames() {
    return RegExp('@([^ @]+)[ \$]?')
        .allMatches(text)
        .map((m) => m[1]!)
        .toList();
  }

  // Parse the title into a list of spans where valid usernames are underlined
  // and everything else is normal.
  TextSpan _constructSpan() {
    final usernames = taggedUsernames ?? getTaggedUsernames();
    if (usernames.isEmpty) {
      return TextSpan(text: text);
    }
    // Code golf! :D
    // Try to improve, I'm sure there's lots of low hanging fruit on mine.
    // This is also a brittle poor readability nightmare, maybe consider giving
    // up on code golf and making it readable instead.
    int i = 0;
    return TextSpan(
      children: [
        ...(usernames
                .expand((username) => '@$username'.allMatches(text))
                .toList()
              ..sortBy<num>((m) => m.start))
            .expand((m) {
          final List<TextSpan> spans = [
            if (m.start > i) TextSpan(text: text.substring(i, m.start)),
            // Underline the username.
            TextSpan(
              text: text.substring(m.start, m.end),
              style: const TextStyle(decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Add 1 to snip the `@` from the start.
                  CastMeBloc.instance.onUsernameSelected(
                    text.substring(m.start + 1, m.end),
                  );
                },
            ),
          ];
          i = m.end;
          return spans;
        }),
        if (i < text.length) TextSpan(text: text.substring(i)),
      ],
    );
  }
}
