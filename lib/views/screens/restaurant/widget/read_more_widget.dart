import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxLines;

  ReadMoreText(this.text, {this.maxLines = 4});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraints) {
            var textSpan = TextSpan(
              text: widget.text,
              style: DefaultTextStyle.of(context).style,
            );

            var textPainter = TextPainter(
              text: textSpan,
              maxLines: widget.maxLines,
              textDirection: TextDirection.ltr,
            );

            textPainter.layout(maxWidth: constraints.maxWidth);

            if (textPainter.didExceedMaxLines) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    maxLines: isExpanded ? null : widget.maxLines,
                    //   overflow: TextOverflow.ellipsis,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'Read Less' : 'Read More',
                      style: const TextStyle(
                        color: AppColor.p200,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Text(
                widget.text,
                maxLines: widget.maxLines,
                overflow: TextOverflow.ellipsis,
              );
            }
          },
        ),
      ],
    );
  }
}
