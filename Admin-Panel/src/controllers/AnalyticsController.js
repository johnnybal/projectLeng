const AnalyticsService = require('../services/AnalyticsService');
const { logger } = require('../utils/logger');
const ApiResponse = require('../utils/apiResponse');
const { db } = require('../config/firebase');
const admin = require('firebase-admin');

class AnalyticsController {
    // Get User Engagement Metrics
    async getUserEngagement(req, res) {
        try {
            const { schoolId, startDate, endDate } = req.query;
            
            const metrics = await AnalyticsService.getUserEngagementMetrics(
                schoolId,
                startDate || new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // Default to last 30 days
                endDate || new Date()
            );

            res.json({
                success: true,
                data: metrics
            });
        } catch (error) {
            logger.error('Error in getUserEngagement:', error);
            res.status(500).json({
                success: false,
                error: 'Failed to fetch user engagement metrics'
            });
        }
    }

    // Get Poll Analytics
    async getPollAnalytics(req, res) {
        try {
            const { schoolId, startDate, endDate } = req.query;
            
            const metrics = await AnalyticsService.getPollMetrics(
                schoolId,
                startDate || new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
                endDate || new Date()
            );

            res.json({
                success: true,
                data: metrics
            });
        } catch (error) {
            logger.error('Error in getPollAnalytics:', error);
            res.status(500).json({
                success: false,
                error: 'Failed to fetch poll analytics'
            });
        }
    }

    // Get Retention Metrics
    async getRetentionMetrics(req, res) {
        try {
            const { schoolId, date } = req.query;
            
            const metrics = await AnalyticsService.getRetentionMetrics(
                schoolId,
                date || new Date()
            );

            res.json({
                success: true,
                data: metrics
            });
        } catch (error) {
            logger.error('Error in getRetentionMetrics:', error);
            res.status(500).json({
                success: false,
                error: 'Failed to fetch retention metrics'
            });
        }
    }

    // Get Conversion Metrics
    async getConversionMetrics(req, res) {
        try {
            const { schoolId, startDate, endDate } = req.query;
            
            const metrics = await AnalyticsService.getConversionMetrics(
                schoolId,
                startDate || new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
                endDate || new Date()
            );

            res.json({
                success: true,
                data: metrics
            });
        } catch (error) {
            logger.error('Error in getConversionMetrics:', error);
            res.status(500).json({
                success: false,
                error: 'Failed to fetch conversion metrics'
            });
        }
    }

    // Dashboard overview
    static async getDashboardOverview(req, res) {
        try {
            const db = admin.firestore();
            const now = new Date();
            const thirtyDaysAgo = new Date(now.setDate(now.getDate() - 30));

            // Fetch user metrics
            const usersRef = db.collection('users');
            const totalUsers = (await usersRef.count().get()).data().count;
            
            // Get active users (mock data for now)
            const mockData = {
                dailyActiveUsers: Math.floor(Math.random() * 1000),
                weeklyActiveUsers: Math.floor(Math.random() * 5000),
                monthlyActiveUsers: Math.floor(Math.random() * 10000),
                totalUsers: totalUsers,
                userActivityTrend: Array.from({length: 30}, () => Math.floor(Math.random() * 1000)),
                pollEngagement: {
                    completed: Math.floor(Math.random() * 1000),
                    inProgress: Math.floor(Math.random() * 500),
                    abandoned: Math.floor(Math.random() * 200)
                }
            };

            res.json(mockData);
        } catch (error) {
            console.error('Error fetching dashboard overview:', error);
            res.status(500).json({ error: 'Failed to fetch dashboard data' });
        }
    }

