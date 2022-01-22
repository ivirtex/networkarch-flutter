// Flutter imports:
import 'package:flutter/material.dart';

typedef RemovedItemBuilder<T> = Widget Function(
  BuildContext context,
  Animation<double> animation,
  T item,
);

class AnimatedListModel<T> {
  AnimatedListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<T>? initialItems,
  }) : _items = List<T>.from(initialItems ?? <T>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<T> removedItemBuilder;
  final List<T> _items;

  final Animatable<Offset> slideTween = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInOut));
  final Animatable<double> fadeTween = Tween<double>(
    begin: 0,
    end: 1,
  );

  AnimatedListState? get _animatedListState => listKey.currentState;

  int get length => _items.length;

  T get last => _items.last;

  bool get isEmpty => _items.isEmpty;

  T operator [](int index) => _items[index];

  int indexOf(T item) => _items.indexOf(item);

  void insert(int index, T item) {
    _items.add(item);
    _animatedListState!.insertItem(index);
  }

  void add(T element) {
    _items.add(element);
  }

  void clear() => _items.clear();

  Future<T> removeAt(int index) async {
    final T removedItem = _items.removeAt(index);

    if (removedItem != null) {
      _animatedListState!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(context, animation, removedItem);
        },
      );
    }

    // Default insert/remove animation duration is 300 ms,
    // so we need to wait for the animation to complete
    // before we can remove object from the list.
    await Future.delayed(const Duration(milliseconds: 350));

    return removedItem;
  }

  Future<void> removeAllElements(BuildContext context) async {
    for (int i = length - 1; i >= 0; --i) {
      final T removedItem = _items.removeAt(i)!;

      _animatedListState!.removeItem(
        i,
        (context, animation) =>
            removedItemBuilder(context, animation, removedItem),
      );

      await Future.delayed(const Duration(milliseconds: 100));
    }

    _items.clear();
  }
}
