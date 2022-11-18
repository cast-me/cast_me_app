// Flutter imports:
import 'package:cast_me_app/business_logic/models/serializable/cast.dart';
import 'package:cast_me_app/business_logic/models/serializable/profile.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';

class CastProvider extends InheritedWidget {
  CastProvider({
    Key? key,
    required Widget child,
    required this.initialCast,
  })  : currentCast = CastProviderData(initialCast),
        super(key: key, child: child);

  final Cast initialCast;
  final CastProviderData currentCast;

  static CastProviderData of(BuildContext context) {
    final CastProvider? result =
        context.dependOnInheritedWidgetOfExactType<CastProvider>();
    assert(result != null, 'No CastProvider found in context');
    return result!.currentCast;
  }

  @override
  bool updateShouldNotify(CastProvider oldWidget) {
    return oldWidget.initialCast != initialCast;
  }
}

class CastProviderData extends ValueNotifier<Cast> {
  CastProviderData(Cast initialCast) : super(initialCast);

  Future<void> setLiked(bool newIsLiked) async {
    final Profile profile = AuthManager.instance.profile;
    await CastDatabase.instance.setLiked(cast: value, liked: newIsLiked);
    value = value.copyWith(
      likes: newIsLiked
          ? [
              ...value.likes ?? [],
              Like(
                createdAt: DateTime.now().toUtc().toString(),
                userId: profile.id,
                userDisplayName: profile.displayName,
              ),
            ]
          : value.likes?.where((like) => like.userId != profile.id).toList(),
    );
  }
}
