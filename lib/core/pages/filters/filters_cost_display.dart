import 'package:dedal/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class FiltersCostDisplay extends StatelessWidget {
  const FiltersCostDisplay({
    super.key,
    required this.cost,
    required this.onChange,
  });

  final double cost;
  final void Function(double value) onChange;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text('Séléctionnner votre budget'),
          SleekCircularSlider(
            appearance: CircularSliderAppearance(
                infoProperties: InfoProperties(
                    modifier: (percentage) => '${percentage.round()} \$',
                    mainLabelStyle: const TextStyle(color: Colors.white)),
                customColors: CustomSliderColors(
                    trackColor: SharedColorPalette().mainDisable,
                    progressBarColor: SharedColorPalette().main)),
            initialValue: cost,
            min: 0,
            max: 1000,
            onChange: (value) => onChange(value),
          ),
        ],
      );
}