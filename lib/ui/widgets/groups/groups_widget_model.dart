// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/domain/data_provider/box_mahager.dart';
import 'package:to_do_list/domain/entity/group.dart';

import 'package:to_do_list/ui/navigation/main_navigation.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _lisableBox;
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  void showTasks(BuildContext context, int groupIndex) async {
    final groupKey = (await _box).keyAt(groupIndex) as int;

    unawaited(
      Navigator.of(context).pushNamed(
        MainNavigationRouteNames.tasks,
        arguments: groupKey,
      ),
    );
  }

  void deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = box.keyAt(groupIndex) as int;
    await Hive.deleteBoxFromDisk(BoxManager.instance.makeTaskBoxName(groupKey));
    await box.delete(groupKey);
  }

  void _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    _readGroupsFromHive();
    _lisableBox = (await _box).listenable();
    _lisableBox?.addListener(_readGroupsFromHive);
  }

  @override
  void dispose() async {
    _lisableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
