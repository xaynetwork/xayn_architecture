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
  name: "page1",
  builder: (args) => Page(
    argument: args!,
  ),
  arguments: "someArgs1",
  isInitial: true,
);
final page2 =
    page1.copyWith(name: "page2", arguments: "someArgs2", isInitial: false);
final page3 =
    page1.copyWith(name: "page3", arguments: "someArgs3", isInitial: false);

class AppNavigation extends xayn.NavigatorManager {
  AppNavigation(Set<UntypedPageData> pages, {List<UntypedPageData>? initials})
      : super(pages: pages, initialPageConfiguration: initials);
}

xayn.NavigatorRouteInformationParser parser({
  List<UntypedPageData>? pages,
  List<UntypedPageData>? initial,
}) =>
    xayn.NavigatorRouteInformationParser(
        AppNavigation({page1, page2, page3}, initials: null));

xayn.NavigatorState state(List<UntypedPageData> pages) =>
    xayn.NavigatorState(pages: pages);

void main() {
  test('Initial page should be generated with the "/" location', () async {
    expect(
      await parser()
          .parseRouteInformation(const RouteInformation(location: '/')),
      state([page1]),
    );
  });

  test(
      '"/page1/page2/page3" should correspond to page1, page2, page3 in the state',
      () async {
    expect(
      await parser().parseRouteInformation(
          const RouteInformation(location: '/page1/page2/page3')),
      state([page1, page2, page3]),
    );
  });

  test('"/page2/page3" should add the initial page that corresponds to "/"',
      () async {
    expect(
      await parser().parseRouteInformation(
          const RouteInformation(location: '/page2/page3')),
      state([page1, page2, page3]),
    );
  });
}
