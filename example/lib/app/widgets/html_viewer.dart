import 'package:flutter/widgets.dart';
import 'package:xayn_architecture_example/app/constants/r.dart';
import 'package:xayn_readability/xayn_readability.dart';

const String kUserAgent =
    'Mozilla/5.0 (Linux; Android 8.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36';
const List<String> kClassesToPreserve = [
  'caption',
  'emoji',
  'hidden',
  'invisible',
  'sr-only',
  'visually-hidden',
  'visuallyhidden',
  'wp-caption',
  'wp-caption-text',
  'wp-smiley'
];

class HtmlViewer extends StatefulWidget {
  final Uri uri;

  const HtmlViewer({
    Key? key,
    required this.uri,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HtmlViewerState();
}

class _HtmlViewerState extends State<HtmlViewer> {
  late final ReaderModeController controller;

  @override
  void initState() {
    controller = ReaderModeController()..loadUri(widget.uri);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReaderMode(
      classesToPreserve: kClassesToPreserve,
      userAgent: kUserAgent,
      controller: controller,
      textStyle: R.styles.appBodyText?.copyWith(
        color: R.colors.brightText,
        fontSize: R.dimen.unit2,
      ),
    );
  }
}
