import 'package:async_list_view/async_list_view.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';

import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/cast_view.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CastListView extends StatefulWidget {
  const CastListView({
    Key? key,
    this.filterProfiles,
  }) : super(key: key);

  /// If non-null, fetch only casts authored by these users.
  final List<Profile>? filterProfiles;

  @override
  State<CastListView> createState() => _CastListViewState();
}

class _CastListViewState extends State<CastListView> {
  Stream<Cast> castStream =
      CastDatabase.instance.getCasts().handleError((Object error) {
    if (kDebugMode) {
      print(error);
    }
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        _getStream();
        setState(() {});
      },
      child: AsyncListView<Cast>(
        padding: const EdgeInsets.all(8),
        stream: CastDatabase.instance.getCasts().handleError((Object error) {
          if (kDebugMode) {
            print(error);
          }
        }),
        itemBuilder: (
          context,
          snapshot,
          index,
        ) {
          if (!snapshot.hasData) {
            return const AdaptiveText('loading...');
          }
          return CastPreview(cast: snapshot.data![index]);
        },
      ),
    );
  }

  Stream<Cast> _getStream() {
    return CastDatabase.instance
        .getCasts(filterProfiles: widget.filterProfiles);
  }
}
