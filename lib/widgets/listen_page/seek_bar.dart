import 'dart:math';

import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';

import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  const SeekBar({
    Key? key,
  }) : super(key: key);

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  final CastAudioPlayer player = CastAudioPlayer.instance;
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
          stream: player.positionDataStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final Cast cast = ListenBloc.instance.currentCast.value!;
            final PositionData data = snapshot.data!;
            return Stack(
              children: [
                // This is a mock slider to show the buffered position.
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: HiddenThumbComponentShape(),
                    activeTrackColor: Color.lerp(
                      cast.accentColor,
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
                    activeTrackColor: cast.accentColor,
                    inactiveTrackColor: Colors.transparent,
                    thumbColor: cast.accentColor,
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
                      player.seekTo(Duration(milliseconds: value.round()));
                      _dragValue = null;
                    },
                  ),
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
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: 0,
    );
  }
}
