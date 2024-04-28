import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _termsAccepted = false;
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
                  padding:
                      const EdgeInsets.only(right: 25, top: 25, bottom: 25),
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
                    radius: const Radius.circular(6),
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(left: 25, right: 30),
                        child: const Text(
                            "I, hereby acknowledge that I am voluntarily participating in outdoor activities facilitated by WARRIOR Enterprises LLC (hereinafter referred to as \"the Company\"). I understand that these activities may involve inherent risks, including but not limited to physical injury, illness, property damage, or even death. I acknowledge that I have carefully read and understood the terms outlined herein, and I voluntarily agree to assume all risks associated with my participation in these activities.\n\nIn consideration of being permitted to participate in the activities provided by the Company, I hereby waive, release, and discharge the Company, its officers, employees, agents, successors, and assigns from any and all claims, liabilities, damages, or expenses arising from or in any way connected with my participation in the activities, including those caused by the negligence of the Company or its employees, agents, or representatives.\n\nI understand that it is my responsibility to ensure that I have the necessary skills, physical fitness, and equipment required for the activities. I agree to abide by all safety instructions provided by the Company and its representatives.\n\nFurthermore, I grant the Company and its affiliates the irrevocable and unrestricted right to use and publish photographs, video recordings, or any other media in which I may appear, for marketing, advertising, or any other lawful purpose. I waive any right to inspect or approve the finished product wherein my likeness appears. I understand that these images may be used in print publications, online, or in any other electronic media.\n\nI hereby release, discharge, and agree to hold harmless the Company and its affiliates from any and all claims, demands, or causes of action that I, my heirs, representatives, or assigns may have by reason of this authorization or use of the images, including any claims for libel or invasion of privacy.\n\nI certify that I am of legal age and competent to enter into this agreement. I understand that this waiver and release is a binding contract and shall be construed broadly to provide a release and waiver to the maximum extent permissible under applicable law.\nI have read this waiver and release of liability, fully understand its terms, and voluntarily agree to its contents."),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  setState(() {
                    _termsAccepted = !_termsAccepted;
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (val) {
                        setState(() {
                          _termsAccepted = !_termsAccepted;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "I've read and accept the terms and conditions",
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorStyle.outline100Color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: CustomRoundedButton(
                  "Continue",
                  () {
                    if (_termsAccepted) {
                      Navigator.of(context).pushNamed(processingRoute);
                    }
                  },
                  textColor: _termsAccepted
                      ? ColorStyle.whiteColor
                      : ColorStyle.primaryColor,
                  borderColor: _termsAccepted
                      ? ColorStyle.whiteColor
                      : ColorStyle.primaryColor,
                  buttonBackgroundColor: !_termsAccepted
                      ? ColorStyle.whiteColor
                      : ColorStyle.primaryColor,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
