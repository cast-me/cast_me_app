import 'package:async_list_view/async_list_view.dart';
import 'package:cast_me_app/business_logic/clients/auth_manager.dart';

import 'package:cast_me_app/business_logic/clients/cast_database.dart';
import 'package:cast_me_app/business_logic/models/cast.dart';
import 'package:cast_me_app/util/adaptive_material.dart';
import 'package:cast_me_app/widgets/common/cast_view.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CastListView extends StatefulWidget {
  const CastListView({
    Key? key,
    this.filterProfile,
    this.padding,
    this.fullyInteractive = true,
  }) : super(key: key);

  /// If non-null, fetch only casts authored by the specified user.
  final Profile? filterProfile;

  final bool fullyInteractive;
  final EdgeInsets? padding;

  @override
  State<CastListView> createState() => CastListViewState();

  static CastListViewState of(BuildContext context) {
    return context.findAncestorStateOfType<CastListViewState>()!;
  }
}

class CastListViewState extends State<CastListView> {
  late Stream<Cast> _castStream = _getStream();

  void refresh() {
    setState(() {
      _castStream = _getStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        refresh();
      },
      child: AsyncListView<Cast>(
        padding: widget.padding,
        stream: _castStream,
        itemBuilder: (
          context,
          snapshot,
          index,
        ) {
          if (!snapshot.hasData) {
            return const AdaptiveText('loading...');
          }
          return CastPreview(
            cast: snapshot.data![index],
            fullyInteractive: widget.fullyInteractive,
          );
        },
        noResultsWidgetBuilder: (context) {
          return const Center(
            child: Text(
              'Could not find any casts',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  Stream<Cast> _getStream() {
    return CastDatabase.instance
        .getCasts(filterProfile: widget.filterProfile)
        .handleError((Object error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
