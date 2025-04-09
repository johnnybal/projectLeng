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
- User Authentication with Firebase
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

### Firebase Setup (Required)

1. Create a Firebase Project:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Add Project" and follow the setup wizard
   - Enable Google Analytics if needed

2. Configure Firebase Services:
   - Enable Authentication
     - Go to Authentication > Sign-in method
     - Enable Phone Number authentication
   - Set up Firestore Database
     - Go to Firestore Database
     - Create database in your preferred region
     - Start in production mode
   - Set up Storage (for media files)
     - Go to Storage
     - Initialize Cloud Storage

3. Configure iOS App:
   - In Firebase Console:
     - Go to Project Settings > Your Apps
     - Click iOS icon (</>) to register app
     - Download `GoogleService-Info.plist`
     - Place it in the `Sources/` directory
     - Add to Xcode project but DO NOT commit to git

4. Configure Admin Panel:
   - In Firebase Console:
     - Go to Project Settings > Service Accounts
     - Click "Generate New Private Key"
     - Save as `Admin-Panel/credentials/firebase-admin-sdk.json`
     - Add this path to your `.gitignore`

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
```

4. Configure your `.env` file:
```
PORT=3000
NODE_ENV=development

# Firebase Admin SDK
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY="your-private-key"
FIREBASE_CLIENT_EMAIL=your-client-email
FIREBASE_STORAGE_BUCKET=your-storage-bucket

# Session
SESSION_SECRET=your-secret-key-here
```

5. Start the development server:
```bash
npm run dev
```

## API Documentation

The backend API documentation can be found in the [Admin-Panel/README.md](Admin-Panel/README.md) file.

## Security Notes

- Never commit Firebase credentials to version control
- Keep your `credentials` directory and `.env` file in `.gitignore`
- Regularly rotate your Firebase private keys
- Use environment variables for all sensitive configuration

## Troubleshooting

### Common Issues:

1. **Firebase Authentication Failed**:
   - Verify your Firebase credentials are correctly placed
   - Check if your environment variables match your Firebase project settings
   - Ensure your Firebase project has the necessary services enabled

2. **Port Already in Use**:
   - Check if another instance is running on port 3000
   - Kill existing Node.js processes: `pkill -f node`
   - Or change the port in `.env`

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