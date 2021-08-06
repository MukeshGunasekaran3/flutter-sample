import 'package:flutter/material.dart';
import 'package:onemoney_sdk/utils/size_utils/screen_util.dart';

class SizeUtilInit extends StatelessWidget {
  /// A helper widget that initializes [ScreenUtil]
  SizeUtilInit({
    required this.builder,
    this.designSize = SizeUtil.defaultSize,
    Key? key,
  }) : super(key: key);

  final Widget Function() builder;

  /// The [Size] of the device in the design draft, in dp
  final Size designSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      return OrientationBuilder(
        builder: (_, Orientation orientation) {
          if (constraints.maxWidth != 0) {
            SizeUtil.init(
              constraints,
              orientation: orientation,
              designSize: designSize,
            );
            return builder();
          }
          return Container();
        },
      );
    });
  }
}
