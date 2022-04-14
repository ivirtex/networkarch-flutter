// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const Set<String> kProductIds = <String>{
  'com.hubertjozwiak.networkarch.premium',
};

void listenToPurchaseUpdated(
  List<PurchaseDetails> purchaseDetailsList,
  BuildContext context,
) {
  // ignore: avoid_function_literals_in_foreach_calls
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (kDebugMode) {
      print(
        'Received purchase: ${purchaseDetails.productID} with status: ${purchaseDetails.status}',
      );
    }
    Sentry.captureMessage(
      'Received purchase: ${purchaseDetails.productID} with status: ${purchaseDetails.status}',
    );

    if (purchaseDetails.status == PurchaseStatus.pending) {
      _showPendingUI(context);
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        _handleError(purchaseDetails.error!, context);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        _deliverProduct(purchaseDetails, context);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  });
}

void _showPendingUI(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (context) {
      return PlatformAlertDialog(
        title: const Text('Purchase is processing...'),
        content: const CircularProgressIndicator.adaptive(),
      );
    },
  );
}

void _handleError(IAPError iapError, BuildContext context) {
  Sentry.captureMessage(
    'IAP Error: ${iapError.message}',
    level: SentryLevel.error,
  );

  showPlatformDialog(
    context: context,
    builder: (context) {
      return PlatformAlertDialog(
        title: const Text('Error'),
        content: const Text(
          'There was an error completing your purchase. Please try again later.',
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _deliverProduct(
  PurchaseDetails purchaseDetails,
  BuildContext context,
) async {
  InAppPurchase.instance.completePurchase(purchaseDetails);

  if (purchaseDetails.productID == 'com.hubertjozwiak.networkarch.premium') {
    await Hive.box('iap').put('isPremiumGranted', true);
  }

  if (purchaseDetails.status != PurchaseStatus.restored) {
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}
