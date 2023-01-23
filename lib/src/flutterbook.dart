import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutterbook/src/editor/providers/device_preview_provider.dart';
import 'package:flutterbook/src/editor/providers/pan_provider.dart';
import 'package:flutterbook/src/editor/providers/tab_provider.dart';
import 'package:flutterbook/src/utils/flutter_book_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'editor/editor.dart';
import 'navigation/navigation.dart';
import 'routing/router.dart';
import 'styled_widgets/styled_widgets.dart';
import 'theme_provider.dart';
import 'utils/utils.dart';

class FlutterBook extends StatefulWidget {
  /// Categories that can contain folders or components that can display states.
  /// States will have widgets which you may click on and display the widget in
  /// the editor.
  final List<BookOrganizer> pages;

  /// The `ThemeData` that is defaulted when the project is opened. This should
  /// be considered as the light theme.
  final ThemeData? theme;

  /// The `ThemeData` used when the dark theme is enabled.
  final ThemeData? darkTheme;

  /// Material app title property
  final String title;

  /// The branding/header of the project. This is displayed on the top left of the
  /// flutterbook.
  final Widget? header;

  /// The padding for the branding/header of the project.
  final EdgeInsetsGeometry headerPadding;

  /// Custom theme for the code sample shown on component state documentation.
  final CodeSampleThemeData? codeSampleTheme;

  /// This is used for projects that have more than two themes, if it is defined
  /// and not empty, then the `theme` and `darkTheme` will be ignored and a
  /// dropdown will appear in the editor tabs.
  final List<FlutterBookTheme>? themes;

  const FlutterBook({
    Key? key,
    required this.pages,
    this.title = 'FlutterBook',
    this.theme,
    this.darkTheme,
    this.codeSampleTheme,
    this.header,
    this.headerPadding = const EdgeInsets.fromLTRB(20, 16, 20, 8),
    this.themes,
  })  : assert(themes?.length != 0),
        assert(pages.length != 0),
        super(key: key);

  @override
  _FlutterBookState createState() => _FlutterBookState();
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class _FlutterBookState extends State<FlutterBook> {
  bool get useMultiTheme => widget.themes != null && widget.themes!.length > 1;
  List<String> get themeNames =>
      widget.themes?.map((theme) => theme.themeName).toList() ?? [];

  late final GoRouter _goRouter;

  @override
  void initState() {
    if (widget.darkTheme != null) Styles.darkTheme = widget.darkTheme!;
    if (widget.theme != null) Styles.lightTheme = widget.theme!;

    if (foundation.kIsWeb) usePathUrlStrategy();

    _goRouter = _createRouter();

    super.initState();
  }

  _createRouter() {
    var routes = RouterUtil.createRoutes(widget.pages);
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (context, state) => Container(),
          redirect: (context, state) => '/library',
        ),

        /// Application shell
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return ScaffoldWithNavPanel(
              navPanel: NavigationPanel(
                header: widget.header,
                //headerPadding: widget.headerPadding,
                pages: widget.pages,
                /* onComponentSelected: (child) {
                        navigator.currentState!
                            .pushReplacementNamed('/${child?.path ?? ''}');
                        /*  context
                            .read<CanvasDelegateProvider>()
                            .storyProvider!
                            .updateStory(child); */
                      }, */
              ),
              child: child,
            );
          },
          routes: routes,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider.value(value: widget.pages),
        // ChangeNotifierProvider(create: (_) => CanvasDelegateProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            useListOfThemes: useMultiTheme,
            themeNames: themeNames,
          ),
        ),
        ChangeNotifierProvider(create: (_) => DevicePreviewProvider()),
        ChangeNotifierProvider(create: (_) => GridProvider()),
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => ZoomProvider()),
        ChangeNotifierProvider(create: (_) => PanProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, model, Widget? child) {
          ThemeData activeTheme = useMultiTheme
              ? widget.themes![model.activeThemeIndex].theme
              : widget.theme ?? Styles().theme;

          return MaterialApp.router(
            title: widget.title,
            debugShowCheckedModeBanner: false,
            theme: activeTheme,
            routerConfig: _goRouter,
            /* builder: (context, child) {
              return ScaffoldWithNavPanel(
                navPanel: NavigationPanel(
                  header: widget.header,
                  headerPadding: widget.headerPadding,
                  pages: widget.pages,
                  /* onComponentSelected: (child) {
                        navigator.currentState!
                            .pushReplacementNamed('/${child?.path ?? ''}');
                        /*  context
                            .read<CanvasDelegateProvider>()
                            .storyProvider!
                            .updateStory(child); */
                      }, */
                ),
                child: child,
              );
            }, */
          );
        },
      ),
    );
  }
}
