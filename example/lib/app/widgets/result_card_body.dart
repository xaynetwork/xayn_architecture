import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:xayn_architecture_example/app/constants/r.dart';
import 'package:xayn_readability/xayn_readability.dart';

typedef OnLink = Future<bool> Function(String)?;

class _ResultCardBody extends StatelessWidget {
  final PaletteGenerator? palette;

  Color? get dominantColor => palette?.colors.first;

  Color get textColor => (dominantColor?.computeLuminance() ?? .0) <= .5
      ? const Color(0xFFF8F8F8)
      : const Color(0xFF303030);

  const _ResultCardBody({
    Key? key,
    this.palette,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  Widget _buildWithBackground(Color? color, Widget child) => Container(
        color: color,
        padding: EdgeInsets.all(R.dimen.unit2),
        child: child,
      );
}

class ResultCardPrimaryBody extends _ResultCardBody {
  final String title;
  final String snippet;

  const ResultCardPrimaryBody({
    Key? key,
    required this.title,
    required this.snippet,
    PaletteGenerator? palette,
  }) : super(key: key, palette: palette);

  @override
  Widget build(BuildContext context) {
    final titleWidget = _buildWithBackground(
        dominantColor?.withAlpha(0xc0),
        Text(
          title,
          style: R.styles.appScreenHeadline?.copyWith(
            color: textColor,
          ),
        ));

    final spacing = SizedBox(
      height: R.dimen.unit6,
    );

    final snippetWidget = _buildWithBackground(
      dominantColor?.withAlpha(0xc0),
      Text(
        snippet,
        style: R.styles.appBodyText?.copyWith(
          color: textColor,
        ),
      ),
    );

    return Container(
      color: R.colors.overlayBackground,
      alignment: AlignmentDirectional.bottomCenter,
      padding: EdgeInsets.only(
        left: R.dimen.unit3,
        right: R.dimen.unit3,
        bottom: R.dimen.unit8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget,
          spacing,
          snippetWidget,
        ],
      ),
    );
  }
}

class ResultCardSecondaryBody extends _ResultCardBody {
  final String html;
  final OnLink? onLink;

  const ResultCardSecondaryBody({
    Key? key,
    required this.html,
    PaletteGenerator? palette,
    this.onLink,
  }) : super(key: key, palette: palette);

  @override
  Widget build(BuildContext context) {
    final htmlWidget = SingleChildScrollView(
      child: _buildWithBackground(
        dominantColor?.withAlpha(0xc0),
        HtmlWidget(
          html,
          textStyle:
              R.styles.appBodyText?.copyWith(color: textColor, fontSize: 18),
          onTapUrl: onLink,
        ),
      ),
    );

    return Container(
      color: R.colors.overlayBackground,
      alignment: AlignmentDirectional.bottomCenter,
      padding: EdgeInsets.only(
        left: R.dimen.unit3,
        right: R.dimen.unit3,
        top: R.dimen.unit8,
        bottom: R.dimen.unit8,
      ),
      child: htmlWidget,
    );
  }
}
