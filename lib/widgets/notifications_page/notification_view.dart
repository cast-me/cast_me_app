import 'package:cast_me_app/business_logic/models/serializable/cast_me_notification.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({
    super.key,
    required this.icon,
    required this.image,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final Widget icon;

  final Widget image;

  final Widget title;

  final Widget body;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CastViewTheme(
      isInteractive: false,
      indentReplies: false,
      indicateNew: false,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: icon,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Theme.of(context).iconTheme.size,
                          width: Theme.of(context).iconTheme.size,
                          child: image,
                        ),
                        const SizedBox(width: 4),
                        Expanded(child: title),
                      ],
                    ),
                    const SizedBox(height: 4),
                    body,
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class ReplyNotificationView extends StatelessWidget {
  const ReplyNotificationView({
    required this.replyNotification,
    super.key,
  });

  final ReplyNotification replyNotification;

  @override
  Widget build(BuildContext context) {
    return NotificationView(
      icon: const Icon(Icons.reply, color: Colors.white),
      image: PreviewThumbnail(cast: replyNotification.data.replyCast),
      title: Text(
        replyNotification.baseNotification.title,
      ),
      body: CastPreview(
        cast: replyNotification.data.replyCast,
        padding: EdgeInsets.zero,
      ),
      onTap: () {},
    );
  }
}
