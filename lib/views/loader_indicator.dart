import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../utils/tiktok_colors.dart';

class LoaderIndicator extends StatelessWidget {
  const LoaderIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<DataProvider>().isLoading()
        ? Center(child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: TikTokColors.progressIndicatorColor,
            ),
          ),
        )
        : const SizedBox.shrink();
  }
}