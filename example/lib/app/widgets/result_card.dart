import 'package:flutter/material.dart';
import 'package:xayn_architecture_example/app/constants/r.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    Key? key,
    required this.title,
    required this.snippet,
    required this.imageUrl,
  }) : super(key: key);

  final String title;
  final String snippet;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
      style: R.styles.appScreenHeadline?.copyWith(
        color: R.colors.brightText,
      ),
    );

    final spacing = SizedBox(
      height: R.dimen.unit6,
    );

    final snippetWidget = Text(
      snippet,
      style: R.styles.appBodyText?.copyWith(
        color: R.colors.brightText,
      ),
    );

    final container = Container(
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

    final image = Positioned.fill(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, e, s) => Container(),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: [
          image,
          container,
        ],
      ),
    );
  }
}
