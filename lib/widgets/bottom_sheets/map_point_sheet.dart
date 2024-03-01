import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class MapPointSheet extends StatefulWidget {
  const MapPointSheet({super.key});

  @override
  State<MapPointSheet> createState() => _MapPointSheetState();
}

class _MapPointSheetState extends State<MapPointSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
      decoration: BoxDecoration(
          color: ColorStyle.backgroundColor,
          borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: SvgPicture.asset(
                          "assets/svgs/ic_back.svg",
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      const Text(
                        "Bigfoot",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryTextColor),
                      ),
                    ],
                  ),
                  _buildInfoWidget()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    "assets/pngs/mini_map.png",
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              "assets/pngs/quest_road.png",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomRoundedButton(
              "Start",
              () => (),
              textColor: ColorStyle.whiteColor,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  _buildInfoWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Current points: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: ColorStyle.secondaryTextColor),
              ),
              Text(
                "300",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: ColorStyle.primaryColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                "Time: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.outline100Color),
              ),
              Text(
                "1.30h",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.primaryColor),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Text(
                "Difficulty: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.outline100Color),
              ),
              Text(
                "Medium",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.primaryColor),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Text(
                "Challenges: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.outline100Color),
              ),
              Text(
                "13",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
