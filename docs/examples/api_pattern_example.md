# API Integration Pattern

## Overview

This template provides a robust, type-safe pattern for API integration using three core concepts:

```
apiFetch() → ApiResponse<T> → ApiHandler<T>
```

This pattern provides automatic:
- ✅ Loading state management
- ✅ Error handling with retry logic
- ✅ Empty state detection
- ✅ Type-safe data flow
- ✅ Reactive UI updates

## Architecture Flow

```
┌─────────────────┐
│   PostService   │ extends ApiService
│  (Data Layer)   │ - HTTP requests
└────────┬────────┘ - JSON parsing
         │
         │ fetchPosts() → Future<List<PostModel>>
         │
         ↓
┌─────────────────┐
│  PostViewModel  │ extends GetxController
│ (State Layer)   │ - apiFetch() wrapper
└────────┬────────┘ - Stream<ApiResponse<T>>
         │
         │ Rx<ApiResponse<List<PostModel>>>
         │
         ↓
┌─────────────────┐
│   PostsPage     │ StatelessWidget
│   (View Layer)  │ - GetX observer
└────────┬────────┘ - RefreshIndicator
         │
         │ ApiResponse<List<PostModel>>
         │
         ↓
┌─────────────────┐
│  ApiHandler<T>  │ Smart Widget
│ (Renderer)      │ - Loading widget
└─────────────────┘ - Error widget
                     - Empty widget
                     - Success builder
```

## Implementation Guide

### Step 1: Create Your Model

**File**: `lib/src/modules/posts/data/models/post_model.dart`

```dart
class PostModel {
  final int id;
  final int userId;
  final String title;
  final String body;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// JSON deserialization
  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"],
    userId: json["userId"],
    title: json["title"],
    body: json["body"],
  );

  /// JSON serialization
  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "title": title,
    "body": body,
  };
}

/// Helper to parse list from JSON
List<PostModel> postModelFromJson(String str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));
```

**Key Points**:
- Use `fromJson` factory for deserialization
- Use `toJson` for serialization
- Create helper functions for list parsing

### Step 2: Create Your Service

**File**: `lib/src/modules/posts/data/services/post_service.dart`

```dart
import '/src/data/services/api_service.dart';
import '/src/modules/posts/data/models/post_model.dart';

class PostService extends ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetch all posts from API
  Future<List<PostModel>> fetchPosts() async {
    final response = await get('$_baseUrl/posts');
    return postModelFromJson(response.body);
  }
}
```

**Key Points**:
- **Extend `ApiService`** to inherit:
  - Automatic auth headers
  - Retry logic
  - Error handling
  - Timeout management
- Use `get()`, `post()`, `put()`, `delete()` methods
- Return parsed model objects

### Step 3: Create Your ViewModel

**File**: `lib/src/modules/posts/controllers/post_view_model.dart`

```dart
import 'package:get/get.dart';
import '/src/data/network/api_response.dart';
import '/src/modules/posts/data/models/post_model.dart';
import '/src/modules/posts/data/services/post_service.dart';
import '/src/utils/helpers.dart';

class PostViewModel extends GetxController {
  final PostService _postService;

  PostViewModel(this._postService);

  // Reactive state holder
  final Rx<ApiResponse<List<PostModel>>> _posts =
      ApiResponse<List<PostModel>>.idle().obs;

  // Public getter
  ApiResponse<List<PostModel>> get posts => _posts.value;

  @override
  void onInit() {
    super.onInit();
    _fetchPosts();
  }

  /// Fetch posts using apiFetch pattern
  void _fetchPosts() async {
    // apiFetch emits: loading → success/error
    apiFetch(_postService.fetchPosts).listen((value) {
      _posts.value = value;
    });
  }

  /// Public method for pull-to-refresh
  void refreshData() {
    _fetchPosts();
  }
}
```

**Key Points**:
- Use `Rx<ApiResponse<T>>` for reactive state
- Wrap service calls with `apiFetch()`
- Listen to stream and update state
- `apiFetch()` automatically emits:
  1. `ApiResponse.loading()`
  2. `ApiResponse.success(data)` OR `ApiResponse.error(message)`

### Step 4: Create Bindings

**File**: `lib/src/modules/posts/post_bindings.dart`

```dart
import 'package:get/get.dart';
import '/src/modules/posts/data/services/post_service.dart';
import '/src/modules/posts/controllers/post_view_model.dart';

class PostBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostService>(() => PostService());
    Get.lazyPut<PostViewModel>(() => PostViewModel(Get.find()));
  }
}
```

**Key Points**:
- Use `Get.lazyPut()` for lazy initialization
- Service should be registered before ViewModel
- ViewModel uses `Get.find()` to inject service

### Step 5: Create Your View

