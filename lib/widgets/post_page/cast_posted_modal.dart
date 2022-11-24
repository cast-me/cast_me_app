// Flutter imports:
import 'package:adaptive_material/adaptive_material.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:cast_me_app/business_logic/cast_me_bloc.dart';
import 'package:cast_me_app/business_logic/clients/share_client.dart';
import 'package:cast_me_app/business_logic/listen_bloc.dart';
import 'package:cast_me_app/business_logic/models/cast_me_tab.dart';
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/providers/cast_provider.dart';
import 'package:cast_me_app/widgets/common/cast_menu.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:cast_me_app/widgets/common/copy_to_clipboard_text.dart';

class CastPostedModal extends StatelessWidget {
  const CastPostedModal({Key? key, required this.cast}) : super(key: key);

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    return CastProvider(
      initialCast: cast,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Cast posted!',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AdaptiveMaterial.background(
              child: CastViewTheme(
                showLikes: false,
                showMenu: false,
                indicateNew: false,
                onTap: (cast) {
                  Navigator.of(context).pop();
                  CastMeBloc.instance.onTabChanged(CastMeTab.listen);
                  ListenBloc.instance.onCastSelected(cast);
                },
                child: CastPreview(cast: cast),
              ),
            ),
          ),
          const SizedBox(height: 8),
          CopyToClipboardText(text: ShareClient.instance.castShareUrl(cast)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.twitter),
                onPressed: () {
                  ShareClient.instance.shareToTwitter(cast);
                },
              ),
              const ShareButton(),
            ],
          ),
        ],
      ),
    );
  }
}
