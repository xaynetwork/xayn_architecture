import 'package:flutter/material.dart';
import 'package:xayn_architecture_example/app/constants/r.dart';
import 'package:xayn_architecture_example/domain/entities/document.dart';

class ResultCard extends StatelessWidget {
  final Document document;

  const ResultCard({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = Text(
      document.webResource.title,
      style: R.styles.appScreenHeadline?.copyWith(
        color: R.colors.brightText,
      ),
    );

    final spacing = SizedBox(
      height: R.dimen.unit6,
    );

    final snippet = Text(
      document.webResource.snippet,
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
          title,
          spacing,
          snippet,
        ],
      ),
    );

    final image = Positioned.fill(
      child: Image.network(
        document.webResource.displayUrl.toString(),
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
