const admin = require('firebase-admin');
const { logger } = require('../utils/logger');
const path = require('path');

const initializeFirebase = () => {
    try {
        const serviceAccount = require('../../credentials/lengleng-954fc-firebase-adminsdk-fbsvc-8a2826b235.json');
        
        admin.initializeApp({
            credential: admin.credential.cert(serviceAccount),
            storageBucket: "lengleng-954fc.firebasestorage.app"
        });
        
        logger.info('Firebase Admin SDK initialized successfully');
    } catch (error) {
        logger.error('Error initializing Firebase Admin SDK:', error);
        throw error;
    }
};

module.exports = { initializeFirebase, admin }; 