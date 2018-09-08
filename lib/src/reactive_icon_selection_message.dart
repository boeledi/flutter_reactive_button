import 'package:flutter_reactive_button/src/reactive_icon_definition.dart';

class ReactiveIconSelectionMessage {
  ReactiveIconSelectionMessage({
    this.icon,
    this.isSelected,
  });

  final ReactiveIconDefinition icon;
  final bool isSelected;
}