    // User engagement metrics
    static async getEngagementMetrics(req, res) {
        try {
            const { startDate, endDate, schoolId } = req.query;
            
            // Mock engagement data
            const mockData = {
                activeUsers: {
                    daily: Array.from({length: 7}, () => Math.floor(Math.random() * 1000)),
                    weekly: Array.from({length: 4}, () => Math.floor(Math.random() * 5000)),
                    monthly: Array.from({length: 12}, () => Math.floor(Math.random() * 10000))
                },
                sessionDuration: {
                    average: Math.floor(Math.random() * 30) + 10,
                    distribution: {
                        '<5min': Math.floor(Math.random() * 100),
                        '5-15min': Math.floor(Math.random() * 200),
                        '15-30min': Math.floor(Math.random() * 150),
                        '>30min': Math.floor(Math.random() * 50)
                    }
                }
            };

            res.json(mockData);
        } catch (error) {
            console.error('Error fetching engagement metrics:', error);
            res.status(500).json({ error: 'Failed to fetch engagement data' });
        }
    }

    // Poll analytics
    static async getPollMetrics(req, res) {
        try {
            const { startDate, endDate, schoolId } = req.query;
            
            // Mock poll data
            const mockData = {
                totalPolls: Math.floor(Math.random() * 1000),
                completionRate: Math.random() * 100,
                averageTimePerPoll: Math.floor(Math.random() * 300),
                pollTypes: {
                    multiple: Math.floor(Math.random() * 500),
                    rating: Math.floor(Math.random() * 300),
                    openEnded: Math.floor(Math.random() * 200)
                }
            };

            res.json(mockData);
        } catch (error) {
            console.error('Error fetching poll metrics:', error);
            res.status(500).json({ error: 'Failed to fetch poll data' });
        }
    }

    // Retention metrics
    static async getRetentionMetrics(req, res) {
        try {
            const { startDate, endDate, schoolId } = req.query;
            
            // Mock retention data
            const mockData = {
                retentionRates: {
                    day1: Math.random() * 100,
                    day7: Math.random() * 80,
                    day30: Math.random() * 60,
                    day90: Math.random() * 40
                },
                churnRate: Math.random() * 20,
                userLifecycle: {
                    new: Math.floor(Math.random() * 1000),
                    returning: Math.floor(Math.random() * 2000),
                    churned: Math.floor(Math.random() * 500)
                }
            };

            res.json(mockData);
        } catch (error) {
            console.error('Error fetching retention metrics:', error);
            res.status(500).json({ error: 'Failed to fetch retention data' });
        }
    }

    // Conversion metrics
    static async getConversionMetrics(req, res) {
        try {
            const { startDate, endDate, schoolId } = req.query;
            
            // Mock conversion data
            const mockData = {
                signupToActive: Math.random() * 100,
                pollCompletion: Math.random() * 100,
                featureAdoption: {
                    polls: Math.random() * 100,
                    profile: Math.random() * 90,
                    messaging: Math.random() * 80
                },
                conversionFunnel: {
                    viewed: Math.floor(Math.random() * 10000),
                    started: Math.floor(Math.random() * 5000),
                    completed: Math.floor(Math.random() * 2000)
                }
            };

            res.json(mockData);
        } catch (error) {
            console.error('Error fetching conversion metrics:', error);
            res.status(500).json({ error: 'Failed to fetch conversion data' });
        }
    }

    // Time series data
    static async getTimeSeriesData(req, res) {
        try {
            const { metric, startDate, endDate, interval, schoolId } = req.query;
            
            // Generate mock time series data
            const days = Math.floor((new Date(endDate) - new Date(startDate)) / (1000 * 60 * 60 * 24));
            const timeSeriesData = Array.from({length: days}, (_, i) => ({
                date: new Date(new Date(startDate).setDate(new Date(startDate).getDate() + i)).toISOString().split('T')[0],
                value: Math.floor(Math.random() * 1000)
            }));

            res.json(timeSeriesData);
        } catch (error) {
            console.error('Error fetching time series data:', error);
            res.status(500).json({ error: 'Failed to fetch time series data' });
        }
    }
}

module.exports = new AnalyticsController(); 