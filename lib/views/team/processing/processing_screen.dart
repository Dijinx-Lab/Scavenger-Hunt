import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/custom_rounded_button.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _value = 0.0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animationController.addListener(() => _animateProgress());
    _animationController.forward();

    super.initState();
  }

  _animateProgress() {
    if (_animationController.value >= 1) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(learnRouteRoute, (e) => false);
    } else {
      setState(() {
        _value = _animationController.value;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 30),
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Team",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryTextColor),
                      ),
                      Text(
                        "Create a team or join",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: ColorStyle.secondaryTextColor),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: SvgPicture.asset("assets/svgs/ic_people.svg"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Processing to app...",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: ColorStyle.primaryTextColor),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  "Your team successfully created here is code for your team to jin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: ColorStyle.secondaryTextColor),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: _value,
                  strokeWidth: 2.5,
                  backgroundColor: ColorStyle.grey100Color,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: CustomRoundedButton(
                  "Continue",
                  () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(learnRouteRoute, (e) => false),
                  textColor: ColorStyle.whiteColor,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
