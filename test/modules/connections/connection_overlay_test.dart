import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_starter/src/modules/connections/views/connection_overlay.dart';
import 'package:getx_starter/src/modules/connections/controllers/connection_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConnectionOverlay', () {
    setUp(() {
      // Provide a ConnectionViewModel without auto init to avoid platform calls in tests.
      Get.put(ConnectionViewModel(autoInit: false));
    });

    tearDown(() async {
      await Get.delete<ConnectionViewModel>(force: true);
    });

    Widget buildApp(Widget child) => GetMaterialApp(home: Scaffold(body: child));

    testWidgets('shows InfoItem when connecting, offline card when no internet, and nothing when connected', (tester) async {
      final vm = Get.find<ConnectionViewModel>();

      // Start with connecting
      vm.connectionType.value = ConnectivityType.connecting;
      await tester.pumpWidget(buildApp(const ConnectionOverlay(child: SizedBox.shrink())));
      await tester.pump();
      expect(find.textContaining('trying to reconnect'), findsOneWidget);

      // Switch to no internet
      vm.connectionType.value = ConnectivityType.noInternet;
      await tester.pump();
      expect(find.text('CONNECTION LOST'), findsOneWidget);

      // Switch to connected
      vm.connectionType.value = ConnectivityType.wifi;
      await tester.pump();
      expect(find.text('CONNECTION LOST'), findsNothing);
      expect(find.textContaining('trying to reconnect'), findsNothing);
    });
  });
}
