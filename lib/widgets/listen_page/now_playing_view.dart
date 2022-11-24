// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/cast_audio_player.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/external_link_modal.dart';
import 'package:cast_me_app/widgets/listen_page/audio_playback_controls.dart';
import 'package:cast_me_app/widgets/listen_page/seek_bar.dart';
import 'package:cast_me_app/widgets/listen_page/track_list_view.dart';

class NowPlayingCollapsedView extends StatelessWidget {
  const NowPlayingCollapsedView({Key? key}) : super(key: key);

  ListenBloc get model => CastMeBloc.instance.listenBloc;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Cast?>(
      valueListenable: model.currentCast,
      builder: (context, cast, _) {
        if (cast == null) {
          return Container();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: CastViewTheme(
                    isInteractive: false,
                    showMenu: false,
                    taggedUsersAreTappable: false,
                    indentReplies: false,
                    showLikes: false,
                    indicateNew: false,
                    showLink: false,
                    titleMaxLines: 1,
                    child: CastPreview(
                      cast: cast,
                      showHowOld: false,
                    ),
                  ),
                ),
                if (cast.externalUri != null)
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: () {
                      ExternalLinkModal.showMessage(
                        context,
                        cast.externalUri!,
                      );
                    },
                  ),
                const PlayButton(),
                const SkipCast(),
              ],
            ),
            const _NonInteractiveSeekBar(),
          ],
        );
      },
    );
  }
}

class _NonInteractiveSeekBar extends StatelessWidget {
  const _NonInteractiveSeekBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: CastAudioPlayer.instance.positionDataStream,
      builder: (context, positionSnap) {
        return LinearProgressIndicator(
          minHeight: 1,
          value: positionSnap.data?.progress,
          color: ListenBloc.instance.currentCast.value!.accentColor,
          backgroundColor: Theme.of(context).colorScheme.background,
        );
      },
    );
  }
}

class NowPlayingExpandedView extends StatelessWidget {
  const NowPlayingExpandedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Cast?>(
      valueListenable: ListenBloc.instance.currentCast,
      builder: (context, cast, _) {
        if (cast == null) {
          return Container();
        }
        return ValueListenableBuilder<bool>(
          valueListenable: ListenBloc.instance.trackListIsDisplayed,
          builder: (context, displayTrackList, _) {
            return Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: displayTrackList
                        ? const TrackListView()
                        : Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: CastView(cast: cast),
                          ),
                  ),
                ),
                SeekBar(
                  positionDataStream:
                      CastAudioPlayer.instance.positionDataStream,
                  seekTo: CastAudioPlayer.instance.seekTo,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 12,
                    right: 24,
                    left: 24,
                  ),
                  child: AudioPlaybackControls(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
