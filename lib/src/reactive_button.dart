import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_button/src/reactive_icon_container.dart';
import 'package:flutter_reactive_button/src/reactive_icon_definition.dart';
import 'package:flutter_reactive_button/src/reactive_button_bloc.dart';
import 'package:flutter_reactive_button/src/reactive_icon_selection_message.dart';
import 'package:flutter_reactive_button/src/widget_position.dart';

typedef ReactiveButtonCallback(ReactiveIconDefinition button);

const double _kIconGrowRatio = 1.2;
const double _kIconsPadding = 8.0;
const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

final BoxDecoration _kDefaultDecoration = BoxDecoration(
  border: Border.all(
    width: 1.0,
    color: Colors.black54,
  ),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: <BoxShadow>[
    BoxShadow(
        offset: Offset(0.0, 3.0),
        blurRadius: 1.0,
        spreadRadius: -2.0,
        color: _kKeyUmbraOpacity),
    BoxShadow(
        offset: Offset(0.0, 2.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
        color: _kKeyPenumbraOpacity),
    BoxShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 5.0,
        spreadRadius: 0.0,
        color: _kAmbientShadowOpacity),
  ],
  color: Colors.white12,
);

/// A Widget that mimics the Facebook Reaction Button in Flutter.
///
/// A ReactiveButton expects a minimum of 4 parameters [icons], [onSelected], [onTap], [child].
///
/// The [icons] contains the list of all the icon assets which will be displayed, together with a code associate to them.
/// The [onSelected] is called when the user releases the pointer over an icon.
/// The [onTap] is called when the user has simply tapped the [ReactiveButton]
/// The [child] defines the button itself as a Widget
///
class ReactiveButton extends StatefulWidget {
  ReactiveButton({
    Key key,
    @required this.icons,
    @required this.onSelected,
    @required this.onTap,
    @required this.child,
    this.iconWidth: 32.0,
    this.roundIcons: true,
    this.iconPadding: _kIconsPadding,
    this.iconGrowRatio: _kIconGrowRatio,
    this.decoration,
    this.padding: const EdgeInsets.all(4.0),
    this.containerPadding: 4.0,
    this.containerAbove: true,
  }) : super(key: key);

  /// List of image assets, associated to a code, to be used (mandatory)
  final List<ReactiveIconDefinition> icons;

  /// Callback to be used when the user makes a selection (mandatory)
  final ReactiveButtonCallback onSelected;

  /// Callback to be used when the user proceeds with a simple tap (mandatory)
  final VoidCallback onTap;

  /// Child (mandatory)
  final Widget child;

  /// Width of each individual icons (default: 32.0)
  final double iconWidth;

  /// Shape of the icons.  Are they round? (default: true)
  final bool roundIcons;

  /// Padding between icons (default: 8.0)
  final double iconPadding;

  /// Icon grow ratio when hovered (default: 1.2)
  final double iconGrowRatio;

  /// Decoration of the container.  If none provided, the default one will be used
  final Decoration decoration;

  /// Padding of the container (default: EdgeInsets.all(4.0))
  final EdgeInsets padding;

  /// Distance between the button and the container (default: 4.0)
  final double containerPadding;

  /// Do we prefer showing the container above the button (if there is room)? (default: true)
  final bool containerAbove;

  @override
  _ReactiveButtonState createState() => _ReactiveButtonState();
}

class _ReactiveButtonState extends State<ReactiveButton> {
  ReactiveButtonBloc bloc;
  OverlayState _overlayState;
  OverlayEntry _overlayEntry;
  StreamSubscription streamSubscription;
  ReactiveIconDefinition _selectedButton;

  // Timer to be used to determine whether a longPress completes
  Timer timer;

  // Flag to know whether we dispatch the onTap
  bool isTap = true;

  // Flag to know whether the drag has started
  bool dragStarted = false;

  @override
  void initState() {
    super.initState();

    // Initialization of the OverlayButtonBloc
    bloc = ReactiveButtonBloc();

    // Start listening to messages from icons
    streamSubscription = bloc.outIconSelection.listen(_onIconSelectionChange);
  }

