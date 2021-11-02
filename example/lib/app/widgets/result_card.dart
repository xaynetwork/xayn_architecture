import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:xayn_architecture_example/app/constants/r.dart';
import 'package:xayn_architecture_example/app/widgets/palette.dart';

class ResultCard extends StatefulWidget {
  const ResultCard({
    Key? key,
    required this.title,
    required this.snippet,
    required this.imageUrl,
    required this.url,
  }) : super(key: key);

  final String title;
  final String snippet;
  final String imageUrl;
  final Uri url;

  @override
  State<StatefulWidget> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Palette(
          imageProvider: NetworkImage(widget.imageUrl),
          builder: (image, palette) {
            return Stack(
              children: [
                Positioned.fill(
                    child: Image(
                  image: image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, e, s) => Container(),
                )),
                _buildContainer(palette),
              ],
            );
          }),
    );
  }

  Widget _buildContainer(PaletteGenerator? palette) {
    final dominantColor = palette?.colors.first;
    final textColor = (dominantColor?.computeLuminance() ?? .0) <= .5
        ? const Color(0xFFF8F8F8)
        : const Color(0xFF303030);

    withBackground(Color? color, Widget child) {
      return Container(
        color: color,
        padding: EdgeInsets.all(R.dimen.unit2),
        child: child,
      );
    }

    final titleWidget = withBackground(
        dominantColor?.withAlpha(0xc0),
        Text(
          widget.title,
          style: R.styles.appScreenHeadline?.copyWith(
            color: textColor,
          ),
        ));

    final spacing = SizedBox(
      height: R.dimen.unit6,
    );

    final snippetWidget = withBackground(
      dominantColor?.withAlpha(0xc0),
      Text(
        widget.snippet,
        style: R.styles.appBodyText?.copyWith(
          color: textColor,
        ),
      ),
    );

    return Container(
      color: R.colors.overlayBackground,
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
