# Performance Demo - Dart vs Rust FFI

A beautiful Flutter application demonstrating real-world performance comparisons between pure Dart and Rust via FFI.

## Features

### Performance Benchmarks

1. **Quicksort** - Sort 50,000 random integers
2. **Prime Generation** - Generate prime numbers up to 100,000
3. **SHA-256 Hashing** - Cryptographic hash computation
4. **Fibonacci Sequence** - Calculate large Fibonacci numbers
5. **Matrix Multiplication** - Multiply 100x100 matrices
6. **JSON Parsing** - Parse and manipulate complex JSON data
7. **Text Analysis** - Word count and statistics
8. **Pi Calculation** - Monte Carlo method with 1M iterations
9. **RLE Compression** - Run-length encoding compression

### Architecture

This app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                  # Core utilities
│   ├── di/               # Dependency injection
│   └── theme/            # App theming
├── data/                 # Data layer
│   ├── datasources/      # Data sources (Dart & Rust)
│   └── repositories/     # Repository implementations
├── domain/               # Business logic layer
│   ├── entities/         # Domain models
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business use cases
└── presentation/         # UI layer
    ├── pages/            # Screen pages
    ├── widgets/          # Reusable widgets
    └── providers/        # State management
```

### Design Principles

- **Single Responsibility Principle** - Each class has one reason to change
- **Open/Closed Principle** - Open for extension, closed for modification
- **Liskov Substitution Principle** - Interfaces define contracts
- **Interface Segregation Principle** - Specific, focused interfaces
- **Dependency Inversion Principle** - Depend on abstractions, not concretions

### Technologies Used

- **Flutter** - Cross-platform UI framework
- **Rust** - High-performance backend via FFI
- **Riverpod** - State management
- **Google Fonts** - Beautiful typography
- **FL Chart** - Data visualization
- **Clean Architecture** - Maintainable, testable code structure

## Running the App

```bash
cd performance_demo
flutter pub get
flutter run
```

## Results

The app shows real-time performance comparisons with:
- Execution time for both implementations
- Speedup factor (how many times faster Rust is)
- Percentage improvement
- Visual performance bars
- Detailed result preview

## Screenshots

The app features:
- Beautiful gradient app bar
- Modern card-based UI
- Color-coded benchmark categories
- Real-time loading states
- Animated result cards
- Clear performance metrics

## License

This is a demonstration app for the app_core FFI plugin.
