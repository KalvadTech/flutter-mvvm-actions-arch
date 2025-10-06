import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/connections/views/connection_handler.dart';
import 'package:getx_starter/src/modules/connections/controllers/connection_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConnectionHandler', () {
    setUp(() {
      Get.put(ConnectionViewModel(autoInit: false));
    });

    tearDown(() async {
      await Get.delete<ConnectionViewModel>(force: true);
    });

    testWidgets('shows onConnectingWidget during connecting; renders connected only when connected; retry on tap when offline', (tester) async {
      final vm = Get.find<ConnectionViewModel>();
      int tries = 0;

      await tester.pumpWidget(GetMaterialApp(
        home: Scaffold(
          body: ConnectionHandler(
            connectedWidget: const Text('CONNECTED'),
            onConnectingWidget: const Text('CONNECTING...'),
            tryAgainAction: () => tries++,
          ),
        ),
      ));

      // Default is connecting → should show onConnectingWidget
      expect(find.text('CONNECTING...'), findsOneWidget);
      expect(find.text('CONNECTED'), findsNothing);

      // Offline → show retry UI
      vm.connectionType.value = ConnectivityType.noInternet;
      await tester.pump();
      expect(find.text('Try again'), findsOneWidget);

      // Tap try again
      await tester.tap(find.text('Try again'));
      expect(tries, 1);

      // Mark as connected
      vm.connectionType.value = ConnectivityType.wifi;
      await tester.pump();
      expect(find.text('CONNECTED'), findsOneWidget);
    });
  });
}
