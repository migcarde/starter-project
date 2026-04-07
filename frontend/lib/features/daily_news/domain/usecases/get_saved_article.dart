import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class GetSavedArticleUseCase
    implements UseCase<DataState<List<ArticleEntity>>, void> {
  final ArticleRepository _articleRepository;

  GetSavedArticleUseCase(this._articleRepository);

  @override
  Future<DataState<List<ArticleEntity>>> call({void params}) async {
    // TODO: Replace with repository call
    return const DataSuccess(
      [
        ArticleEntity(
          id: 1,
          author: 'John Doe',
          title: 'Exploring the Future of Flutter',
          description:
              'A deep dive into the next big features coming to Flutter — from Impeller rendering to multi-window support and beyond.',
          url: 'https://example.com/flutter-future',
          urlToImage:
              'https://images.unsplash.com/photo-1551288049-bbda4865cda0',
          publishedAt: '2024-05-20T10:00:00Z',
          content: '''# Exploring the Future of Flutter

Flutter has grown from a promising cross-platform framework into one of the most actively maintained and developer-loved toolkits in the world. With each new release, Google and the open-source community push the boundaries of what is possible when building natively compiled applications for mobile, web, and desktop from a single codebase. In this article, we take an in-depth look at the innovations on the horizon and explain why Flutter's future has never looked brighter.

## The Impeller Rendering Engine

One of the most significant architectural changes in Flutter's recent history is the introduction of **Impeller**, an entirely new rendering backend designed to eliminate the shader compilation jank that plagued earlier versions. Traditional Flutter relied on Skia, a general-purpose graphics library that compiles GPU shaders at runtime. This caused noticeable hitches the first time a user encountered a new animation or visual element.

Impeller pre-compiles a smaller, fixed set of shaders during the build step, trading flexibility for predictability. The result is silky-smooth frame delivery from the very first frame, even on lower-end devices. Impeller is already the default on iOS and is rapidly gaining parity on Android, with WebGPU support on the horizon for web targets.

### Key Benefits of Impeller

- **Consistent 60/120 fps** rendering without cold-start jank
- **Reduced memory overhead** compared to the Skia path
- **Better integration** with platform-native compositing layers
- **Easier debugging** thanks to a simpler, inspectable shader pipeline

## Dart 3 and the Language Evolution

Flutter and Dart evolve hand-in-hand. Dart 3 introduced a set of features that fundamentally improve how developers model data and control flow:

### Records

Records allow developers to bundle multiple values into a single, lightweight, anonymous composite type without defining a full class. This is incredibly useful for returning multiple values from a function or pairing related data.

```dart
(String name, int age) getUser() => ('Alice', 30);
final (name, age) = getUser();
```

### Patterns

Pattern matching brings expressive destructuring to Dart. Combined with switch expressions, code that previously required verbose chains of `if/else` blocks or manual casting can now be written concisely and safely.

```dart
switch (shape) {
  case Circle(radius: var r):
    print('Circle with radius \$r');
  case Rectangle(width: var w, height: var h):
    print('Rectangle \${w}x\$h');
}
```

### Class Modifiers

Dart 3 introduces `sealed`, `final`, `interface`, and `base` class modifiers, giving library authors and application developers precise control over class hierarchies and ensuring compile-time exhaustiveness checks.

## Multi-Window and Multi-View Support

Perhaps the most exciting capability for desktop-targeting developers is Flutter's growing multi-window and multi-view support. Previously, a Flutter application was restricted to a single root view. The new `FlutterView` and `FlutterEngine` APIs allow developers to spawn additional windows, embed Flutter content inside platform-native views, and even render to multiple screens simultaneously.

This unlocks use cases that were previously impossible without platform-specific code, such as:

- Displaying a presentation on an external monitor while keeping a control panel on the main screen
- Building IDE-like UIs with detachable panels
- Rendering widgets inside native Android `SurfaceView` components for seamless integration

## WebAssembly and the Web Story

Flutter Web has historically faced criticism for performance and SEO limitations. The team is addressing both concerns head-on with **WebAssembly (Wasm)** compilation. By compiling the Dart runtime and application code to Wasm, Flutter Web achieves near-native execution speed in the browser, bypassing the JavaScript VM entirely.

Combined with improvements to HTML rendering fallbacks and better support for progressive web app (PWA) patterns, Flutter Web is becoming a genuinely competitive option for web application development.

## Ecosystem Maturity

The pub.dev ecosystem has matured enormously. Packages for state management (Bloc, Riverpod, Signals), networking (Dio, Retrofit), local databases (Drift, Isar), and platform integrations (camera, bluetooth, health) are robust, well-maintained, and production-ready. The community has also standardized on patterns like clean architecture and feature-driven directory structures, making it easier for teams to onboard new developers.

## What to Watch

- **Dart macros**: A code generation system built directly into the compiler, eliminating the need for `build_runner` for many common tasks.
- **Hot reload improvements**: Work is ongoing to make hot reload more reliable across complex widget trees and native plugin boundaries.
- **AI-assisted tooling**: Integration between Flutter DevTools and large language models for automatic performance recommendations and widget tree explanations.

## Conclusion

Flutter is not standing still. With Impeller delivering smooth rendering, Dart 3 modernizing the language, multi-window support expanding desktop capabilities, and WebAssembly making the web story compelling, the framework is entering a new era of maturity and power. Whether you are building your first app or architecting a large-scale enterprise product, Flutter's trajectory makes it one of the safest and most exciting bets in cross-platform development today.

Stay curious, keep experimenting, and embrace the future — it renders at 120 fps.
''',
        ),
        ArticleEntity(
          id: 2,
          author: 'Jane Smith',
          title: 'The Rise of AI in Mobile Apps',
          description:
              'How artificial intelligence is transforming the mobile landscape — from on-device inference to generative UI and beyond.',
          url: 'https://example.com/ai-mobile',
          urlToImage:
              'https://images.unsplash.com/photo-1507146153580-69a1ff6d1403',
          publishedAt: '2024-05-21T12:30:00Z',
          content: '''# The Rise of AI in Mobile Apps

Artificial intelligence is no longer a feature reserved for server-side giants operating data centers filled with GPU clusters. It has arrived on the device in your pocket, and it is reshaping what users expect from mobile applications. In this comprehensive overview, we explore how AI is being integrated into mobile apps, the technologies making it possible, and the opportunities and challenges developers face in this rapidly evolving landscape.

## From Cloud AI to On-Device Intelligence

For years, AI in mobile apps meant sending data to a remote API, waiting for a response, and displaying the result. This architecture worked, but it introduced latency, required a network connection, and raised serious privacy concerns — every query and image the user sent left the device.

The paradigm has shifted dramatically with the rise of **on-device machine learning**. Frameworks like **TensorFlow Lite**, **Core ML** (Apple), and **Google ML Kit** allow developers to run inference directly on the device's CPU, GPU, or dedicated Neural Processing Unit (NPU). Modern smartphones now include powerful NPUs — Apple's Neural Engine, Qualcomm's Hexagon DSP, and Google's Tensor chip — purpose-built for running neural network operations efficiently and at low power.

### Benefits of On-Device AI

| Benefit | Description |
|---|---|
| **Privacy** | User data never leaves the device |
| **Low Latency** | No network round-trip; results in milliseconds |
| **Offline Support** | Works without an internet connection |
| **Cost Efficiency** | No server inference costs at scale |

## Key Use Cases

### 1. Natural Language Processing

Spell checking, grammar correction, smart replies, and real-time translation are now standard AI features embedded directly in operating systems and apps. Modern NLP models can run entirely on-device, enabling features like:

- **Smart compose** that suggests entire sentences while typing
- **Offline translation** between dozens of language pairs
- **Voice-to-text** transcription with punctuation inference
- **Sentiment analysis** for content moderation in social apps

### 2. Computer Vision

The camera is the AI sensor of the smartphone. Computer vision pipelines power:

- **Real-time object detection** for augmented reality shopping
- **Document scanning** with automatic de-skewing and OCR
- **Face ID and biometric authentication**
- **Skin condition analysis** in health apps
- **Defect detection** in industrial inspection apps

### 3. Recommendation Systems

Streaming services, e-commerce platforms, and news aggregators use on-device models to personalize feeds without sending browsing history to external servers. Federated learning allows these models to improve from user behavior without centralizing data.

### 4. Generative AI

The most exciting frontier is generative AI running on mobile. Tools like **Gemini Nano** and **Phi-3 Mini** are small enough to fit on a smartphone and powerful enough to:

- Draft emails and messages
- Summarize long documents
- Generate code snippets
- Create images from text prompts

## Integrating AI in Flutter Apps

Flutter developers have access to a growing set of tools for integrating AI features:

```dart
// Example: Using ML Kit for text recognition
final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
final inputImage = InputImage.fromFile(imageFile);
final recognized = await textRecognizer.processImage(inputImage);

for (final block in recognized.blocks) {
  print(block.text);
}
```

The **`google_mlkit_text_recognition`** package provides a simple Dart API over Google's ML Kit SDKs, handling all platform-channel complexity for you.

## Challenges

- **Model size**: Even quantized models can be tens of megabytes, bloating app download sizes.
- **Energy consumption**: Sustained inference drains battery life quickly.
- **Model updates**: Distributing updated models without a full app update requires over-the-air model delivery infrastructure.
- **Bias and fairness**: AI models can perpetuate or amplify biases present in training data.
- **Explainability**: Users and regulators increasingly demand that AI decisions be interpretable.

## The Road Ahead

The mobile AI story is only beginning. Expect to see:

- **Multimodal models** that combine vision, speech, and text understanding in a single compact model
- **Agentic AI** that can autonomously complete multi-step tasks on behalf of the user
- **AI-native UI frameworks** where the interface itself is generated or adapted dynamically by a model
- **Privacy-preserving federated learning** baked into OS-level APIs

## Conclusion

AI has crossed the threshold from cloud curiosity to mobile necessity. Users now expect their apps to understand them, anticipate their needs, and protect their privacy — all at the same time. Developers who embrace on-device intelligence today are building the experiences that will define the next decade of mobile software. The tools are available, the hardware is ready, and the user appetite is enormous. The only question is: what will you build?
''',
        ),
        ArticleEntity(
          id: 3,
          author: 'Alice Johnson',
          title: 'Clean Architecture in Dart',
          description:
              'Best practices for structuring your Dart and Flutter projects using Clean Architecture — layers, dependencies, and real-world patterns explained.',
          url: 'https://example.com/clean-arch',
          urlToImage:
              'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
          publishedAt: '2024-05-22T09:15:00Z',
          content: '''# Clean Architecture in Dart

Software architecture is the set of decisions that are hardest to change later. Getting it right early — or at least getting it *intentional* early — pays enormous dividends as a project grows. Clean Architecture, popularized by Robert C. Martin (Uncle Bob), provides a set of principles that keep codebases flexible, testable, and maintainable over time. In this article, we explore how to apply Clean Architecture specifically to Dart and Flutter projects.

## The Core Principle: Dependency Rule

The central idea of Clean Architecture is the **Dependency Rule**: source code dependencies must point only inward — toward higher-level, more abstract policies — never outward toward lower-level details.

In practice, this means an entity (your core business logic) must never import a framework class, a database driver, or an HTTP client. Instead, those outer layers depend on abstract interfaces defined by the inner layers.

```
Entities  <--  Use Cases  <--  Interface Adapters  <--  Frameworks & Drivers
```

## Layer Breakdown

### 1. Entities (Domain Layer)

Entities encapsulate enterprise-wide business rules. In a news app, an `ArticleEntity` is a pure Dart class with no dependencies on Flutter, Dio, or any database library.

```dart
class ArticleEntity extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? content;

  const ArticleEntity({this.id, this.title, this.description, this.content});

  @override
  List<Object?> get props => [id, title, description, content];
}
```

### 2. Use Cases (Domain Layer)

Use cases contain application-specific business rules. Each use case has a single responsibility and depends only on repository interfaces, never on concrete implementations.

```dart
abstract class UseCase<Type, Params> {
  Future<Type> call({Params params});
}

class GetArticlesUseCase implements UseCase<DataState<List<ArticleEntity>>, void> {
  final ArticleRepository _repository;
  GetArticlesUseCase(this._repository);

  @override
  Future<DataState<List<ArticleEntity>>> call({void params}) =>
      _repository.getNewsArticles();
}
```

### 3. Repository Interfaces (Domain Layer)

Defined as abstract classes in the domain layer, repositories declare the contract that data sources must fulfil.

```dart
abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();
  Future<DataState<void>> saveArticle(ArticleEntity article);
  Future<DataState<void>> removeArticle(ArticleEntity article);
  Future<DataState<List<ArticleEntity>>> getSavedArticles();
}
```

### 4. Repository Implementations (Data Layer)

The data layer provides concrete implementations of the domain repository interfaces, coordinating between remote APIs and local databases.

### 5. Presentation Layer

The presentation layer contains UI widgets and state management (BLoC, Riverpod, etc.). It knows about use cases but not about repositories or data sources.

## Directory Structure

```
lib/
├── core/
│   ├── errors/
│   ├── resources/
│   └── usecase/
└── features/
    └── daily_news/
        ├── data/
        │   ├── data_sources/
        │   │   ├── local/
        │   │   └── remote/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repository/
        │   └── usecases/
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/
```

## Dependency Injection

Clean Architecture requires that concrete implementations be injected rather than directly instantiated. Use a service locator like `get_it`:

```dart
final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Data sources
  sl.registerSingleton<AppDatabase>(await \$FloorAppDatabase.databaseBuilder('db.db').build());

  // Repositories
  sl.registerSingleton<ArticleRepository>(ArticleRepositoryImpl(sl(), sl()));

  // Use cases
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));

  // Blocs
  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc(sl()));
}
```

## Testing Benefits

The greatest practical benefit of Clean Architecture is **testability**. Because each layer depends on abstractions, you can:

- Unit-test use cases by mocking repository interfaces
- Unit-test repositories by mocking data source APIs
- Widget-test BLoCs by injecting fake use cases
- Run the entire domain logic without Flutter, a device, or a network

```dart
class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  test('GetArticlesUseCase returns data on success', () async {
    final repo = MockArticleRepository();
    when(() => repo.getNewsArticles()).thenAnswer((_) async => DataSuccess(mockArticles));

    final useCase = GetArticlesUseCase(repo);
    final result = await useCase();

    expect(result, isA<DataSuccess>());
  });
}
```

## Common Pitfalls

- **Premature abstraction**: Not every app needs five layers. For small projects, a simplified two-layer approach (domain + UI) may be more pragmatic.
- **Leaking framework types**: Accidentally importing `flutter/material.dart` inside the domain layer breaks the dependency rule.
- **Anemic domain model**: Putting all logic in use cases and leaving entities as mere data bags can lead to a bloated use case layer.

## Conclusion

Clean Architecture in Dart is not about rigidly following a diagram — it is about keeping concerns separated, dependencies pointing inward, and business logic isolated from the framework and infrastructure. When implemented thoughtfully, it yields codebases that are a pleasure to work with, easy to test, and resilient to change. Start with the domain, define your contracts, and let the implementation details follow.
''',
        ),
        ArticleEntity(
          id: 4,
          author: 'Bob Brown',
          title: 'State Management Showdown',
          description:
              'Comparing Provider, Riverpod, and Bloc for your next Flutter project — philosophy, ergonomics, testability, and when to choose each.',
          url: 'https://example.com/state-mgmt',
          urlToImage:
              'https://images.unsplash.com/photo-1542831371-29b0f74f9713',
          publishedAt: '2024-05-23T14:45:00Z',
          content: '''# State Management Showdown: Provider vs Riverpod vs Bloc

State management is the topic that generates the most debate in the Flutter community. Every developer has an opinion, every opinion is backed by a blog post, and every blog post spawns a Twitter thread. Let us cut through the noise and make a structured comparison of the three most widely adopted solutions: **Provider**, **Riverpod**, and **Bloc**.

## Why State Management Matters

Flutter's reactive UI model means that the widget tree rebuilds whenever state changes. Managing *when* and *how* state changes — correctly and efficiently — is the fundamental challenge of any non-trivial Flutter application. The wrong choice leads to spaghetti `setState` calls scattered across a deeply nested widget tree, making bugs nearly impossible to trace and features nearly impossible to add.

## Provider

Provider was originally created by Remi Rousselet and later endorsed by the Flutter team as the recommended approach over raw `InheritedWidget`. It wraps an `InheritedWidget` with a friendlier API and adds lifecycle management via `ChangeNotifier`.

### How It Works

```dart
class CounterNotifier extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

// In the widget tree:
ChangeNotifierProvider(
  create: (_) => CounterNotifier(),
  child: const MyApp(),
);

// Consuming:
final counter = context.watch<CounterNotifier>();
Text('\${counter.count}');
```

### Strengths

- Simple, minimal boilerplate
- Tight integration with the Flutter widget lifecycle
- Large community and extensive documentation
- Good enough for small to medium apps

### Weaknesses

- Depends on `BuildContext`, making it harder to use outside the widget tree
- Combining multiple providers can become unwieldy
- Less type-safe than Riverpod in complex scenarios
- Not ideal for apps with complex async state

## Riverpod

Riverpod is Remi's spiritual successor to Provider, designed from the ground up to address Provider's limitations. The name is literally an anagram of "Provider". It removes the `BuildContext` dependency entirely and introduces a compile-time safe provider system.

### How It Works

```dart
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);
  void increment() => state++;
}

// Consuming via ConsumerWidget:
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('\$count');
  }
}
```

### Strengths

- **No `BuildContext` required** — providers can be read anywhere
- **Compile-time safety** — accessing an undeclared provider is a compile error
- **Excellent async support** via `FutureProvider` and `AsyncNotifier`
- **Auto-dispose** prevents memory leaks automatically
- **Developer experience** with Riverpod Generator and code generation

### Weaknesses

- Steeper learning curve than Provider
- Code generation adds build complexity
- Relatively newer ecosystem

## Bloc

Bloc (Business Logic Component) implements a strict unidirectional data flow pattern. Events go in, states come out. It was designed with scalability, testability, and team collaboration in mind.

### How It Works

```dart
// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}

// Bloc
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
  }
}

// UI
BlocBuilder<CounterBloc, int>(
  builder: (context, count) => Text('\$count'),
);
```

### Strengths

- **Strict separation** between UI and business logic
- **Highly testable** — events and states are plain objects
- **Predictable state transitions** — easy to trace bugs
- **Excellent DevTools** integration for state inspection
- **Team-friendly** — enforces conventions that all developers can follow

### Weaknesses

- More verbose than Provider/Riverpod for simple scenarios
- Learning curve for developers new to event-driven patterns
- Requires more files per feature (events, states, bloc)

## Comparison Matrix

| Criterion | Provider | Riverpod | Bloc |
|---|---|---|---|
| Boilerplate | Low | Medium | High |
| Testability | Good | Excellent | Excellent |
| Async Support | Basic | Excellent | Good |
| TypeSafety | Medium | High | High |
| Learning Curve | Low | Medium | Medium-High |
| Scalability | Medium | High | High |
| DevTools | Basic | Good | Excellent |

## When to Choose Each

- **Provider**: Small apps, prototypes, teams already familiar with `ChangeNotifier`.
- **Riverpod**: Medium to large apps where async state and testability are priorities, especially solo developers or small teams.
- **Bloc**: Large teams, enterprise apps, or projects where strict conventions and audit trails of state changes are required.

## Conclusion

There is no universally correct answer. The best state management solution is the one your team understands deeply and applies consistently. Start simple, grow into complexity only when your app demands it, and never let the state management choice become a blocker to shipping.
''',
        ),
        ArticleEntity(
          id: 5,
          author: 'Charlie Davis',
          title: 'Mastering Flutter Animations',
          description:
              'Create stunning user experiences with advanced Flutter animations — implicit, explicit, physics-based, and hero transitions explained with code.',
          url: 'https://example.com/flutter-animations',
          urlToImage:
              'https://images.unsplash.com/photo-1460925895917-afdab827c52f',
          publishedAt: '2024-05-24T11:20:00Z',
          content: '''# Mastering Flutter Animations

Great software feels alive. The difference between an app that feels premium and one that feels generic often comes down to motion — the polish of a well-timed transition, the delight of a subtle micro-interaction, the clarity of an animated visual feedback. Flutter ships with one of the most powerful and flexible animation systems in any UI framework. In this deep dive, we cover the full animation toolkit from top to bottom.

## The Animation Model

Flutter animations are built on a simple but powerful mental model. An `Animation<T>` is an object that produces values of type `T` over time, driven by an `AnimationController`. The controller manages the timeline — its duration, direction, and repetition — while curve functions shape how values progress from start to finish.

```dart
late AnimationController _controller;
late Animation<double> _opacity;

@override
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeIn),
  );
  _controller.forward();
}
```

## Implicit Animations

Implicit animations are the simplest entry point. Flutter provides `AnimatedContainer`, `AnimatedOpacity`, `AnimatedPadding`, `AnimatedDefaultTextStyle`, and many more. These widgets automatically animate changes to their properties whenever those properties change, requiring no controller or tween management.

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: _expanded ? 200.0 : 100.0,
  height: _expanded ? 200.0 : 100.0,
  color: _expanded ? Colors.blue : Colors.red,
  child: const FlutterLogo(),
);
```

### `TweenAnimationBuilder`

For properties not covered by built-in animated widgets, `TweenAnimationBuilder` provides a generic builder that interpolates between any two values.

```dart
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: 1.0),
  duration: const Duration(seconds: 1),
  builder: (context, value, child) {
    return Transform.scale(scale: value, child: child);
  },
  child: const MyWidget(),
);
```

## Explicit Animations

When you need precise control — starting, stopping, reversing, or listening to animation events — explicit animations with `AnimationController` are the right tool.

```dart
_controller.addStatusListener((status) {
  if (status == AnimationStatus.completed) {
    _controller.reverse();
  } else if (status == AnimationStatus.dismissed) {
    _controller.forward();
  }
});
```

### Staggered Animations

Multiple animations can be chained on a single controller using `Interval` curves to create staggered, choreographed sequences.

```dart
final _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4)),
);

final _slideUp = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
  CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.7, curve: Curves.easeOut)),
);
```

## Physics-Based Animations

Sometimes life-like motion requires physics rather than arbitrary curves. Flutter provides `SpringSimulation` and the `AnimationPhysics` system for simulating spring dynamics, friction, and gravity.

```dart
_controller.animateWith(
  SpringSimulation(
    const SpringDescription(mass: 1.0, stiffness: 500.0, damping: 20.0),
    0.0, // start
    1.0, // end
    0.0, // initial velocity
  ),
);
```

## Hero Animations

The `Hero` widget creates the iconic "shared element transition" — an element that appears to fly from one screen to another during navigation.

```dart
// On the source screen:
Hero(
  tag: 'article-image-\${article.id}',
  child: Image.network(article.urlToImage!),
);

// On the destination screen:
Hero(
  tag: 'article-image-\${article.id}',
  child: Image.network(article.urlToImage!),
);
```

The tags must match, and Flutter handles the rest automatically, morphing the widget's position, size, and shape across the route transition.

## Custom Page Transitions

`PageRouteBuilder` lets you define fully custom transitions for screen navigation.

```dart
Navigator.push(context, PageRouteBuilder(
  transitionDuration: const Duration(milliseconds: 500),
  pageBuilder: (_, __, ___) => const DetailScreen(),
  transitionsBuilder: (_, animation, __, child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      child: child,
    );
  },
));
```

## Performance Tips

- Always use `const` widgets inside animated builders to minimize rebuilds.
- Prefer `RepaintBoundary` around expensive widgets that animate to avoid full tree repaints.
- Use `AnimatedBuilder` instead of `setState` to rebuild only the animated portion of the tree.
- Profile with Flutter DevTools' **Performance** tab to identify jank-causing animation paths.

## Conclusion

Flutter's animation system is as expressive as the imagination of the developer wielding it. From the simplicity of `AnimatedContainer` to the precision of physics simulations and the delight of hero transitions, every tool you need to create world-class motion is already in the framework. Invest in learning the animation layer — your users will feel the difference even if they cannot name it.
''',
        ),
        ArticleEntity(
          id: 6,
          author: 'Diana Prince',
          title: 'Securing Your Flutter App',
          description:
              'Essential security practices for Flutter apps — certificate pinning, secure storage, obfuscation, and protecting sensitive user data in production.',
          url: 'https://example.com/flutter-security',
          urlToImage:
              'https://images.unsplash.com/photo-1510511233702-b8f4e8e5e2b2',
          publishedAt: '2024-05-25T16:00:00Z',
          content: '''# Securing Your Flutter App

Security is not a feature to add at the end of a project — it is a discipline woven into every decision from architecture to deployment. Flutter apps run on end-user devices, operate over networks, and often handle sensitive personal and financial data. A single vulnerability can destroy user trust, trigger regulatory penalties, and sink a company. In this guide, we cover the most critical security practices every Flutter developer must know.

## 1. Secure Local Storage

The most common mistake developers make is storing sensitive data — tokens, passwords, PINs, API keys — in shared preferences or local files without encryption. Flutter's `SharedPreferences` package stores data as plaintext. An attacker with filesystem access on a rooted device can trivially read it.

### Use `flutter_secure_storage`

```dart
final storage = const FlutterSecureStorage();

// Write
await storage.write(key: 'auth_token', value: token);

// Read
final token = await storage.read(key: 'auth_token');

// Delete
await storage.delete(key: 'auth_token');
```

On iOS, this uses the Keychain. On Android, it uses the Android Keystore system, which can bind keys to hardware security modules on compatible devices.

## 2. Certificate Pinning

Man-in-the-middle (MITM) attacks intercept network traffic by presenting a forged certificate that the device's trust store accepts. Certificate pinning defeats this by instructing the client to only trust a specific certificate or public key, regardless of what the system trust store says.

```dart
// Using Dio with a custom interceptor:
(_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
  final client = HttpClient();
  client.badCertificateCallback = (cert, host, port) {
    const expectedSha256 = 'YOUR_CERT_HASH_HERE';
    final certHash = sha256.convert(cert.der).toString();
    return certHash != expectedSha256; // true = reject
  };
  return client;
};
```

## 3. Obfuscation and Code Protection

Dart compiles to native code, but the resulting binaries can still be reverse-engineered using tools like Blutter on ARM binaries. Flutter's `--obfuscate` flag renames classes, methods, and fields to meaningless identifiers before compilation.

```bash
flutter build apk --obfuscate --split-debug-info=build/symbols/
```

Store the split debug info securely — you will need it to symbolicate crash reports from tools like Firebase Crashlytics.

## 4. Protecting API Keys

Never embed API keys in your source code or shipped binary. Even obfuscated binaries can be decompiled. Instead:

- Use a backend proxy: your app calls your server, which holds the API key and calls the third-party service.
- For keys that must be on-device (e.g., map SDK keys), use platform-specific secure embedding (`Info.plist` on iOS, Gradle's `local.properties` or secure build configs on Android) and restrict key usage by bundle ID or certificate fingerprint in the provider's dashboard.

## 5. Root and Jailbreak Detection

Apps handling financial transactions or health data should detect compromised environments. The `flutter_jailbreak_detection` package provides basic checks.

```dart
final isJailbroken = await FlutterJailbreakDetection.jailbroken;
if (isJailbroken) {
  // Warn user or restrict features
}
```

These checks are not foolproof — sophisticated rootkits can hide their presence — but they raise the bar for casual attackers.

## 6. Biometric Authentication

Use biometrics to protect sensitive app sections, not just to replace passwords. The `local_auth` package provides fingerprint and face unlock support.

```dart
final authenticated = await auth.authenticate(
  localizedReason: 'Authenticate to view your saved articles',
  options: const AuthenticationOptions(biometricOnly: true),
);
```

## 7. Prevent Screenshot / Screen Recording

For apps that display sensitive content (banking, healthcare), prevent screenshots on Android with:

```kotlin
// In MainActivity.kt
window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
```

## 8. Input Validation

Never trust data coming from users or external APIs. Validate, sanitize, and escape inputs before rendering or persisting them. This is especially critical when rendering user-supplied content in a `WebView` or when constructing SQL queries manually.

## 9. Dependency Auditing

Third-party packages are attack vectors. Regularly audit your `pubspec.lock` for known vulnerabilities using `dart pub audit` (when available) or manual review. Prefer packages with stable release histories, active maintenance, and reputable publishers.

## 10. Transport Security

Always use HTTPS. Never allow cleartext HTTP in production. On Android, add a `network_security_config.xml` that disables cleartext traffic, and on iOS ensure `NSAllowsArbitraryLoads` is `false` in `Info.plist`.

## Conclusion

Security is a posture, not a product. No single technique makes an app secure, but a layered approach — secure storage, pinned certificates, obfuscation, runtime checks, and disciplined dependency management — dramatically reduces the attack surface. Build security in from the start, threat-model your features before you ship them, and stay current with platform-level security advisories. Your users' trust depends on it.
''',
        ),
        ArticleEntity(
          id: 7,
          author: 'Ethan Hunt',
          title: 'Testing Flutter Applications',
          description:
              'Unit, widget, and integration testing for robust Flutter apps — a practical guide to testing philosophy, tooling, and patterns that scale.',
          url: 'https://example.com/flutter-testing',
          urlToImage:
              'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
          publishedAt: '2024-05-26T08:30:00Z',
          content: '''# Testing Flutter Applications

Shipping code without tests is like driving at night without headlights. You might reach your destination, but the risks are enormous and every bump in the road is a surprise. A well-tested Flutter application is one you can refactor confidently, deploy fearlessly, and hand off to a new teammate without a wall of verbal documentation. This guide covers the full testing spectrum: unit, widget, and integration tests.

## The Testing Pyramid

The testing pyramid is a mental model for balancing test investment:

```
        /\\
       /  \\
      / E2E \\         ← Few, slow, fragile
     /--------\\
    /  Widget  \\      ← Some, medium speed
   /------------\\
  /    Unit      \\   ← Many, fast, cheap
 /--------------\\
```

Write many unit tests, a reasonable number of widget tests, and a small but critical set of integration (end-to-end) tests.

## Unit Testing

Unit tests verify the smallest pieces of logic in isolation. In Clean Architecture, use cases and repositories are ideal candidates because they contain pure business logic with injectable dependencies.

### Testing a Use Case

```dart
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetArticleUseCase useCase;
  late MockArticleRepository mockRepo;

  setUp(() {
    mockRepo = MockArticleRepository();
    useCase = GetArticleUseCase(mockRepo);
  });

  test('returns DataSuccess when repository succeeds', () async {
    when(() => mockRepo.getNewsArticles())
        .thenAnswer((_) async => const DataSuccess(mockArticles));

    final result = await useCase();

    expect(result, isA<DataSuccess<List<ArticleEntity>>>());
    verify(() => mockRepo.getNewsArticles()).called(1);
  });

  test('returns DataFailed when repository throws', () async {
    when(() => mockRepo.getNewsArticles())
        .thenAnswer((_) async => DataFailed(DioException(...)));

    final result = await useCase();

    expect(result, isA<DataFailed>());
  });
}
```

### Testing a Bloc

`bloc_test` provides a `blocTest` utility that dramatically simplifies testing Blocs:

```dart
blocTest<RemoteArticlesBloc, RemoteArticlesState>(
  'emits [RemoteArticlesLoading, RemoteArticlesDone] when GetArticles fires on success',
  build: () {
    when(() => mockUseCase()).thenAnswer((_) async => const DataSuccess(mockArticles));
    return RemoteArticlesBloc(mockUseCase);
  },
  act: (bloc) => bloc.add(const GetArticles()),
  expect: () => [isA<RemoteArticlesLoading>(), isA<RemoteArticlesDone>()],
);
```

## Widget Testing

Widget tests run in a simulated Flutter environment without a physical device. They test that UI components render correctly and respond to user interactions.

```dart
testWidgets('ArticleWidget displays title', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ArticleWidget(article: mockArticle),
    ),
  );

  expect(find.text(mockArticle.title!), findsOneWidget);
});

testWidgets('Tapping save FAB triggers SaveArticle event', (tester) async {
  final bloc = MockLocalArticleBloc();

  await tester.pumpWidget(
    BlocProvider<LocalArticleBloc>.value(
      value: bloc,
      child: MaterialApp(home: ArticleDetailsView(article: mockArticle)),
    ),
  );

  await tester.tap(find.byType(FloatingActionButton));
  verify(() => bloc.add(SaveArticle(mockArticle))).called(1);
});
```

### Key Widget Test APIs

| API | Purpose |
|---|---|
| `tester.pump()` | Trigger a single frame |
| `tester.pumpAndSettle()` | Pump until all animations complete |
| `tester.tap()` | Simulate a tap gesture |
| `tester.enterText()` | Type text into a widget |
| `find.byType()` | Locate widgets by type |
| `find.byKey()` | Locate widgets by key |
| `find.text()` | Locate widgets by displayed text |

## Integration Testing

Integration tests run on a real device or emulator and test the full application or large feature slices.

```dart
// integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('User can save and view an article', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap the first article
    await tester.tap(find.byType(ArticleWidget).first);
    await tester.pumpAndSettle();

    // Tap save
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Navigate to saved articles
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pumpAndSettle();

    expect(find.byType(ArticleWidget), findsAtLeastNWidgets(1));
  });
}
```

## Golden Tests

Golden tests capture a screenshot of a widget and compare it against a stored reference image, catching unintended visual regressions.

```bash
flutter test --update-goldens  # Capture baseline
flutter test                   # Compare against baseline
```

## Test Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

Aim for high coverage in the domain and data layers, and meaningful coverage in the presentation layer. Avoid chasing 100% coverage for its own sake — focus on testing behaviors, not lines.

## Conclusion

Testing is an investment that pays compound interest. Start with unit tests for your domain logic, add widget tests for critical UI components, and grow your integration test suite around the most important user journeys. A robust test suite is not a constraint on velocity — it is an accelerator, letting you merge with confidence and refactor without fear.
''',
        ),
        ArticleEntity(
          id: 8,
          author: 'Fiona Gallagher',
          title: 'Flutter Performance Optimization',
          description:
              'Identify and eliminate performance bottlenecks in Flutter apps — from build method optimization to raster jank and memory leaks.',
          url: 'https://example.com/flutter-performance',
          urlToImage:
              'https://images.unsplash.com/photo-1454165833267-3d7f1fbc5a2c',
          publishedAt: '2024-05-27T13:10:00Z',
          content: '''# Flutter Performance Optimization

Performance is a feature. No amount of beautiful design compensates for an app that drops frames, stutters on scroll, or keeps users waiting. Flutter gives developers powerful tools to understand and fix performance issues, but you have to know where to look. This article walks through the diagnostic workflow and the most impactful optimization techniques.

## Understanding Flutter's Rendering Pipeline

Flutter uses a three-thread model:
- **UI thread**: Runs Dart code, builds the widget tree, and computes layout.
- **Raster thread**: Takes the layer tree from the UI thread and rasterizes it using Impeller or Skia.
- **Platform thread**: Handles native platform events and plugin calls.

Jank occurs when *either* the UI or Raster thread takes longer than ~16ms to complete a frame (for 60fps) or ~8ms (for 120fps). Understanding which thread is the bottleneck determines which optimization to apply.

## Profiling with Flutter DevTools

Never optimize without data. The **Performance** tab in Flutter DevTools shows frame rendering timelines, build counts, and widget rebuild frequency.

```bash
flutter run --profile
```

> Always profile with `--profile` builds, never `--debug`. Debug mode intentionally disables optimizations to assist development.

### Key DevTools Views

- **Frame chart**: Green bars (UI thread) and blue bars (Raster thread). Bars over the 16ms line indicate jank.
- **Widget rebuild tracker**: Shows how many times each widget rebuilds per second. Unexpectedly high counts indicate misplaced `setState` calls.
- **Memory tab**: Track heap allocations and identify memory leaks from retained objects.

## Common UI Thread Issues

### 1. Excessive Widget Rebuilds

Every `setState` call rebuilds the widget and all of its descendants. Isolate state to the smallest possible subtree.

```dart
// ❌ Bad: setState at the top of the tree rebuilds everything
class MyPage extends StatefulWidget { ... }

// ✅ Good: Isolate state to just the changing widget
class CounterWidget extends StatefulWidget { ... }
```

### 2. Expensive `build` Methods

Avoid heavy computation inside `build`. Pre-compute values in `initState` or use `useMemoized` when using Flutter Hooks.

```dart
// ❌ Bad: Sorting a list on every build
final sorted = articles.sorted((a, b) => a.publishedAt!.compareTo(b.publishedAt!));

// ✅ Good: Sort once when data changes
late final List<ArticleEntity> sorted;

@override
void initState() {
  super.initState();
  sorted = [...widget.articles]..sort((a, b) => a.publishedAt!.compareTo(b.publishedAt!));
}
```

### 3. Avoid `Opacity` for Fading

`Opacity` creates an offscreen layer. For simple fades, use `AnimatedOpacity` or a color with an alpha component instead.

## Common Raster Thread Issues

### 1. Cache Images

Decoding large images is expensive. Use `cached_network_image` to decode once and cache the result.

### 2. `RepaintBoundary`

Wrapping expensive, infrequently-changing subtrees with `RepaintBoundary` isolates them from repaints triggered by their siblings.

```dart
RepaintBoundary(
  child: HeavyChartWidget(data: chartData),
);
```

### 3. Clip Operations

`ClipRRect`, `ClipPath`, and similar widgets trigger expensive rasterization. Use them sparingly and consider decoration-based alternatives.

### 4. Shader Compilation Jank

With Skia, complex shaders compiled at runtime cause one-time stutters. Impeller eliminates this by pre-compiling shaders. If you are still on Skia for any target, use `--bundle-sksl-path` to pre-warm the shader cache.

## List Performance

`ListView.builder` is crucial for long lists — it lazily builds only the visible items. Never use `ListView` with a large `children` array.

```dart
ListView.builder(
  itemCount: articles.length,
  itemBuilder: (context, index) => ArticleWidget(article: articles[index]),
);
```

For complex, mixed-content feeds, `CustomScrollView` with `SliverList` gives maximum control over the scroll physics and item lifecycle.

## Memory Management

- Dispose `AnimationController`, `StreamSubscription`, and `TextEditingController` in `dispose()`.
- Use `AutoDispose` providers in Riverpod to automatically clean up state when it is no longer observed.
- Avoid large `List.generate` calls that allocate many objects at once in hot paths.

## Reducing App Size

Smaller apps install faster, get deleted less, and load quicker.

```bash
flutter build apk --split-per-abi
flutter build appbundle
```

Use Android App Bundle format (`.aab`) for Play Store uploads — the store delivers only the ABI-specific binary to each device.

## Conclusion

Flutter performance optimization is a combination of measurement, architectural discipline, and strategic use of the framework's built-in tools. Profile first, optimize second. The biggest wins typically come from reducing unnecessary widget rebuilds, caching expensive computations, and isolating repaint boundaries. Build with performance in mind from the start, and your users will never have to notice — because the app will simply feel fast.
''',
        ),
        ArticleEntity(
          id: 9,
          author: 'George Miller',
          title: 'Responsive UI with Flutter',
          description:
              'Building Flutter apps that look and feel great on any screen size — adaptive layouts, breakpoints, and platform-aware design patterns.',
          url: 'https://example.com/flutter-responsive',
          urlToImage:
              'https://images.unsplash.com/photo-1555066931-4365d14bab8c',
          publishedAt: '2024-05-28T10:50:00Z',
          content: '''# Responsive UI with Flutter

Flutter's promise of "one codebase, any screen" is only fulfilled when developers deliberately design for the spectrum of screen sizes, densities, and interaction paradigms that modern devices present. A news app that looks polished on a Pixel 7 might be a disaster on a foldable, an iPad, or a desktop browser. This article explains how to build truly responsive and adaptive UIs in Flutter.

## Responsive vs Adaptive

These terms are often used interchangeably, but they represent different strategies:

- **Responsive**: The layout fluidly adjusts its dimensions to the available space (e.g., a grid that shows 2 columns on small screens and 4 on large ones).
- **Adaptive**: The UI presents fundamentally different experiences on different platforms (e.g., a bottom navigation bar on mobile, a sidebar rail on desktop).

Most production apps need both.

## Getting Screen Dimensions

```dart
final size = MediaQuery.sizeOf(context);
final width = size.width;
final height = size.height;
```

> Prefer `MediaQuery.sizeOf(context)` over `MediaQuery.of(context).size` — it subscribes to size changes only, reducing unnecessary rebuilds.

## Breakpoints

Define semantic breakpoints that match your design system:

```dart
abstract class Breakpoints {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;
}

bool get isCompact => width < Breakpoints.compact;
bool get isMedium => width >= Breakpoints.compact && width < Breakpoints.medium;
bool get isExpanded => width >= Breakpoints.medium;
```

## `LayoutBuilder`

`LayoutBuilder` provides the parent's constraints at build time, making it the ideal tool for responsive widget decisions:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return const MobileArticleList();
    } else if (constraints.maxWidth < 1200) {
      return const TabletArticleGrid();
    } else {
      return const DesktopArticleLayout();
    }
  },
);
```

## Responsive Grids

`GridView.builder` with `SliverGridDelegateWithMaxCrossAxisExtent` creates grids that automatically adjust column count based on available width:

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 300.0,
    crossAxisSpacing: 16.0,
    mainAxisSpacing: 16.0,
    childAspectRatio: 0.75,
  ),
  itemCount: articles.length,
  itemBuilder: (context, index) => ArticleCard(article: articles[index]),
);
```

A `maxCrossAxisExtent` of 300 means the grid shows 1 column on a 300px-wide phone, 2 on a 600px tablet, and 4 on a 1200px desktop.

## Adaptive Navigation

Material 3's `NavigationBar`, `NavigationRail`, and `NavigationDrawer` can be swapped based on screen width:

```dart
Scaffold(
  body: Row(
    children: [
      if (!isCompact) NavigationRail(destinations: _destinations),
      Expanded(child: _currentPage),
    ],
  ),
  bottomNavigationBar: isCompact
      ? NavigationBar(destinations: _destinations)
      : null,
);
```

## Text Scaling

Respect the user's system font size settings. Avoid overriding `textScaler` unless absolutely necessary for layout reasons. Test your app at 200% text scale to ensure nothing overflows or clips.

## Safe Areas and Notches

`SafeArea` ensures content is not obscured by notches, status bars, or system UI:

```dart
SafeArea(
  child: Scaffold(
    body: MyContentWidget(),
  ),
);
```

For custom headers or drawers, use `MediaQuery.paddingOf(context)` to manually account for system UI insets.

## Platform-Aware Widgets

Flutter provides Cupertino widgets for iOS-style UI. Use `Platform.isIOS` or the `adaptive` constructors exposed by packages like `flutter_platform_widgets` to deliver platform-native experiences:

```dart
switch (defaultTargetPlatform) {
  case TargetPlatform.iOS:
    return const CupertinoActivityIndicator();
  default:
    return const CircularProgressIndicator.adaptive();
}
```

## `flutter_adaptive_scaffold`

For complex adaptive layouts, the official `flutter_adaptive_scaffold` package provides Material 3-compliant adaptive scaffolds that handle navigation transitions between breakpoints automatically.

## Testing Responsiveness

Use the Flutter DevTools **Widget Inspector** to inspect layout at various sizes. Write golden tests at multiple `MediaQueryData` configurations to catch regressions:

```dart
testWidgets('shows navigation rail on wide screen', (tester) async {
  tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
  await tester.pumpWidget(const MyApp());
  expect(find.byType(NavigationRail), findsOneWidget);
});
```

## Conclusion

Building for one screen size is building for one user. A genuine commitment to responsive and adaptive design means every user — on a budget Android phone, a high-end iPhone, a folding tablet, or a desktop browser — has an experience tailored to their context. In Flutter, the tools to achieve this are built into the framework. Use them consistently, test across a range of form factors, and ship an app that truly earns the "one codebase, any screen" promise.
''',
        ),
        ArticleEntity(
          id: 10,
          author: 'Hannah Abbott',
          title: "Dart 3.0: What's New?",
          description:
              'Exploring patterns, records, and class modifiers in Dart 3.0 — a comprehensive guide to the language features reshaping modern Dart development.',
          url: 'https://example.com/dart-3',
          urlToImage:
              'https://images.unsplash.com/photo-1484417894907-623942c8ee29',
          publishedAt: '2024-05-29T15:00:00Z',
          content: r'''# Dart 3.0: What's New?

Dart 3.0 is one of the most significant releases in the language's history. It introduced a wave of features that modernize Dart's type system, expressiveness, and safety guarantees — while maintaining the fast compilation and excellent tooling that developers have come to rely on. This article provides a thorough tour of everything new in Dart 3.0.

## Sound Null Safety — Fully Enforced

Null safety was first introduced as opt-in in Dart 2.12. Dart 3.0 makes it mandatory. Every package and application must be fully null-safe. This means:

- No more `null is T` surprises at runtime
- The analyzer catches null-related bugs at compile time
- The type system is more expressive — `String` is always non-null, `String?` is explicitly nullable

If you are migrating pre-3.0 code, use `dart migrate` to automatically upgrade most of your files.

## Records

Records are one of the most requested features in Dart. They are anonymous, immutable, fixed-size composite types that bundle multiple values together without requiring a named class.

```dart
// Creating a record
final point = (3.0, 4.0); // Positional fields
final person = (name: 'Alice', age: 30); // Named fields

// Destructuring
final (x, y) = point;
final (:name, :age) = person;
print('$name is $age years old at ($x, $y)');
```

Records are particularly useful for returning multiple values from a function without the ceremony of a dedicated class:

```dart
(String, int) getUserInfo() => ('Alice', 30);

final (name, age) = getUserInfo();
```

Records are value types — two records with the same shape and values are equal, and they produce the same hash code. They also work seamlessly with pattern matching.

## Patterns

Patterns are the single most expressive feature added in Dart 3.0. They appear in variable declarations, switch statements, switch expressions, and for loops, enabling concise destructuring and matching.

### Variable Patterns

```dart
final [a, b, ...rest] = [1, 2, 3, 4, 5];
// a = 1, b = 2, rest = [3, 4, 5]
```

### Switch Expressions

Switch is now an *expression*, not just a statement, meaning it can be used inline and must be exhaustive.

```dart
final description = switch (statusCode) {
  200 => 'OK',
  404 => 'Not Found',
  500 => 'Server Error',
  _ => 'Unknown',
};
```

### Object Patterns

```dart
sealed class Shape {}
class Circle extends Shape { final double radius; Circle(this.radius); }
class Rectangle extends Shape { final double width, height; Rectangle(this.width, this.height); }

double area(Shape shape) => switch (shape) {
  Circle(:var radius) => 3.14 * radius * radius,
  Rectangle(:var width, :var height) => width * height,
};
```

The compiler enforces exhaustiveness — if you add a new subclass of `Shape` without updating the switch, you get a compile error.

## Sealed Classes

`sealed` classes are a key companion to exhaustive pattern matching. A sealed class can only be extended or implemented within the same library (file). This gives the Dart analyzer complete knowledge of all possible subtypes.

```dart
sealed class Result<T> {}
class Success<T> extends Result<T> { final T data; Success(this.data); }
class Failure<T> extends Result<T> { final Exception error; Failure(this.error); }

// The compiler knows Success and Failure are the only subtypes:
String describe(Result<int> result) => switch (result) {
  Success(:var data) => 'Got $data',
  Failure(:var error) => 'Error: $error',
};
```

## Class Modifiers

Dart 3.0 introduces six class modifiers that give library authors precise control over how their types can be used:

| Modifier | Can extend | Can implement | Can mix in | Can be constructed |
|---|---|---|---|---|
| *(none)* | ✅ | ✅ | ❌ | ✅ |
| `abstract` | ✅ | ✅ | ❌ | ❌ |
| `base` | ✅ | ❌ | ❌ | ✅ |
| `interface` | ❌ | ✅ | ❌ | ✅ |
| `final` | ❌ | ❌ | ❌ | ✅ |
| `sealed` | ✅ | ✅ | ❌ | ❌ (in same file only) |
| `mixin` | ❌ | ✅ | ✅ | ❌ |

These modifiers enforce API contracts that were previously only documentable in comments.

## Enhanced `switch` and Guards

Pattern matching in switch now supports **guards** — additional boolean conditions on a case:

```dart
switch (article) {
  case ArticleEntity(:var wordCount) when wordCount > 1000:
    print('Long read');
  case ArticleEntity(:var wordCount) when wordCount > 500:
    print('Medium read');
  default:
    print('Short read');
}
```

## Breaking Changes

Dart 3.0 is a major version with breaking changes:

- Null safety is now mandatory — packages that have not migrated will not compile.
- The `>>` operator is now parsed correctly without spaces (no more `List<List<int>>` ambiguity).
- The `mixin` keyword now requires explicit `mixin` declaration; classes are no longer implicitly usable as mixins.

## Upgrading

```bash
# Check compatibility
dart pub outdated

# Upgrade SDK constraint in pubspec.yaml
environment:
  sdk: '>=3.0.0 <4.0.0'

# Run the migrator if needed
dart migrate
```

## Conclusion

Dart 3.0 is a mature, modern language that has closed many of the expressiveness gaps compared to languages like Kotlin and Swift. Records and patterns alone transform how you model data and write logic. Sealed classes and exhaustive switches eliminate entire categories of runtime errors. Class modifiers give library authors the API control they have always needed. Whether you are starting a new Flutter project or upgrading an existing one, Dart 3.0 is the version to standardize on. The future of Dart is bright, typed, and null-safe.
''',
        ),
      ],
    );
    //return _articleRepository.getSavedArticles();
  }
}
