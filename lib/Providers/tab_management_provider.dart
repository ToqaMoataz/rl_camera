import 'package:flutter/cupertino.dart';

class TabManagementProvider extends ChangeNotifier {
  late int selectedTab;

  TabManagementProvider() {
    selectedTab = 0;
  }

  void changeTab({required int index}) {
    selectedTab = index;
    notifyListeners();
  }
}
