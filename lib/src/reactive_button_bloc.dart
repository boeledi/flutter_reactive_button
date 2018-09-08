import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_reactive_button/src/reactive_icon_selection_message.dart';

class ReactiveButtonBloc {
  //
  // Stream that allows broadcasting the pointer movements
  //
  PublishSubject<Offset> _pointerPositionController = PublishSubject<Offset>();
  Sink<Offset> get inPointerPosition => _pointerPositionController.sink;
  Observable<Offset> get outPointerPosition =>
      _pointerPositionController.stream;

  //
  // Stream that allows broadcasting the icons selection
  //
  PublishSubject<ReactiveIconSelectionMessage> _iconSelectionController =
      PublishSubject<ReactiveIconSelectionMessage>();
  Sink<ReactiveIconSelectionMessage> get inIconSelection =>
      _iconSelectionController.sink;
  Stream<ReactiveIconSelectionMessage> get outIconSelection =>
      _iconSelectionController.stream;

  //
  // Dispose the resources
  //
  void dispose() {
    _iconSelectionController.close();
    _pointerPositionController.close();
  }
}
