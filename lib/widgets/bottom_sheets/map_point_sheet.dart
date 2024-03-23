import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/mapbox/mapbox_directions/mapbox_directions.dart';
import 'package:scavenger_hunt/services/direction_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class MapPointSheet extends StatefulWidget {
  final LatLng source;
  final LatLng dest;
  const MapPointSheet({super.key, required this.source, required this.dest});

  @override
  State<MapPointSheet> createState() => _MapPointSheetState();
}

class _MapPointSheetState extends State<MapPointSheet> {
  late DirectionService directionService;
  late LatLng source;
  late LatLng dest;
  bool isLoading = false;

  @override
  initState() {
    directionService = DirectionService();
    source = widget.source;
    dest = widget.dest;
    super.initState();
  }

  _getNavigationData() async {
    setState(() {
      isLoading = true;
    });
    BaseResponse directionsResponse =
        await DirectionService().getDirections(source, dest);
    if (directionsResponse.error == null) {
      MapBoxDirection directions =
          directionsResponse.snapshot as MapBoxDirection;
      if (mounted) {
        Navigator.of(context).pop(directions);
      }
    } else {
      // ToastUtils.showSnackBar(
      //     context, "Could not get navigations at this moment", "fail");
    }
  }

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
            child: CustomRoundedButton("", () => _getNavigationData(),
                widgetButton: isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: ColorStyle.whiteColor,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Start",
                        style: TextStyle(
                            height: 1.2,
                            fontSize: 16,
                            color: ColorStyle.whiteColor,
                            fontWeight: FontWeight.w500),
                      )),
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
