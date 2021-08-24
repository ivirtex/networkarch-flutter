import 'package:flutter/cupertino.dart';

typedef RemovedItemBuilder = Widget Function(
  int item,
  BuildContext context,
  Animation<double> animation,
);

class ListModel<T> {
  ListModel(
    this.listKey,
    this.removedItemBuilder,
    this._items,
  );

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder removedItemBuilder;
  final List<T> _items;

  AnimatedListState? get _animatedListState => listKey.currentState;

  void insert(int index, T item) {
    _items.insert(index, item);
    _animatedListState!.insertItem(index);
  }

  T removeAt(int index) {
    final T removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedListState!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(index, context, animation);
        },
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  T operator [](int index) => _items[index];

  int indexOf(T item) => _items.indexOf(item);
}
