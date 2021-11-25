import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_data.freezed.dart';

typedef PageBuilder<T extends Widget> = T Function(dynamic arguments);

@freezed
class PageData<T extends Widget> with _$PageData<T> {
  const PageData._();

  factory PageData({
    required String name,
    @Default(false) bool isInitial,
    required PageBuilder<T> builder,
    Completer? pendingResult,
    dynamic? arguments,
  }) = _PageData;
}