  @override
  void dispose() {
    _cancelTimer();
    _hideIcons();
    streamSubscription?.cancel();
    bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onVerticalDragStart: _onDragStart,
      onHorizontalDragCancel: _onDragCancel,
      onVerticalDragCancel: _onDragCancel,
      onHorizontalDragEnd: _onDragEnd,
      onVerticalDragEnd: _onDragEnd,
      onHorizontalDragDown: _onDragReady,
      onVerticalDragDown: _onDragReady,
      onHorizontalDragUpdate: _onDragMove,
      onVerticalDragUpdate: _onDragMove,
      onTap: _onTap,
      child: widget.child,
    );
  }

  //
  // The user did a simple tap.
  // We need to tell the parent
  //
  void _onTap() {
    _cancelTimer();
    if (isTap && widget.onTap != null) {
      widget.onTap();
    }
  }

  // The user released his/her finger
  // We need to hide the icons and provide
  // his/her decision if any and if this is
  // not a Tap
  void _onDragEnd(DragEndDetails details) {
    _cancelTimer();
    _hideIcons();
    if (widget.onSelected != null && _selectedButton != null) {
      widget.onSelected(_selectedButton);
    }
  }

  void _onDragReady(DragDownDetails details) {
    // Let's wait some time to make the distinction
    // between a Tap and a LongTap
    isTap = true;
    dragStarted = false;
    _startTimer();
  }

  // Little trick to make sure we are hiding
  // the Icons container if a 'dragCancel' is
  // triggered while no move has been detected
  void _onDragStart(DragStartDetails details) {
    dragStarted = true;
  }

  void _onDragCancel() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!dragStarted) {
      _hideIcons();
    }
  }

  //
  // The user is moving the pointer around the screen
  // We need to pass this information to whomever
  // might be interested (icons)
  //
  void _onDragMove(DragUpdateDetails details) {
    bloc.inPointerPosition.add(details.globalPosition);
  }

  // ###### LongPress related ##########

  void _startTimer() {
    _cancelTimer();
    timer = Timer(Duration(milliseconds: 500), _showIcons);
  }

  void _cancelTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  // ###### Icons related ##########

  // We have waited enough to consider that this is
  // a long Press.  Therefore, let's display
  // the icons
  void _showIcons() {
    // It is no longer a Tap
    isTap = false;

    // Retrieve the Overlay
    _overlayState = Overlay.of(context);

    // Generate the ReactionIconContainer that will be displayed onto the Overlay
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return ReactiveIconContainer(
          icons: widget.icons,
          iconWidth: widget.iconWidth,
          position: _getIconsContainerPosition(),
          bloc: bloc,
          decoration: widget.decoration ?? _kDefaultDecoration,
          iconGrowRatio: widget.iconGrowRatio,
          iconPadding: widget.iconPadding,
          padding: widget.padding,
          roundIcons: widget.roundIcons,
        );
      },
    );

    // Add it to the Overlay
    _overlayState.insert(_overlayEntry);
  }

  void _hideIcons() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Routine that determines the position
  // of the icons container, related to the position
  // of the button
  Offset _getIconsContainerPosition() {
    // Obtain the position of the button
    final WidgetPosition widgetPosition = WidgetPosition.fromContext(context);

    // Compute the dimensions of the container
    final double containerWidth =
        widget.icons.length * (widget.iconWidth + widget.iconPadding) +
            widget.iconWidth * widget.iconGrowRatio;
    final double containerHeight = widget.iconWidth * widget.iconGrowRatio;

    // Compute the final left position
    double left;

    // If the button is located on the right side of the screen, prefer
    // trying to align the right edges (button and container)
    if (widgetPosition.xPositionInViewport > widgetPosition.viewportWidth / 2) {
      left = (widgetPosition.xPositionInViewport +
              widgetPosition.rect.width -
              containerWidth)
          .clamp(0.0, double.infinity);
    } else {
      left = (widgetPosition.xPositionInViewport + containerWidth);
      if (left > widgetPosition.viewportWidth) {
        left = (widgetPosition.viewportWidth - containerWidth)
            .clamp(0.0, double.infinity);
      }
    }

    // Compute the final top position
    double top;

    // If there is enough space above the button and the user wants to display it above
    if (widget.containerAbove) {
      final double roomAbove =
          widgetPosition.rect.top - containerHeight - widget.containerPadding;
      if (roomAbove >= 0) {
        top = widgetPosition.yPositionInViewport -
            containerHeight -
            widget.containerPadding;
      } else {
        // There is not enough space, so display it below
        top = widgetPosition.yPositionInViewport +
            widgetPosition.rect.height +
            widget.containerPadding;
      }
    } else {
      final double roomBelow = widgetPosition.viewportHeight -
          (widgetPosition.rect.bottom +
              containerHeight +
              widget.containerPadding);
      if (roomBelow >= 0) {
        top = widgetPosition.yPositionInViewport +
            widgetPosition.rect.height +
            widget.containerPadding;
      } else {
        // There is not enough space, so display it above
        top = widgetPosition.yPositionInViewport -
            containerHeight -
            widget.containerPadding;
      }
    }

    return Offset(left, top);
  }

  //
  // A message has been sent by an icon to indicate whether
  // it is highlighted or not
  //
  void _onIconSelectionChange(ReactiveIconSelectionMessage message) {
    if (identical(_selectedButton, message.icon)) {
      if (!message.isSelected) {
        _selectedButton = null;
      }
    } else {
      if (message.isSelected) {
        _selectedButton = message.icon;
      }
    }
  }
}
