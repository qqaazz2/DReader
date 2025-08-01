import 'package:DReader/widgets/SettingsBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/routes/book/BookRead.dart';
import 'package:DReader/routes/book/SeriesConent.dart';
import 'package:DReader/routes/book/SeriesPage.dart';
import 'package:DReader/routes/HomePage.dart';
import 'package:DReader/routes/LoginPage.dart';
import 'package:DReader/state/ThemeState.dart';
import 'package:DReader/widgets/LeftDrawer.dart';
import 'package:DReader/widgets/SetBaseUrl.dart';
import 'package:DReader/widgets/TopTool.dart';
import 'common/Global.dart';
import 'common/HttpApi.dart';
import 'entity/BaseResult.dart';
import 'entity/UserInfo.dart';

void main() =>
    Global.init().then((value) => runApp(ProviderScope(child: MyApp())));
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerStatefulWidget {
  MyApp({super.key});

  static double width = 600;
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  static Widget? drawer;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late GoRouter router;
  final _sectionNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      navigatorKey: MyApp.rootNavigatorKey,
      initialLocation: "/home",
      routes: [
        GoRoute(
            path: "/login",
            name: "login",
            builder: (context, state) => const LoginPage()),
        StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MainApp(
                navigationShell: navigationShell,
              );
            },
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                    path: "/home",
                    name: "home",
                    builder: (context, state) => const HomePage()),
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                    path: "/books",
                    name: "books",
                    builder: (context, state) => const SeriesPage(),
                    routes: <RouteBase>[
                      GoRoute(
                          path: "content",
                          name: "booksContent",
                          builder: (context, state) {
                            int seriesId = int.parse(
                                state.uri.queryParameters["seriesId"]!);
                            int filesId = int.parse(
                                state.uri.queryParameters["filesId"]!);
                            int index =
                                int.parse(state.uri.queryParameters["index"]!);
                            return SeriesContent(
                                seriesId: seriesId,
                                filesId: filesId,
                                index: index);
                          }),
                      GoRoute(
                          path: "read",
                          name: "booksRead",
                          builder: (context, state) {
                            int seriesId = int.parse(
                                state.uri.queryParameters["seriesId"]!);
                            BookItem bookItem = state.extra as BookItem;
                            return BookRead(
                              bookItem: bookItem,
                              seriesId: seriesId,
                            );
                          })
                    ]),
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                    path: "/logs",
                    name: "logs",
                    builder: (context, state) => const HomePage()),
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                    path: "/setting",
                    name: "setting",
                    builder: (context, state) => const HomePage()),
              ]),
            ]),
      ],
      redirect: (context, state) {
        if (Global.token.isEmpty || Global.setting.serverConfig.baseUrl.isEmpty)
          return '/login';
        return null;
      },
    );
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bright = ref.watch(themeStateProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'DReader',
      themeMode: bright.light ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          shadowColor: Colors.white54,
          cardColor: Colors.black),
      builder: EasyLoading.init(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<StatefulWidget> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  bool extended = false;

  @override
  void initState() {
    super.initState();
    HttpApi.request("/user/info", (json) => UserInfo.fromJson(json))
        .then((baseResult) {
      Global.setting.userInfo = baseResult.result;
    });
  }

  @override
  Widget build(BuildContext context) {
      return LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < MyApp.width) {
          return widget.navigationShell;
        } else {
          return Scaffold(
            key: MyApp.scaffoldKey,
            endDrawer: MyApp.drawer,
            body: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: NavigationRail(
                  destinations: Global.itemList
                      .map((e) => NavigationRailDestination(
                          icon: e.icon, label: Text(e.title)))
                      .toList(),
                  selectedIndex: widget.navigationShell.currentIndex,
                  trailing: IconButton(
                      icon: Icon(
                          extended ? Icons.arrow_back : Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          extended = !extended;
                        });
                      }),
                  extended: extended,
                  onDestinationSelected: (int index) {
                    if (widget.navigationShell.currentIndex == index) return;
                    widget.navigationShell.goBranch(index);
                  },
                )),
                const SettingsBar(),
              ]),
              Expanded(child: widget.navigationShell)
            ]),
          );
        }
      });
  }
}
