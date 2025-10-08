import 'package:get/get.dart';
import '../../../core/presentation/actions/action_presenter.dart';
import '../../../core/routing/route_manager.dart';
import '../controllers/connection_view_model.dart';

/// Singleton class to manage connection-related actions.
///
/// This class interacts with the `ConnectionViewModel` to check and update
/// the connectivity state and handles navigation from the splash screen.
class ConnectionActions extends ActionPresenter {
  /// Singleton instance of `ConnectionActions` to ensure it’s initialized only once.
  static final ConnectionActions _mInstance = ConnectionActions._();

  /// Public getter to access the singleton instance.
  static ConnectionActions get instance => _mInstance;

  /// Reference to the `ConnectionViewModel` that manages connectivity logic.
  late final ConnectionViewModel _connectionViewModel;

  /// Private constructor to initialize the singleton and fetch `ConnectionViewModel` via GetX.
  ConnectionActions._() {
    _connectionViewModel = Get.find<ConnectionViewModel>(); // Retrieve the instance from GetX.
  }

  /// Checks and updates the connectivity state using `ConnectionViewModel`.
  ///
  /// This method calls `getConnectivity` on the `ConnectionViewModel`.
  Future<void> checkConnectivity() async {
    await _connectionViewModel.getConnectivity();
  }

  /// Initializes the splash screen and navigates to the next route.
  ///
  /// This method waits for the specified delay, checks the connectivity,
  /// and navigates to the `nextRouteString`. If there are any network issues,
  /// it will handle the errors accordingly.
  ///
  /// - `nextRouteString`: The route to navigate after initialization.
  /// - `delayInSeconds`: Time in seconds to delay before navigation.
  Future<void> initSplash(String nextRouteString, int delayInSeconds) async {
    actionHandlerWithoutLoading(() async {
      await Future.delayed(Duration(seconds: delayInSeconds)); // Wait for the specified delay.
      await checkConnectivity(); // Check connectivity after the delay.
      RouteManager.off(nextRouteString); // Navigate to the next route if no issues.
    });
  }

  /// Refreshes data when needed.
  ///
  /// This method is a placeholder for future logic to refresh relevant data.
  void refreshData() {
    // TODO: Implement logic to refresh necessary data.
  }

  /// Handles logic when the connection is lost.
  ///
  /// This method is a placeholder for future logic when a connection is lost.
  void onConnectionLost() {
    // TODO: Implement logic for handling connection lost scenario.
  }
}
