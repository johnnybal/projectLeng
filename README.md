# LengLeng App

LengLeng is a social networking application that connects students within their school communities. The project consists of two main components:

1. iOS Mobile App (Swift)
2. Admin Panel & Backend API (Node.js)

## Project Structure

```
LengLeng/
├── Sources/              # iOS App Source Code
├── Admin-Panel/         # Backend & Admin Dashboard
├── project.yml          # XCode Project Configuration
└── README.md           # This file
```

## Features

### Mobile App
- User Authentication
- School-based Social Networking
- Invitation System
- Real-time Messaging
- Profile Management
- School Verification

### Admin Panel & Backend API
- User Analytics Dashboard
- Engagement Metrics
- Poll Analytics
- School Management
- Invitation System Management
- User Moderation Tools

## Getting Started

### Prerequisites
- iOS 15.0+
- Xcode 13.0+
- Node.js 16.0+
- Firebase Account
- Git

### Setting Up the iOS App

1. Clone the repository:
```bash
git clone https://github.com/yourusername/LengLeng.git
cd LengLeng
```

2. Install dependencies:
```bash
# Install CocoaPods dependencies if using CocoaPods
pod install
```

3. Open the project:
```bash
open LengLeng.xcodeproj
```

4. Add your `GoogleService-Info.plist` to the project

### Setting Up the Backend

1. Navigate to the Admin Panel directory:
```bash
cd Admin-Panel
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Start the development server:
```bash
npm run dev
```

## API Documentation

The backend API documentation can be found in the [Admin-Panel/README.md](Admin-Panel/README.md) file.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Your Name - [@yourusername](https://twitter.com/yourusername)
Project Link: [https://github.com/yourusername/LengLeng](https://github.com/yourusername/LengLeng) 