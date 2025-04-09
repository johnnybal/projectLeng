# LengLeng

A modern social networking platform for school communities, built with SwiftUI and Firebase.

## Project Structure

This repository contains two main components:

1. iOS App (Root directory)
2. Admin Panel (Admin-Panel directory)

## iOS App

### Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+
- Firebase account and configuration

### Features

- Modern SwiftUI-based UI
- Firebase Authentication
- Cloud Firestore for data storage
- Real-time updates and notifications
- School-based social networking
- Polls and engagement features
- Profile management
- Contact integration
- Location services

### Getting Started

1. Clone the repository:
```bash
git clone https://github.com/yourusername/LengLeng.git
cd LengLeng
```

2. Install dependencies:
```bash
xcodegen generate
pod install
```

3. Add your `GoogleService-Info.plist` to the project

4. Open `LengLeng.xcworkspace` in Xcode

5. Build and run the project

### Architecture

- MVVM architecture
- SwiftUI for views
- Combine for reactive programming
- Firebase for backend services

### Key Components

- `Sources/Views`: UI components and screens
- `Sources/ViewModels`: Business logic and data management
- `Sources/Models`: Data models and types
- `Sources/Services`: Network and Firebase integration
- `Sources/Utils`: Helper functions and extensions

## Admin Panel

The admin panel is a Node.js application built with Express and Firebase Admin SDK. For more details, see [Admin-Panel/README.md](Admin-Panel/README.md).

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 