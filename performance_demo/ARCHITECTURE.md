# Architecture Documentation

## Overview

This application demonstrates a **Clean Architecture** implementation with strict adherence to **SOLID principles**. The architecture separates concerns into distinct layers, making the codebase maintainable, testable, and scalable.

## Layer Structure

```
lib/
├── core/                     # Cross-cutting concerns
│   ├── di/                  # Dependency Injection
│   │   └── injection.dart   # Providers for DI container
│   └── theme/               # UI Theming
│       └── app_theme.dart   # App-wide theme configuration
│
├── domain/                   # Business Logic Layer (Pure Dart)
│   ├── entities/            # Business models
│   │   └── benchmark_result.dart
│   ├── repositories/        # Repository interfaces (abstractions)
│   │   └── benchmark_repository.dart
│   └── usecases/           # Business use cases
│       └── run_benchmark.dart
│
├── data/                    # Data Layer (Implementation)
│   ├── datasources/        # Data sources
│   │   ├── dart_performance_datasource.dart  # Pure Dart implementations
│   │   └── rust_performance_datasource.dart  # Rust FFI implementations
│   └── repositories/       # Repository implementations
│       └── benchmark_repository_impl.dart
│
└── presentation/            # UI Layer
    ├── pages/              # Screen pages
    │   └── home_page.dart
    ├── widgets/            # Reusable UI components
    │   ├── benchmark_button.dart
    │   └── benchmark_card.dart
    └── providers/          # State management
        └── benchmark_provider.dart
```

## SOLID Principles

### 1. Single Responsibility Principle (SRP)
Each class has one and only one reason to change:

- **BenchmarkResult**: Represents benchmark data
- **DartPerformanceDataSource**: Handles pure Dart computations
- **RustPerformanceDataSource**: Handles Rust FFI calls
- **BenchmarkRepositoryImpl**: Coordinates data sources
- **RunBenchmark**: Executes business logic
- **BenchmarkNotifier**: Manages UI state

### 2. Open/Closed Principle (OCP)
Classes are open for extension but closed for modification:

- New benchmark types can be added without modifying existing code
- New data sources can be added by implementing interfaces
- UI components are extensible through composition

### 3. Liskov Substitution Principle (LSP)
Abstractions can be replaced with implementations:

- `BenchmarkRepository` interface can be substituted with any implementation
- Data sources follow consistent contracts
- State management is decoupled from business logic

### 4. Interface Segregation Principle (ISP)
Interfaces are specific and focused:

- `BenchmarkRepository` contains only benchmark-related methods
- Data sources have focused responsibilities
- Use cases are granular and specific

### 5. Dependency Inversion Principle (DIP)
High-level modules don't depend on low-level modules:

- Domain layer has no dependencies on data or presentation layers
- Repository interfaces are defined in the domain layer
- Implementations are injected through providers
- Business logic depends on abstractions, not concretions

## Dependency Flow

```
Presentation Layer (UI)
       ↓
   Use Cases (Business Logic)
       ↓
Repository Interface (Abstraction)
       ↓
Repository Implementation
       ↓
Data Sources (Dart & Rust)
```

## State Management

Uses **Riverpod** for:
- Dependency injection
- State management
- Reactive updates

### Provider Hierarchy:

1. **dynamicLibraryProvider**: Loads native library
2. **dartDataSourceProvider**: Pure Dart implementations
3. **rustDataSourceProvider**: Rust FFI implementations
4. **benchmarkRepositoryProvider**: Repository with both data sources
5. **runBenchmarkProvider**: Business use case
6. **benchmarkProvider**: UI state management

## Design Patterns

### Repository Pattern
Abstracts data layer from business logic, allowing easy swapping of data sources.

### Use Case Pattern
Encapsulates business rules in single-purpose classes.

### Provider Pattern
Manages dependency injection and state.

### Entity Pattern
Pure data models with business logic methods.

### Builder Pattern
Used in UI construction with Flutter widgets.

## Testing Strategy

### Unit Tests
- Domain entities (business logic)
- Use cases (isolated from data sources)
- Data sources (with mocked FFI)

### Integration Tests
- Repository implementations
- End-to-end benchmark flows

### Widget Tests
- UI components
- State changes
- User interactions

## Benefits

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Changes are localized to specific layers
3. **Scalability**: Easy to add new features without affecting existing code
4. **Flexibility**: Data sources can be swapped without changing business logic
5. **Readability**: Clear separation makes code easier to understand
6. **Reusability**: Components can be reused across different features

## Performance Benchmarks Implemented

1. **Quicksort**: Large array sorting
2. **Prime Generation**: Sieve of Eratosthenes
3. **SHA-256**: Cryptographic hashing
4. **Fibonacci**: Sequence generation with memoization
5. **Matrix Multiplication**: Compute-intensive operations
6. **JSON Parsing**: Data serialization/deserialization
7. **Text Analysis**: String processing and statistics
8. **Pi Calculation**: Monte Carlo simulation
9. **RLE Compression**: Data compression algorithm

Each benchmark compares pure Dart implementation against Rust FFI implementation, demonstrating real-world performance differences.
