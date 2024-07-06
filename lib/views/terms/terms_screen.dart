import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/arguments/term_args.dart';
import 'package:scavenger_hunt/services/team_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/toast_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class TermsScreen extends StatefulWidget {
  final TermsArgs arguments;
  const TermsScreen({super.key, required this.arguments});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _termsAccepted = false;
  bool isLoading = false;
  late TeamService teamService;
  String htmlData = "";

  @override
  initState() {
    super.initState();
    teamService = TeamService();
    _getData();
  }

  _getData() {
    setState(() {
      isLoading = true;
    });
    teamService.getTerms(widget.arguments.forTerms).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.error == null) {
        String? res = value.snapshot;
        if (res != null) {
          htmlData = res;
          setState(() {});
        } else {
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: res ?? "",
            icon: const Icon(
              Icons.cancel_outlined,
              color: ColorStyle.whiteColor,
            ),
          );
        }
      } else {
        ToastUtils.showCustomSnackbar(
          context: context,
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: widget.arguments.fromMap
              ? _buildMapTermsWidget()
              : _buildIntroTermsWidget(),
        ),
      ),
    );
  }

  _buildMapTermsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: SvgPicture.asset(
                "assets/svgs/ic_back.svg",
              ),
              visualDensity: VisualDensity.compact,
            ),
            Text(
              widget.arguments.forTerms
                  ? "Terms & Conditions"
                  : "Privacy Policy",
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: ColorStyle.primaryTextColor),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 25, top: 25, bottom: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorStyle.black200Color,
              ),
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: ColorStyle.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : RawScrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    thumbColor: ColorStyle.primaryColor,
                    trackColor: ColorStyle.scrollColor,
                    radius: const Radius.circular(6),
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(left: 5, right: 10),
                        child: Html(
                          data: htmlData,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  _buildIntroTermsWidget() {
    return Column(
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
            padding: const EdgeInsets.only(right: 25, top: 25, bottom: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorStyle.black200Color,
              ),
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: ColorStyle.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : RawScrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    thumbColor: ColorStyle.primaryColor,
                    trackColor: ColorStyle.scrollColor,
                    radius: const Radius.circular(6),
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.only(left: 25, right: 30),
                        child: Html(
                          data: htmlData,
                        ),
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
          child: Opacity(
            opacity: isLoading ? 0.4 : 1,
            child: AbsorbPointer(
              absorbing: isLoading,
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
                  const Expanded(
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
    );
  }
}
