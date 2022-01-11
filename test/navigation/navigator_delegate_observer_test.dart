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

class CountObserver extends xayn.NavigatorDelegateObserver {
  int calledDidPop = 0;
  int calledDidPush = 0;
  int calledDidReplace = 0;

  @override
  void didPop(BuildContext context) => calledDidPop++;

  @override
  void didPush(BuildContext context) => calledDidPush++;

  @override
  void didReplace(BuildContext context) => calledDidReplace++;

  void reset() {
    calledDidReplace = calledDidPush = calledDidPop = 0;
  }
}

class App extends StatelessWidget {
  final AppNavigation appNavigation;
  final CountObserver observer;

  const App({Key? key, required this.appNavigation, required this.observer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: appNavigation.routeInformationParser,
      routerDelegate:
          xayn.NavigatorDelegate(appNavigation, observers: [observer]),
    );
  }
}

void main() {
  testWidgets('Should register a push when starting up the app.',
      (tester) async {
    final observer = CountObserver();
    await tester.pumpWidget(App(
      appNavigation: AppNavigation({page1, page2, page3}),
      observer: observer,
    ));

    expect(observer.calledDidPush, 1);
    expect(observer.calledDidPop, 0);
    expect(observer.calledDidReplace, 0);
  });

  testWidgets('Should register a pop when popping the top page.',
      (tester) async {
    final observer = CountObserver();
    final navigation = AppNavigation(
      {page1, page2, page3},
      initials: [page1, page2],
    );
    await tester.pumpWidget(App(
      appNavigation: navigation,
      observer: observer,
    ));
    observer.reset();

    // ignore: invalid_use_of_protected_member
    navigation.manipulateStack((stack) => stack.pop());

    /// Since we are updating the observer asynchronous we need
    /// to wait until that micro task settles.
    await tester.pumpAndSettle();

    expect(observer.calledDidPush, 0);
    expect(observer.calledDidPop, 1);
    expect(observer.calledDidReplace, 0);
  });

  testWidgets('Should register a replace if the top page was replaced.',
      (tester) async {
    final observer = CountObserver();
    final navigation = AppNavigation(
      {page1, page2, page3},
      initials: [page1, page2],
    );
    await tester.pumpWidget(App(
      appNavigation: navigation,
      observer: observer,
    ));
    observer.reset();

    // ignore: invalid_use_of_protected_member
    navigation.manipulateStack((stack) => stack.replace(page3));

    /// Since we are updating the observer asynchronous we need
    /// to wait until that micro task settles.
    await tester.pumpAndSettle();

    expect(observer.calledDidPush, 0);
    expect(observer.calledDidPop, 0);
    expect(observer.calledDidReplace, 1);
  });
}
