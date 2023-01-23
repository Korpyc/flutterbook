// TODO: remove it
/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../editor/editor.dart';
import '../navigation/models/organizers.dart';
import '../navigation/navigation.dart';
import 'story_provider.dart';

ModalRoute<void> generateRoute(
  BuildContext context,
  String? name, {
  RouteSettings? settings,
}) {
  ChangeNotifierProvider<StoryProvider> builder(context) {
    return ChangeNotifierProvider<StoryProvider>(
      create: (context) {
        final provider = StoryProvider.fromPath(name,
            recursiveRetrievalOfStates(context.read<List<BookCategory>>()));
        context.read<CanvasDelegateProvider>().storyProvider = provider;
        return provider;
      },
      child: Builder(
        builder: (context) => const Editor(component: Story()),
      ),
    );
  }

  return StoryRoute(settings: settings, builder: builder);
}

class StoryRoute extends PopupRoute<void> {
  StoryRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      builder(context);

  @override
  Duration get transitionDuration => const Duration();
}

List<ComponentState> recursiveRetrievalOfStates(List<Organizer> organizers) {
  final List<ComponentState> states = [];
  for (final Organizer current in organizers) {
    if (current is Component) {
      states.addAll(current.states);
    } else {
      states.addAll(recursiveRetrievalOfStates(current.organizers));
    }
  }
  return states;
}
 */

import 'package:flutter/material.dart';
import 'package:flutterbook/src/navigation/models/organizers.dart';
import 'package:go_router/go_router.dart';
import 'package:recase/recase.dart';

class RouterUtil {
  RouterUtil._();

  static List<RouteBase> createRoutes(
    List<BookOrganizer> pages,
  ) {
    assert(pages.isNotEmpty);

    List<RouteBase> routes = [];

    final List<BookOrganizer> nodes = List.from(pages);
    while (nodes.isNotEmpty) {
      final node = nodes.removeAt(0);
      routes.add(
        _createRoute(node, isTop: true),
      );
    }

    return routes;
  }

  static GoRoute _createRoute(
    BookOrganizer organizer, {
    bool isTop = false,
  }) {
    var routePath = (isTop ? '/' : '') + ReCase(organizer.name).snakeCase;
    switch (organizer.type) {
      case OrganizerType.categoty:
      case OrganizerType.folder:
        {
          var routes = organizer.organizers
              .map(
                (element) => _createRoute(element),
              )
              .toList();

          return GoRoute(
            path: routePath,
            // shouldn't be here, but without will throw en error
            builder: (context, state) => Container(),
            redirect: (context, state) {
              if (state.fullpath != null &&
                  state.fullpath!.endsWith(ReCase(organizer.name).snakeCase)) {
                var childPath = _findPagePathInTree(organizer.organizers.first);
                if (childPath != null) {
                  return state.location + childPath;
                }
              }
              return null;
            },
            routes: routes,
          );
        }
      case OrganizerType.page:
        {
          var page = (organizer as BookPage).page;
          return GoRoute(
            path: routePath,
            builder: (context, state) => page,
          );
        }
    }
  }

  static String? _findPagePathInTree(BookOrganizer organizer) {
    var currentLevelPath = '/' + ReCase(organizer.name).snakeCase;
    if (organizer.type == OrganizerType.page) {
      return currentLevelPath;
    }
    if (organizer.organizers.isNotEmpty) {
      var childPath = _findPagePathInTree(organizer.organizers.first);
      if (childPath != null) {
        return currentLevelPath + childPath;
      }
    }
    return null;
  }
}
