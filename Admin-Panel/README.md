# LengLeng Admin Panel

The administrative dashboard for the LengLeng social networking platform, built with Node.js, Express, and Firebase.

## Features

- User Analytics Dashboard
- Engagement Metrics
- Poll Analytics
- School Management
- Invitation System Management
- User Moderation Tools

## Tech Stack

- Node.js
- Express.js
- Firebase Admin SDK
- EJS Templates
- TailwindCSS

## Prerequisites

- Node.js 16.0+
- Firebase Account
- Firebase Admin SDK credentials

## Getting Started

1. Install dependencies:
```bash
npm install
```

2. Set up environment variables:
```bash
cp .env.example .env
```

3. Configure your `.env` file:
```env
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

4. Add Firebase Admin SDK credentials:
- Go to Firebase Console > Project Settings > Service Accounts
- Generate a new private key
- Save as `credentials/firebase-admin-sdk.json`

5. Start the development server:
```bash
npm run dev
```

## Project Structure

```
Admin-Panel/
├── src/
│   ├── config/         # Configuration files
│   ├── controllers/    # Route controllers
│   ├── middleware/     # Express middleware
│   ├── models/         # Data models
│   ├── public/         # Static files
│   ├── routes/         # Route definitions
│   ├── services/       # Business logic
│   ├── utils/          # Utility functions
│   ├── views/          # EJS templates
│   └── server.js       # Entry point
├── credentials/        # Firebase credentials (gitignored)
├── scripts/           # Build and utility scripts
└── package.json
```

## Available Scripts

- `npm run dev`: Start development server with hot reload
- `npm start`: Start production server
- `npm run lint`: Run ESLint
- `npm run check-deps`: Check for MongoDB references (Firebase-only project)

## Security Notes

- Never commit Firebase credentials
- Keep `credentials` directory and `.env` in `.gitignore`
- Regularly rotate Firebase private keys
- Use environment variables for sensitive data

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details. 