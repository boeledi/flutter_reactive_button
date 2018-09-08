import 'package:flutter/material.dart';
import 'package:flutter_reactive_button/src/reactive_button_bloc.dart';
import 'package:flutter_reactive_button/src/reactive_icon.dart';
import 'package:flutter_reactive_button/src/reactive_icon_definition.dart';

class ReactiveIconContainer extends StatefulWidget {
  ReactiveIconContainer({
    Key key,
    @required this.icons,
    @required this.position,
    @required this.bloc,
    @required this.iconWidth,
    @required this.decoration,
    @required this.padding,
    @required this.roundIcons,
    @required this.iconPadding,
    @required this.iconGrowRatio,
  }) : super(key: key);

  /// List of image assets to be used
  final List<ReactiveIconDefinition> icons;

  /// Width of each individual icons
  final double iconWidth;

  /// The BLoC to handle events
  final ReactiveButtonBloc bloc;

  /// The position of the icons container
  final Offset position;

  /// Decoration of the container
  final Decoration decoration;

  /// Padding of the container
  final EdgeInsets padding;

  /// Shape of the icons.  Are they round?
  final bool roundIcons;

  /// Padding between icons
  final double iconPadding;

  /// Icon grow ratio when hovered
  final double iconGrowRatio;

  @override
  _ReactiveIconContainerState createState() {
    return new _ReactiveIconContainerState();
  }
}

class _ReactiveIconContainerState extends State<ReactiveIconContainer> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position.dy,
      left: widget.position.dx,
      child: _buildIconsContainer(),
    );
  }

  Widget _buildIconsContainer() {
    final double containerWidth =
        widget.icons.length * (widget.iconWidth + widget.iconPadding) +
            widget.iconWidth * widget.iconGrowRatio;
    final double containerHeight = widget.iconWidth * widget.iconGrowRatio;

    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(containerWidth, containerHeight)),
      child: Container(
        decoration: widget.decoration,
        padding: widget.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.icons.map((ReactiveIconDefinition icon) {
            return ReactiveIcon(
              icon: icon,
              bloc: widget.bloc,
              iconWidth: widget.iconWidth,
              growRatio: widget.iconGrowRatio,
              roundIcon: widget.roundIcons,
            );
          }).toList(),
        ),
      ),
    );
  }
}
