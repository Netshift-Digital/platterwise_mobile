import 'package:platterwave/utils/size_config/size_config.dart';

extension SizeExtensions on num {
  double get h => SizeConfig.getHeight(this.toDouble());
  double get w => SizeConfig.getWidth(this.toDouble());
  double get sp => SizeConfig.getTextSize(this.toDouble());
}