import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';
import 'package:xayn_architecture/concepts/navigation/page_data.dart';

void main() {
  test('Two PageDatas with equal but not same  builders are not the same.', () {
    var page1 = PageData(name: "", builder: (args) => const Text('page1'));
    var page2 = PageData(name: "", builder: (args) => const Text('page1'));
    expect(page1, isNot(page2));
  });

  test('Two PageDatas with same builders are the same.', () {
    // ignore: prefer_function_declarations_over_variables
    final builder = (args) => const Text('page1');
    var page1 = PageData(name: "", builder: builder);
    var page2 = PageData(name: "", builder: builder);
    expect(page1, equals(page2));
  });

  test('Two PageDatas with same arguments are the same.', () {
    // ignore: prefer_function_declarations_over_variables
    final builder = (args) => const Text('page1');
    var page1 = PageData(name: "", builder: builder, arguments: "args");
    var page2 = PageData(name: "", builder: builder, arguments: "args");
    expect(page1, equals(page2));
  });

  test('Two PageDatas with different arguments are not equal.', () {
    // ignore: prefer_function_declarations_over_variables
    final builder = (args) => const Text('page1');
    var page1 = PageData(name: "", builder: builder, arguments: "args1");
    var page2 = PageData(name: "", builder: builder, arguments: "args2");
    expect(page1, isNot(page2));
  });
}
