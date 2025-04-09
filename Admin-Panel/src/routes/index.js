const express = require('express');
const { admin } = require('../config/firebase');
const AnalyticsController = require('../controllers/AnalyticsController');
const invitationRoutes = require('./invitation');
const analyticsRoutes = require('./analytics');

const router = express.Router();

// Home page
router.get('/', (req, res) => {
    res.render('dashboard/index', { 
        title: 'Dashboard',
        currentPage: 'dashboard'
    });
});

// Test route for Firebase connection
router.get('/test', async (req, res) => {
    try {
        // Try to list users (limited to 1 just for testing)
        const listUsersResult = await admin.auth().listUsers(1);
        res.json({
            success: true,
            message: 'Firebase connection successful',
            userCount: listUsersResult.users.length
        });
    } catch (error) {
        console.error('Error testing Firebase connection:', error);
        res.status(500).json({
            success: false,
            message: 'Firebase connection failed',
            error: error.message
        });
    }
});

// Analytics Routes
router.get('/analytics/engagement', AnalyticsController.getUserEngagement);
router.get('/analytics/polls', AnalyticsController.getPollAnalytics);
router.get('/analytics/retention', AnalyticsController.getRetention);
router.get('/analytics/conversion', AnalyticsController.getConversion);
router.get('/analytics/dashboard', AnalyticsController.getDashboardOverview);

// API Routes
router.use('/api/invitation', invitationRoutes);

// Admin Panel Routes
router.get('/engagement', (req, res) => {
    res.render('engagement/index', {
        title: 'User Engagement',
        currentPage: 'engagement'
    });
});

router.get('/polls', (req, res) => {
    res.render('polls/index', {
        title: 'Poll Metrics',
        currentPage: 'polls'
    });
});

router.get('/retention', (req, res) => {
    res.render('retention/index', {
        title: 'Retention Analysis',
        currentPage: 'retention'
    });
});

router.get('/conversion', (req, res) => {
    res.render('conversion/index', {
        title: 'Conversion Tracking',
        currentPage: 'conversion'
    });
});

// Test Routes
router.get('/api/test', (req, res) => {
    res.json({ message: 'Firebase connection test successful' });
});

// Mount analytics routes
router.use('/api/analytics', analyticsRoutes);

module.exports = router; 