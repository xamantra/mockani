import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:mockani/src/data/subject.dart';
import 'package:mockani/src/widgets/circular_loading.dart';

class Character extends StatelessWidget {
  const Character({
    super.key,
    required this.item,
    this.size,
  });

  final SubjectData item;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return (item.getCharacterImage != null)
        ? Container(
            height: size ?? 256,
            width: size ?? 256,
            padding: const EdgeInsets.all(36),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: ScalableImageWidget.fromSISource(
                si: ScalableImageSource.fromSvgHttpUrl(
                  Uri.parse(
                    item.getCharacterImage!.url,
                  ),
                  currentColor: Colors.white,
                ),
                onLoading: (_) {
                  return CircularLoading(
                    color: Colors.white,
                    size: size ?? 256,
                  );
                },
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(36),
            child: AutoSizeText(
              item.data.characters,
              maxLines: 1,
              maxFontSize: size != null ? size! / 2 : 128,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: size != null ? size! / 2 : 128,
                fontFamily: "Hiragino",
              ),
            ),
          );
  }
}
