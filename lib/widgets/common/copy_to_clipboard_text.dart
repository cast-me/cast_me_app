import 'dart:async';

import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboardText extends StatefulWidget {
  const CopyToClipboardText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  State<CopyToClipboardText> createState() => _CopyToClipboardTextState();
}

class _CopyToClipboardTextState extends State<CopyToClipboardText> {
  Timer? messageTimer;

  bool get showMessage => messageTimer?.isActive == true;

  Timer newTimer() {
    return Timer(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: widget.text));
          setState(() {
            messageTimer = newTimer();
          });
        },
        child: AdaptiveMaterial(
          adaptiveColor: AdaptiveColor.background,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                const SizedBox(width: 2),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: showMessage
                        ? const _CopiedMessage()
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(widget.text),
                          ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.copy),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CopiedMessage extends StatelessWidget {
  const _CopiedMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Copied to clipboard');
  }
}
