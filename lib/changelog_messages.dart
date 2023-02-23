// Flutter imports:
import 'package:flutter/material.dart';

const Map<String, Widget> changelogMessages = {
  '0.1.8': Text(
    ''' - Topic selector shows count of new casts
 - Fixed bug with casts playing out of order
 - Notifications automatically play the relevant cast when selected
 - Casts can now link out to external content''',
  ),
  '0.1.9': Text(
    ''' - Fixed bug when expanding now playing sheet
 - Tweaked color palette
 - Improved cast posting and sharing UX''',
  ),
  '0.1.10': Text(
    ''' - Made buttons hip
 - Fixed bug when creating a new account''',
  ),
  '0.1.11': Text(
    ''' - Made cast ordering stable and more intuitive
 - Fixed bug with pull-down-to-refresh''',
  ),
  '0.2.0': Text(
    ''' - Massively overhauled the UI to group conversations together
 - Force screen to stay awake when recording (yw @drcookmfg :P)
 - Fixed bug with topic filtering
 - Fixed various bugs
 - ...and way more!!!''',
  ),
  '0.2.1': Text(
    ''' - Added `report cast` and `block user` features
 - fixed bug with selecting topics while posting''',
  ),
  '0.2.2': Text(
    ''' - Rebuilt the home page to include a `for you` sub-tab
 - Allow users to delete their account''',
  ),
  '0.2.9': Text(
    ''' - Added a notifications tab
 - Added a curated "top conversations" list
 - Made display names optional''',
  ),
};
