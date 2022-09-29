import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:flutter/material.dart';

class RecordView extends StatelessWidget {
  const RecordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await showDialog<void>(
          context: context,
          builder: (context) {
            return const RecordAudioModal();
          },
        );
      },
      child: const Text('Record'),
    );
  }
}

class RecordAudioModal extends StatefulWidget {
  const RecordAudioModal({
    Key? key,
  }) : super(key: key);

  @override
  State<RecordAudioModal> createState() => _RecordAudioModalState();
}

class _RecordAudioModalState extends State<RecordAudioModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AdaptiveMaterial(
          adaptiveColor: AdaptiveColor.surface,
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
