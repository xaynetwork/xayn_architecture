import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
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
  name: "",
  builder: (_, args) => Page(
    argument: args!,
  ),
  arguments: "page1",
  isInitial: true,
);
final page2 = page1.copyWith(arguments: "page2", isInitial: false);
final page3 = page1.copyWith(arguments: "page3", isInitial: false);

class AppNavigation extends xayn.NavigatorManager {
  AppNavigation(Set<UntypedPageData> pages, {List<UntypedPageData>? initials})
      : super(pages: pages, initialPageConfiguration: initials);
}

void main() {
  test('No initial page provided causes an error.', () {
    expect(() => AppNavigation({}),
        throwsA(const TypeMatcher<xayn.NavigatorException>()));
  });

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Initial page is shown when providing a page..',
    build: () => AppNavigation({page1}),
    verify: (AppNavigation manager) {
      expect(manager.state,
          xayn.NavigatorState(pages: [page1], source: xayn.Source.navigator));
    },
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Adding a new page the page shows up on the end of the page list.',
    build: () => AppNavigation({page1}),
    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    act: (m) => m.manipulateStack((stack) => stack.push(page2)),
    expect: () => [
      equals(xayn.NavigatorState(
        pages: [
          page1,
          page2,
        ],
        source: xayn.Source.navigator,
      ))
    ],
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Removing a page will emit a state with one page less.',
    build: () => AppNavigation({page1, page2}, initials: [page1, page2]),
    // ignore: INVALID_USE_OF_PROTECTED_MEMBER
    act: (m) => m.pop(),
    expect: () => [
      equals(xayn.NavigatorState(
        pages: [
          page1,
        ],
        source: xayn.Source.navigator,
      ))
    ],
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Requesting a result from a page will deliver this result when provided.',
    build: () => AppNavigation({page1}),
    verify: (m) async {
      // ignore: INVALID_USE_OF_PROTECTED_MEMBER
      final result = m.manipulateStack((stack) => stack.pushForResult(page2));
      // ignore: INVALID_USE_OF_PROTECTED_MEMBER
      m.pop("test result");
      expect(await result, "test result");
      expect(m.state.pages, [page1]);
    },
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Requesting a result from a page will deliver null when popped without a result.',
    build: () => AppNavigation({page1}),
    verify: (m) async {
      // ignore: INVALID_USE_OF_PROTECTED_MEMBER
      final result = m.manipulateStack((stack) => stack.pushForResult(page2));
      // ignore: INVALID_USE_OF_PROTECTED_MEMBER
      m.pop();
      expect(await result, null);
      expect(m.state.pages, [page1]);
    },
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Replace last page is possible when using the stack manipulation.',
    build: () => AppNavigation({page1}),
    act: (m) async {
      // ignore: INVALID_USE_OF_PROTECTED_MEMBER
      m.manipulateStack((stack) => stack.replace(page2));
    },
    expect: () => [
      equals(xayn.NavigatorState(
        pages: [
          page2,
        ],
        source: xayn.Source.navigator,
      ))
    ],
  );
}