**File**: `lib/src/modules/posts/views/posts_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/posts/controllers/post_view_model.dart';
import '/src/modules/posts/data/models/post_model.dart';
import '/src/modules/posts/views/widgets/posts_list_view.dart';
import '/src/presentation/widgets/api_handler.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts Example'),
        centerTitle: true,
      ),
      body: GetX<PostViewModel>(
        builder: (controller) => RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: ApiHandler<List<PostModel>>(
            // Current state
            response: controller.posts,

            // Retry callback
            tryAgain: controller.refreshData,

            // Empty check
            isEmpty: (posts) => posts.isEmpty,

            // Success UI
            successBuilder: (posts) => PostsListView(posts: posts),
          ),
        ),
      ),
    );
  }
}
```

**Key Points**:
- **`GetX<ViewModel>`**: Automatically rebuilds when reactive state changes
- **`ApiHandler<T>`**: Smart widget that renders based on `ApiResponse` state
  - `response`: The current ApiResponse state
  - `tryAgain`: Callback for retry button
  - `isEmpty`: Function to check if data is empty
  - `successBuilder`: Widget to show on success

### Step 6: Register in Initial Bindings

**File**: `lib/src/utils/binding.dart`

```dart
import '/src/modules/posts/posts.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // ... other bindings ...

    PostBindings().dependencies();
  }
}
```

## ApiResponse States

`ApiResponse<T>` has four states:

```dart
// 1. Idle (initial state)
ApiResponse<T>.idle()

// 2. Loading (request in progress)
ApiResponse<T>.loading()

// 3. Success (data received)
ApiResponse<T>.success(data)

// 4. Error (request failed)
ApiResponse<T>.error(message)
```

## ApiHandler Rendering Logic

```dart
ApiHandler<T>(
  response: controller.apiResponse,
  tryAgain: controller.retry,
  isEmpty: (data) => data.isEmpty,
  successBuilder: (data) => MySuccessWidget(data),

  // Optional: Custom loading widget
  loadingWidget: const CustomLoadingSpinner(),

  // Optional: Custom error builder
  errorBuilder: (message) => CustomErrorWidget(message: message),

  // Optional: Custom empty builder
  emptyBuilder: () => const CustomEmptyWidget(),
)
```

**Rendering Flow**:
1. **Loading**: Shows `loadingWidget` or default spinner
2. **Error**: Shows `errorBuilder` or default error card with retry button
3. **Success + Empty**: Shows `emptyBuilder` or default empty message
4. **Success + Data**: Shows `successBuilder(data)`

## Advanced: POST Requests

```dart
// In Service
Future<PostModel> createPost({
  required String title,
  required String body,
  required int userId,
}) async {
  final response = await post(
    '$_baseUrl/posts',
    body: {
      'title': title,
      'body': body,
      'userId': userId,
    },
  );
  return PostModel.fromJson(jsonDecode(response.body));
}

// In ViewModel
void createNewPost(String title, String body) async {
  apiFetch(() => _postService.createPost(
    title: title,
    body: body,
    userId: 1,
  )).listen((value) {
    _createPostResponse.value = value;

    if (value.status == Status.success) {
      // Refresh list on success
      refreshData();
    }
  });
}
```

## Error Handling

Errors are automatically caught and wrapped by `apiFetch()`:

- **Network errors**: "No internet connection"
- **Timeout errors**: "Request timeout"
- **Server errors**: HTTP status message
- **Parsing errors**: "Failed to parse response"

All errors emit `ApiResponse.error(message)`, which `ApiHandler` renders with a retry button.

## Benefits of This Pattern

✅ **Type Safety**: Compile-time type checking for all API responses
✅ **Automatic Loading States**: No manual boolean flags needed
✅ **Error Handling**: Centralized error handling with retry logic
✅ **Reactive Updates**: UI automatically rebuilds when data changes
✅ **Testable**: Easy to mock services and test ViewModels
✅ **Reusable**: ApiHandler works with any ApiResponse<T>
✅ **Clean Separation**: Data → State → View layers clearly defined

## Complete Example

See the **Posts Module** for a complete working example:

- **Model**: `lib/src/modules/posts/data/models/post_model.dart`
- **Service**: `lib/src/modules/posts/data/services/post_service.dart`
- **ViewModel**: `lib/src/modules/posts/controllers/post_view_model.dart`
- **View**: `lib/src/modules/posts/views/posts_page.dart`
- **Bindings**: `lib/src/modules/posts/post_bindings.dart`

This example fetches 100 blog posts from JSONPlaceholder API and demonstrates all aspects of the pattern.

## Adapting for Your API

1. **Replace the model**: Create your own model with `fromJson`/`toJson`
2. **Update the service**: Change base URL and endpoints
3. **Configure auth**: Add your API key/token to `ApiService`
4. **Customize UI**: Build your own success widget
5. **Add routes**: Register in `app_pages.dart`

That's it! The pattern remains the same regardless of your backend.
