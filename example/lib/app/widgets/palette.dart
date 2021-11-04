import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/widgets.dart' hide Image;

typedef Builder = Widget Function(
    ImageProvider image, PaletteGenerator? palette);

class Palette extends StatefulWidget {
  const Palette({
    Key? key,
    required this.imageProvider,
    required this.builder,
  }) : super(key: key);

  final ImageProvider imageProvider;
  final Builder builder;

  @override
  State<Palette> createState() => _PaletteState();
}

class _PaletteState extends State<Palette> {
  PaletteGenerator? _palette;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _updateImage();
  }

  @override
  void didUpdateWidget(Palette oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.imageProvider != oldWidget.imageProvider) {
      _updateImage();
    }
  }

  Future<void> _updateImage() async {
    // todo: this will load the image, we should avoid double loading as the image
    // will also be displayed via ui.Image later on
    final palette =
        await PaletteGenerator.fromImageProvider(widget.imageProvider);

    if (mounted) {
      setState(() {
        _palette = palette;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.imageProvider, _palette);
  }
}
