import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xayn_architecture_example/app/managers/result_card_manager.dart';
import 'package:xayn_architecture_example/app/widgets/result_card_body.dart';
import 'package:xayn_architecture_example/dependency_config.dart';
import 'package:xayn_architecture_example/domain/states/result_card_state.dart';

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
  late final ResultCardManager _readabilityManager;
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();

    _readabilityManager = di.get();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();

    _readabilityManager.close();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _pageIndex = 0;
    _readabilityManager.updateUri(widget.url);
    _readabilityManager.updateImageUri(Uri.parse(widget.imageUrl));
  }

  @override
  void didUpdateWidget(ResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      _readabilityManager.updateUri(widget.url);
    }

    if (oldWidget.imageUrl != widget.imageUrl) {
      _readabilityManager.updateImageUri(Uri.parse(widget.imageUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultCardManager, ResultCardState>(
        bloc: _readabilityManager,
        builder: (context, state) {
          final imageCollection = [widget.imageUrl, ...state.images];
          final imageIndex = imageCollection.length ~/
              (state.paragraphs.length + 1) *
              _pageIndex;
          final imageUrl = imageCollection[imageIndex];

          return LayoutBuilder(builder: (context, constraints) {
            return GestureDetector(
              onTapUp: (details) {
                setState(() {
                  if (details.localPosition.dx <= constraints.maxWidth / 2) {
                    if (_pageIndex > 0) _pageIndex--;
                  } else {
                    if (_pageIndex < state.paragraphs.length) _pageIndex++;
                  }
                });

                _pageController.animateToPage(
                  _pageIndex,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.network(
                      imageUrl,
                      frameBuilder: (BuildContext context, Widget child,
                          int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }

                        return AnimatedOpacity(
                          child: child,
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                        );
                      },
                      fit: BoxFit.cover,
                      errorBuilder: (context, e, s) => Container(),
                    )),
                    PageView(
                      controller: _pageController,
                      children: [
                        ResultCardPrimaryBody(
                          palette: state.paletteGenerator,
                          title: widget.title,
                          snippet: widget.snippet,
                        ),
                        ...state.paragraphs.map((it) => ResultCardSecondaryBody(
                              palette: state.paletteGenerator,
                              html: it,
                              onLink: (url) async {
                                _readabilityManager.updateUri(Uri.parse(url));

                                return true;
                              },
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
