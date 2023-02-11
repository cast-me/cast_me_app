// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';

class SeekBar extends StatefulWidget {
  const SeekBar({
    super.key,
    required this.positionDataStream,
    required this.seekTo,
  });

  final Stream<PositionData> positionDataStream;
  final Future<void> Function(Duration) seekTo;

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
        trackShape: CastMeTrackShape(),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 4,
        ),
      ),
      child: StreamBuilder<PositionData>(
          stream: widget.positionDataStream,
          builder: (context, snapshot) {
            final PositionData data = snapshot.data ??
                PositionData(
                  Duration.zero,
                  Duration.zero,
                  Duration.zero,
                );
            return Stack(
              children: [
                // This is a mock slider to show the buffered position.
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: HiddenThumbComponentShape(),
                    activeTrackColor: Color.lerp(
                      Colors.white,
                      Colors.black,
                      .6,
                    ),
                    inactiveTrackColor: Colors.black,
                  ),
                  child: ExcludeSemantics(
                    child: Slider(
                      min: 0,
                      max: data.duration!.inMilliseconds.toDouble(),
                      value: min(
                        data.bufferedPosition.inMilliseconds.toDouble(),
                        data.duration!.inMilliseconds.toDouble(),
                      ),
                      onChanged: (double value) {},
                    ),
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.transparent,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    min: 0,
                    max: data.duration!.inMilliseconds.toDouble(),
                    value: min(
                        _dragValue ?? data.position.inMilliseconds.toDouble(),
                        data.duration!.inMilliseconds.toDouble()),
                    onChanged: (value) {
                      setState(() {
                        _dragValue = value;
                      });
                    },
                    onChangeEnd: (value) {
                      widget.seekTo(Duration(milliseconds: value.round()));
                      _dragValue = null;
                    },
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 0,
                  child: Text(data.position.toFormattedString(),
                      style: Theme.of(context).textTheme.caption),
                ),
                Positioned(
                  right: 16,
                  bottom: 0,
                  child: Text(
                      (data.duration! - data.position).toFormattedString(),
                      style: Theme.of(context).textTheme.caption),
                ),
              ],
            );
          }),
    );
  }
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class CastMeTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: 0,
    );
  }
}
