// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({super.key});

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
      model: _model,
      child: const _GroupFormWidgetBody(),
    );
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New group'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _GroupNameWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
        onPressed: () => GroupFormWidgetModelProvider.read(context)
            ?.model
            .saveGroup(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.read(context)?.model;
    return TextField(
      autofocus: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Group Name',
      ),
      onChanged: ((value) => model?.groupeName = value),
      onEditingComplete: () => model?.saveGroup(context),
    );
  }
}
