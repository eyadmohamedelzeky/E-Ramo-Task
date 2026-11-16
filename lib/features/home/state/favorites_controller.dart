import 'package:flutter/widgets.dart';

/// In-memory favourites shared by the feed cards and the bottom sheets.
class FavoritesController extends ChangeNotifier {
  FavoritesController({Iterable<String> initial = const []})
    : _ids = {...initial};

  final Set<String> _ids;

  bool isFavorite(String id) => _ids.contains(id);

  int get count => _ids.length;

  void toggle(String id) {
    if (!_ids.remove(id)) _ids.add(id);
    notifyListeners();
  }
}

/// Exposes a [FavoritesController] to the widget tree (including modal
/// routes, because it is installed above the app's navigator).
class FavoritesScope extends InheritedNotifier<FavoritesController> {
  const FavoritesScope({
    super.key,
    required FavoritesController controller,
    required super.child,
  }) : super(notifier: controller);

  static FavoritesController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FavoritesScope>();
    assert(scope != null, 'No FavoritesScope found in context');
    return scope!.notifier!;
  }
}
