const express = require('express');
const router = express.Router();
const AnalyticsController = require('../controllers/AnalyticsController');

// Dashboard Overview
router.get('/dashboard/overview', AnalyticsController.getDashboardOverview);

// User Engagement
router.get('/engagement/metrics', AnalyticsController.getEngagementMetrics);

// Poll Metrics
router.get('/polls/metrics', AnalyticsController.getPollMetrics);

// Retention Analysis
router.get('/retention/metrics', AnalyticsController.getRetentionMetrics);

// Conversion Tracking
router.get('/conversion/metrics', AnalyticsController.getConversionMetrics);

// Time Series Data
router.get('/timeseries', AnalyticsController.getTimeSeriesData);

module.exports = router; 