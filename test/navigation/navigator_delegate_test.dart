import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xayn_architecture/concepts/navigation/page_data.dart';
import 'package:xayn_architecture/xayn_architecture_navigation.dart' as xayn;

class Page extends StatelessWidget {
  final String argument;

  const Page({Key? key, required this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(argument);
  }
}

final page1 = PageData(
  name: "page1",
  builder: (_, args) => Page(
    key: const Key('page1'),
    argument: args!,
  ),
  arguments: "page1",
  isInitial: true,
);
final page2 = PageData(
  name: "page2",
  builder: (_, args) => Page(
    key: const Key('page2'),
    argument: args!,
  ),
  arguments: "page2",
);
final page3 = PageData(
  name: "page3",
  builder: (_, args) => Page(
    key: const Key('page3'),
    argument: args!,
  ),
  arguments: "page3",
);

class AppNavigation extends xayn.NavigatorManager {
  AppNavigation(Set<UntypedPageData> pages, {List<UntypedPageData>? initials})
      : super(pages: pages, initialPageConfiguration: initials);
}

class App extends StatelessWidget {
  final AppNavigation appNavigation;

  const App({Key? key, required this.appNavigation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: appNavigation.routeInformationParser,
      routerDelegate: xayn.NavigatorDelegate(appNavigation),
    );
  }
}

void main() {
  testWidgets('Should show the initial page.', (tester) async {
    await tester.pumpWidget(App(
      appNavigation: AppNavigation({page1, page2, page3}),
    ));

    expect(find.byKey(const Key('page1')), findsOneWidget);
  });
}
