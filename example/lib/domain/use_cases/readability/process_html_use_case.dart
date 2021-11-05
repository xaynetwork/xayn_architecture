import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;
import 'package:injectable/injectable.dart';
import 'package:xayn_architecture/xayn_architecture.dart';
import 'package:xayn_readability/xayn_readability.dart';

@injectable
class ProcessHtmlUseCase<T>
    extends UseCase<ProcessHtmlResult, WebsiteParagraphs> {
  ProcessHtmlUseCase();

  @override
  Stream<WebsiteParagraphs> transaction(ProcessHtmlResult param) async* {
    final html = param.contents;

    yield WebsiteParagraphs(
        processHtmlResult: param,
        paragraphs:
            html == null ? const [] : await compute(_processHtml, html));
  }
}

List<String> _processHtml(final String html) {
  final document = dom.Document.html(html);
  final paragraphs = document.querySelectorAll('p');

  return paragraphs
      .map((it) => it.text.trim())
      .where((it) => it.length >= 20)
      .toList(growable: false);
}

class WebsiteParagraphs {
  final ProcessHtmlResult processHtmlResult;
  final List<String> paragraphs;

  const WebsiteParagraphs({
    required this.processHtmlResult,
    required this.paragraphs,
  });
}
