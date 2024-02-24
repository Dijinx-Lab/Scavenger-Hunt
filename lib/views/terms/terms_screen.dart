import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/custom_rounded_button.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: SvgPicture.asset("assets/svgs/ic_settings.svg"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Terms & Conditions",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: ColorStyle.primaryTextColor),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  "We are not responsible for any damages done during the game,",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: ColorStyle.secondaryTextColor),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 25, top: 25, bottom: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorStyle.black200Color,
                    ),
                  ),
                  child: RawScrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    thumbColor: ColorStyle.primaryColor,
                    trackColor: ColorStyle.scrollColor,
                    radius: Radius.circular(6),
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.only(left: 25, right: 30),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sollicitudin aliquam tincidunt. Cras eget est id neque fermentum tempus. Suspendisse sit amet dignissim neque. Etiam ornare maximus ipsum, non mollis turpis malesuada sit amet. Donec sagittis porta varius. Cras vel convallis justo. Nunc lobortis rhoncus eros, vitae eleifend quam maximus quis. Praesent faucibus nunc eget quam sagittis, ac tempor eros iaculis. Ut rhoncus, ex quis iaculis condimentum, nibh ex laoreet eros, a eleifend eros dui vitae elit. Donec eget tempor felis. Quisque id ligula nibh. Vestibulum nibh mauris, mattis ac nisl at, ultrices pretium lacus. Curabitur dapibus mollis leo. Praesent placerat nisi ac lacinia euismod. Etiam at consectetur nunc. Praesent ac erat felis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris eget orci ac ante consequat pretium. Nunc cursus efficitur aliquet. Vivamus efficitur neque sit amet massa dictum, quis commodo magna tristique. Quisque faucibus, erat vitae tincidunt auctor, purus nunc sollicitudin leo, at finibus massa purus id nunc. Ut sit amet accumsan eros, vehicula mollis arcu. Sed sollicitudin nulla et ipsum ultrices, sed elementum erat convallis. Vestibulum vel ex vitae elit gravida elementum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sollicitudin aliquam tincidunt. Cras eget est id neque fermentum tempus. Suspendisse sit amet dignissim neque. Etiam ornare maximus ipsum, non mollis turpis malesuada sit amet. Donec sagittis porta varius. Cras vel convallis justo. Nunc lobortis rhoncus eros, vitae eleifend quam maximus quis. Praesent faucibus nunc eget quam sagittis, ac tempor eros iaculis. Ut rhoncus, ex quis iaculis condimentum, nibh ex laoreet eros, a eleifend eros dui vitae elit. Donec eget tempor felis. Quisque id ligula nibh. Vestibulum nibh mauris, mattis ac nisl at, ultrices pretium lacus. Curabitur dapibus mollis leo. Praesent placerat nisi ac lacinia euismod. Etiam at consectetur nunc. Praesent ac erat felis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris eget orci ac ante consequat pretium. Nunc cursus efficitur aliquet. Vivamus efficitur neque sit amet massa dictum, quis commodo magna tristique. Quisque faucibus, erat vitae tincidunt auctor, purus nunc sollicitudin leo, at finibus massa purus id nunc. Ut sit amet accumsan eros, vehicula mollis arcu. Sed sollicitudin nulla et ipsum ultrices, sed elementum erat convallis. Vestibulum vel ex vitae elit gravida elementum."),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: CustomRoundedButton(
                  "Continue",
                  () => Navigator.of(context).pushNamed(joinTeamRoute),
                  textColor: ColorStyle.whiteColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  "By pressing “Continue” you accept with terms and conditions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: ColorStyle.outline100Color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
