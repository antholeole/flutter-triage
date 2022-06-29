import 'dart:ui';

/*
///transitions
typedef OnTransition<R extends TextSelectionOverlayState,
        T extends TextSelectionTransition>
    = R Function(T);

abstract class TextSelectionTransition<T extends TextSelectionOverlayState> {
  const TextSelectionTransition();
  T? maybeJoin({
    OnTransition<T, LongPressOnHandle>? onHandleLongPress,
    OnTransition<T, DoubleTapOnWord>? onWordDoubleTap,
    T Function()? defaultTo,
  }) {
    if (this is LongPressOnHandle && onHandleLongPress != null) {
      return onHandleLongPress(this as LongPressOnHandle);
    }

    if (this is DoubleTapOnWord && onWordDoubleTap != null) {
      return onWordDoubleTap(this as DoubleTapOnWord);
    }

    if (defaultTo != null) {
      return defaultTo();
    }

    return null;
  }

  T join({
    required OnTransition<T, LongPressOnHandle> onHandleLongPress,
    required OnTransition<T, DoubleTapOnWord> onWordDoubleTap,
  }) {
    final newState = maybeJoin(
        onHandleLongPress: onHandleLongPress, onWordDoubleTap: onWordDoubleTap);
    assert(newState != null, 'Attempted a join on $this with no transition.');
    return newState!;
  }

  T joinOrDefault({
    OnTransition<T, LongPressOnHandle>? onHandleLongPress,
    OnTransition<T, DoubleTapOnWord>? onWordDoubleTap,
    required T Function() defaultTo,
  }) {
    final newState = maybeJoin(onHandleLongPress: onHandleLongPress, onWordDoubleTap: onWordDoubleTap);

    // cast is safe: we require defaultTo, and maybeJoin is garunteed to return T 
    // if default is passed.
    return newState!; 
  }
}

/// A transition that represents a long press on a handle.
class LongPressOnHandle extends TextSelectionTransition {
  final Offset longPressPosition;

  const LongPressOnHandle({required this.longPressPosition});
}

class DoubleTapOnWord extends TextSelectionTransition {
  final Offset doubleTapPosition;

  final int wordBase;
  final int wordExtent;

  const DoubleTapOnWord(
      {required this.wordBase,
      required this.wordExtent,
      required this.doubleTapPosition});
}

/// Component states
class HandleState {
  final int base;
  final int extent;

  const HandleState({required this.base, required this.extent});
}

class LoupeState {
  final Offset position;

  const LoupeState({required this.position});
}

///states
abstract class TextSelectionOverlayState {
  final HandleState? handleState;
  final LoupeState? loupeState;

  const TextSelectionOverlayState({this.handleState, this.loupeState});

  TextSelectionOverlayState transition(TextSelectionTransition trns);
}

class WordSelectedState extends TextSelectionOverlayState {
  @override
  HandleState get handleState => _handleState;
  final HandleState _handleState;

  @override
  // TODO: implement loupeState
  LoupeState? get loupeState => ;

  @override
  TextSelectionOverlayState transition(TextSelectionTransition<TextSelectionOverlayState> trns) {
    // TODO: implement transition
    throw UnimplementedError();
  }

}

class EverythingDownState extends TextSelectionOverlayState {
  @override
  HandleState? get handleState => null;

  @override
  LoupeState? get loupeState => null;

  @override
  TextSelectionOverlayState transition(
      TextSelectionTransition<TextSelectionOverlayState> trns) {
    return trns.joinOrDefault(
      defaultTo: () => this,
      onWordDoubleTap: (doubleTap) => );
  }
}

class TextSelectionToolbarStateMachine {
  TextSelectionOverlayState get state => _state;

  TextSelectionOverlayState _state = EverythingDownState();

  TextSelectionToolbarStateMachine();

  void transition(TextSelectionTransition trns) =>
      _state = _state.transition(trns);
}
*/