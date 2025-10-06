import 'package:flutter_test/flutter_test.dart';
import 'package:getx_starter/src/modules/connections/controllers/connection_view_model.dart';

void main() {
  group('ConnectionViewModel basics', () {
    test('isConnected returns true only for wifi or mobileData', () async {
      final vm = ConnectionViewModel(autoInit: false);

      vm.connectionType.value = ConnectivityType.connecting;
      expect(vm.isConnected(), isFalse);

      vm.connectionType.value = ConnectivityType.disconnected;
      expect(vm.isConnected(), isFalse);

      vm.connectionType.value = ConnectivityType.noInternet;
      expect(vm.isConnected(), isFalse);

      vm.connectionType.value = ConnectivityType.wifi;
      expect(vm.isConnected(), isTrue);

      vm.connectionType.value = ConnectivityType.mobileData;
      expect(vm.isConnected(), isTrue);
    });
  });
}
