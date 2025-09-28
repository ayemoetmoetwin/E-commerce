import 'package:flutter/material.dart';
import '../utils/colors.dart';

class NoInternetBanner extends StatelessWidget {
  const NoInternetBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.error,
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: AppColors.secondary, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'No Internet Connection',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // You can add retry functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checking connection...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Icon(
              Icons.refresh,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
