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
  builder: (args) => Page(
    argument: args,
  ),
  arguments: "page1",
);
final page2 = page1.copyWith(arguments: "page2");
final page3 = page1.copyWith(arguments: "page3");

class AppNavigation extends xayn.NavigatorManager {
  AppNavigation(List<PageData> initialPages) : super(initialPages);
}

void main() {
  test('No initial page provided causes an error.', () {
    expect(() => AppNavigation([]),
        throwsA(const TypeMatcher<xayn.NavigatorException>()));
  });

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Initial page is shown when providing a page..',
    build: () => AppNavigation([page1]),
    verify: (AppNavigation manager) {
      expect(manager.state, xayn.NavigatorState(pages: [page1]));
    },
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'With only one page pop will be not handled anymore (which should cause the app to close)',
    build: () => AppNavigation([page1]),
    verify: (m) async {
      expect(await m.popRoute(), false);
    },
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'With more than one page pop will be handled.',
    build: () => AppNavigation([page1, page2]),
    verify: (m) async {
      expect(await m.popRoute(), true);
    },
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Adding a new page the page shows up on the end of the page list.',
    build: () => AppNavigation([page1]),
    act: (m) => m.push(page2),
    expect: () => [
      equals(xayn.NavigatorState(pages: [
        page1,
        page2,
      ]))
    ],
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Removing a page will emit a state with one page less.',
    build: () => AppNavigation([page1, page2]),
    act: (m) => m.pop(),
    expect: () => [
      equals(xayn.NavigatorState(pages: [
        page1,
      ]))
    ],
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Doing a back action is similar to the pop() method, which removes a page.',
    build: () => AppNavigation([page1, page2]),
    act: (m) => m.popRoute(),
    expect: () => [
      equals(xayn.NavigatorState(pages: [
        page1,
      ]))
    ],
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Requesting a result from a page will deliver this result when provided.',
    build: () => AppNavigation([page1]),
    verify: (m) async {
      final result = m.pushForResult(page2);
      m.pop("test result");
      expect(await result, "test result");
      expect(m.state.pages, [page1]);
    },
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Requesting a result from a page will deliver null when popped without a result.',
    build: () => AppNavigation([page1]),
    verify: (m) async {
      final result = m.pushForResult(page2);
      m.popRoute();
      expect(await result, null);
      expect(m.state.pages, [page1]);
    },
  );

  blocTest<AppNavigation, xayn.NavigatorState>(
    'Replace last page is possible when using the stack manipulation.',
    build: () => AppNavigation([page1]),
    act: (m) async {
      m.replace(page2);
    },
    expect: () => [
      equals(xayn.NavigatorState(pages: [
        page2,
      ]))
    ],
  );
}
