import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/generic/generic_response.dart';
import 'package:scavenger_hunt/models/api/mapbox/mapbox_directions/mapbox_directions.dart';
import 'package:scavenger_hunt/services/challenge_service.dart';
import 'package:scavenger_hunt/services/direction_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class MapPointSheet extends StatefulWidget {
  final Challenge challenge;
  final LatLng source;
  final LatLng dest;
  const MapPointSheet(
      {super.key,
      required this.source,
      required this.dest,
      required this.challenge});

  @override
  State<MapPointSheet> createState() => _MapPointSheetState();
}

class _MapPointSheetState extends State<MapPointSheet> {
  late DirectionService directionService;
  late LatLng source;
  late LatLng dest;
  late Challenge challenge;
  bool isLoading = false;

  @override
  initState() {
    challenge = widget.challenge;
    directionService = DirectionService();
    source = widget.source;
    dest = widget.dest;
    super.initState();
  }

  _getNavigationData() async {
    if (PrefUtil().currentRoute!.timings!.endTime != null) {
      OkCancelResult result = await showOkCancelAlertDialog(
          context: context,
          message: "Your team has already taken part in the this hunt",
          okLabel: 'Ok',
          cancelLabel: 'View Summary');
      if (result == OkCancelResult.cancel && mounted) {
        Navigator.of(context).popAndPushNamed(finishedRoute);
      }
      return;
    }
    setState(() {
      isLoading = true;
    });
    BaseResponse directionsResponse =
        await DirectionService().getDirections(source, dest);
    if (directionsResponse.error == null) {
      MapBoxDirection directions =
          directionsResponse.snapshot as MapBoxDirection;
      if (mounted) {
        bool isServerInformed = await _informServer();
        setState(() {
          isLoading = false;
        });
        if (isServerInformed && mounted) {
          Navigator.of(context).pop(directions);
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _informServer() async {
    BaseResponse toggleActiveApi = await ChallengeService()
        .toggleActiveStatus(PrefUtil().currentTeam!.teamCode!, challenge.id!);
    if (toggleActiveApi.error == null) {
      GenericResponse response = toggleActiveApi.snapshot as GenericResponse;
      if (response.success ?? false) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
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
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: SvgPicture.asset(
                  "assets/svgs/ic_back.svg",
                ),
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.name ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: ColorStyle.primaryTextColor),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Current points: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: ColorStyle.secondaryTextColor),
                        ),
                        Text(
                          "${PrefUtil().currentTeam!.score ?? 0}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: ColorStyle.primaryColor),
                        ),
                      ],
                    ),
                    _buildInfoWidget()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/pngs/mini_map.png',
                  height: 70,
                  width: 70,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              challenge.description ?? "",
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ColorStyle.secondaryTextColor),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              "Points: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.outline100Color),
            ),
            Text(
              "${challenge.totalScore ?? 0}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text(
              "Difficulty: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.outline100Color),
            ),
            Text(
              challenge.difficulty ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text(
              "Challenges: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.outline100Color),
            ),
            Text(
              '${challenge.questions ?? 0}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.primaryColor),
            ),
          ],
        ),
      ],
    );
  }
}
