import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import 'no_internet_banner.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityService().connectivityStream,
      initialData: ConnectivityService().isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;

        return Column(
          children: [
            if (!isConnected) const NoInternetBanner(),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
