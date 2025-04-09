const express = require('express');
const router = express.Router();
const { admin } = require('../config/firebase');
const { logger } = require('../utils/logger');

// Dashboard Overview
router.get('/dashboard/overview', async (req, res) => {
    try {
        const snapshot = await admin.firestore()
            .collection('analytics')
            .doc('dashboard')
            .get();
        
        const overview = snapshot.exists ? snapshot.data() : {
            totalUsers: 0,
            activeUsers: 0,
            totalPolls: 0,
            responseRate: 0
        };
        
        res.json(overview);
    } catch (error) {
        logger.error('Error fetching dashboard overview:', error);
        res.status(500).json({ error: error.message });
    }
});

// User Engagement
router.get('/user-engagement', async (req, res) => {
    try {
        const snapshot = await admin.firestore()
            .collection('analytics')
            .doc('engagement')
            .get();
        
        const metrics = snapshot.exists ? snapshot.data() : {
            dailyActiveUsers: 0,
            weeklyActiveUsers: 0,
            monthlyActiveUsers: 0,
            averageSessionDuration: 0
        };
        
        res.json(metrics);
    } catch (error) {
        logger.error('Error fetching user engagement:', error);
        res.status(500).json({ error: error.message });
    }
});

// Poll Analytics
router.get('/poll-metrics', async (req, res) => {
    try {
        const snapshot = await admin.firestore()
            .collection('analytics')
            .doc('polls')
            .get();
        
        const analytics = snapshot.exists ? snapshot.data() : {
            totalPolls: 0,
            activePolls: 0,
            completionRate: 0,
            averageResponseTime: 0
        };
        
        res.json(analytics);
    } catch (error) {
        logger.error('Error fetching poll analytics:', error);
        res.status(500).json({ error: error.message });
    }
});

// Retention Analytics
router.get('/retention', async (req, res) => {
    try {
        const snapshot = await admin.firestore()
            .collection('analytics')
            .doc('retention')
            .get();
        
        const retention = snapshot.exists ? snapshot.data() : {
            dayRetention: 0,
            weekRetention: 0,
            monthRetention: 0,
            churnRate: 0
        };
        
        res.json(retention);
    } catch (error) {
        logger.error('Error fetching retention analytics:', error);
        res.status(500).json({ error: error.message });
    }
});

// Conversion Analytics
router.get('/conversion', async (req, res) => {
    try {
        const snapshot = await admin.firestore()
            .collection('analytics')
            .doc('conversion')
            .get();
        
        const conversion = snapshot.exists ? snapshot.data() : {
            registrationRate: 0,
            activationRate: 0,
            pollParticipationRate: 0,
            userRetentionRate: 0
        };
        
        res.json(conversion);
    } catch (error) {
        logger.error('Error fetching conversion analytics:', error);
        res.status(500).json({ error: error.message });
    }
});

module.exports = router; 