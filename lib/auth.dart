import 'package:flutter/material.dart';

import 'package:stock_market/register.dart';
import 'package:stock_market/login.dart';
import 'package:stock_market/theme/app_theme.dart';

import 'package:stock_market/widgets/big_button.dart';
import 'package:stock_market/widgets/small_gap_vertical.dart';
import 'package:stock_market/widgets/chip.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  void _login(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _register(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isWide = width >= 700;
            final contentMaxWidth = isWide ? 480.0 : width;
            final horizontalPadding = isWide ? 32.0 : 24.0;

            final logoSize = (width * 0.12).clamp(48.0, 64.0);
            final headlineSize = (width * 0.09).clamp(28.0, 40.0);
            final bodySize = (width * 0.045).clamp(16.0, 18.0);
            final emphasisSize = (width * 0.04).clamp(14.0, 16.0);
            final disclaimerSize = (width * 0.028).clamp(11.0, 13.0);

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 48,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: logoSize,
                                    height: logoSize,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(logoSize * 0.25),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '₹',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: logoSize * 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SmallGapVertical(),
                                  const SmallGapVertical(),
                                  Text(
                                    'Investing,\nminus the confusion.',
                                    style: TextStyle(
                                      fontSize: headlineSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      height: 1.15,
                                    ),
                                  ),
                                  const SmallGapVertical(),
                                  const SmallGapVertical(),
                                  Text(
                                    'Hum batayenge kya lena hai, kitna lena hai.',
                                    style: TextStyle(
                                      fontSize: bodySize,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SmallGapVertical(),
                                  Text(
                                    'You just decide when.',
                                    style: TextStyle(
                                      fontSize: emphasisSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SmallGapVertical(),
                                  const SmallGapVertical(),
                                  const Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      MyChip(label: '₹0 brokerage'),
                                      MyChip(label: 'start with ₹500'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            BigButton(
                              onPressed: () => _register(context),
                              text: 'Get started →',
                              primary: true,
                            ),
                            const SmallGapVertical(),
                            BigButton(
                              onPressed: () => _login(context),
                              text: 'I already have an account',
                            ),
                            const SmallGapVertical(),
                            const SmallGapVertical(),
                            Center(
                              child: Text(
                                'Investments are subject to market risks. Investright is a\nSEBI-registered investment advisor.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: disclaimerSize,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
