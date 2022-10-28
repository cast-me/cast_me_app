// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:protobuf/protobuf.dart';

// Project imports:
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';
import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';

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

  Future<void> setLiked(bool newValue) async {
    final Profile profile = AuthManager.instance.profile;
    await CastDatabase.instance.setLiked(cast: value, liked: newValue);
    final Cast newCast = value.deepCopy();
    if (newValue) {
      newCast.likes.add(
        Like(
          createdAtString: DateTime.now().toUtc().toString(),
          userId: profile.id,
          userDisplayName: profile.displayName,
        ),
      );
    } else {
      newCast.likes.removeWhere((like) => like.userId == profile.id);
    }
    value = newCast;
  }
}
