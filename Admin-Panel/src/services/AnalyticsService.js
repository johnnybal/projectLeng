const moment = require('moment');
const admin = require('firebase-admin');
const { logger } = require('../utils/logger');

class AnalyticsService {
    // User Engagement Metrics
    async getUserEngagementMetrics(schoolId, startDate, endDate) {
        try {
            const db = admin.firestore();
            const userActivitiesRef = db.collection('user_activities');
            
            const startTimestamp = admin.firestore.Timestamp.fromDate(new Date(startDate));
            const endTimestamp = admin.firestore.Timestamp.fromDate(new Date(endDate));
            
            let query = userActivitiesRef
                .where('timestamp', '>=', startTimestamp)
                .where('timestamp', '<=', endTimestamp);
                
            if (schoolId) {
                query = query.where('schoolId', '==', schoolId);
            }

            // Calculate DAU
            const dayStart = moment().startOf('day');
            const dayEnd = moment().endOf('day');
            const dauSnapshot = await userActivitiesRef
                .where('timestamp', '>=', admin.firestore.Timestamp.fromDate(dayStart.toDate()))
                .where('timestamp', '<=', admin.firestore.Timestamp.fromDate(dayEnd.toDate()))
                .get();
            const dauUsers = new Set();
            dauSnapshot.forEach(doc => dauUsers.add(doc.data().userId));

            // Calculate WAU
            const weekStart = moment().startOf('week');
            const weekEnd = moment().endOf('week');
            const wauSnapshot = await userActivitiesRef
                .where('timestamp', '>=', admin.firestore.Timestamp.fromDate(weekStart.toDate()))
                .where('timestamp', '<=', admin.firestore.Timestamp.fromDate(weekEnd.toDate()))
                .get();
            const wauUsers = new Set();
            wauSnapshot.forEach(doc => wauUsers.add(doc.data().userId));

            // Calculate MAU
            const monthStart = moment().startOf('month');
            const monthEnd = moment().endOf('month');
            const mauSnapshot = await userActivitiesRef
                .where('timestamp', '>=', admin.firestore.Timestamp.fromDate(monthStart.toDate()))
                .where('timestamp', '<=', admin.firestore.Timestamp.fromDate(monthEnd.toDate()))
                .get();
            const mauUsers = new Set();
            mauSnapshot.forEach(doc => mauUsers.add(doc.data().userId));

            return {
                dau: dauUsers.size,
                wau: wauUsers.size,
                mau: mauUsers.size
            };
        } catch (error) {
            logger.error('Error getting user engagement metrics:', error);
            throw error;
        }
    }

    // Poll Participation Metrics
    async getPollMetrics(schoolId, startDate, endDate) {
        try {
            const db = admin.firestore();
            const pollAnalyticsRef = db.collection('poll_analytics');
            
            const startTimestamp = admin.firestore.Timestamp.fromDate(new Date(startDate));
            const endTimestamp = admin.firestore.Timestamp.fromDate(new Date(endDate));
            
            let query = pollAnalyticsRef
                .where('startTime', '>=', startTimestamp)
                .where('startTime', '<=', endTimestamp);
                
            if (schoolId) {
                query = query.where('schoolId', '==', schoolId);
            }

            const snapshot = await query.get();
            
            let totalPolls = 0;
            let totalVotes = 0;
            let totalCompletionRate = 0;
            let totalResponseTime = 0;

            snapshot.forEach(doc => {
                const data = doc.data();
                totalPolls++;
                totalVotes += data.totalVotes || 0;
                totalCompletionRate += data.completionRate || 0;
                totalResponseTime += data.averageResponseTime || 0;
            });

            return {
                totalPolls,
                totalVotes,
                avgVotesPerPoll: totalPolls > 0 ? totalVotes / totalPolls : 0,
                avgCompletionRate: totalPolls > 0 ? totalCompletionRate / totalPolls : 0,
                avgResponseTime: totalPolls > 0 ? totalResponseTime / totalPolls : 0
            };
        } catch (error) {
            logger.error('Error getting poll metrics:', error);
            throw error;
        }
    }

    // Retention Metrics
    async getRetentionMetrics(schoolId, date) {
        try {
            const db = admin.firestore();
            const retentionRef = db.collection('retention_metrics');
            
            const dateTimestamp = admin.firestore.Timestamp.fromDate(new Date(date));
            
            let query = retentionRef.where('date', '==', dateTimestamp);
            
            if (schoolId) {
                query = query.where('schoolId', '==', schoolId);
            }

            const snapshot = await query.get();
            return snapshot.empty ? null : snapshot.docs[0].data();
        } catch (error) {
            logger.error('Error getting retention metrics:', error);
            throw error;
        }
    }

    // Conversion Metrics
    async getConversionMetrics(schoolId, startDate, endDate) {
        try {
            const db = admin.firestore();
            const conversionRef = db.collection('conversion_metrics');
            
            const startTimestamp = admin.firestore.Timestamp.fromDate(new Date(startDate));
            const endTimestamp = admin.firestore.Timestamp.fromDate(new Date(endDate));
            
            let query = conversionRef
                .where('date', '>=', startTimestamp)
                .where('date', '<=', endTimestamp);
                
            if (schoolId) {
                query = query.where('schoolId', '==', schoolId);
            }

            const snapshot = await query.get();
            
            let totalRevenue = 0;
            let totalArpu = 0;
            let totalConversionRate = 0;
            let totalInvites = 0;
            let acceptedInvites = 0;
            let count = 0;

            snapshot.forEach(doc => {
                const data = doc.data();
                count++;
                totalRevenue += data.revenueMetrics?.totalRevenue || 0;
                totalArpu += data.revenueMetrics?.arpu || 0;
                totalConversionRate += data.premiumConversions?.rate || 0;
                totalInvites += data.inviteMetrics?.sent || 0;
                acceptedInvites += data.inviteMetrics?.accepted || 0;
            });

            return {
                totalRevenue,
                avgArpu: count > 0 ? totalArpu / count : 0,
                avgConversionRate: count > 0 ? totalConversionRate / count : 0,
                totalInvites,
                acceptedInvites
            };
        } catch (error) {
            logger.error('Error getting conversion metrics:', error);
            throw error;
        }
    }

    // Time Series Data
    async getTimeSeriesData(metric, schoolId, startDate, endDate, interval = 'day') {
        try {
            const db = admin.firestore();
            const activitiesRef = db.collection('user_activities');
            
            const startTimestamp = admin.firestore.Timestamp.fromDate(new Date(startDate));
            const endTimestamp = admin.firestore.Timestamp.fromDate(new Date(endDate));
            
            let query = activitiesRef
                .where('timestamp', '>=', startTimestamp)
                .where('timestamp', '<=', endTimestamp);
                
            if (schoolId) {
                query = query.where('schoolId', '==', schoolId);
            }

            const snapshot = await query.get();
            
            // Group data by interval
            const groupedData = new Map();
            
            snapshot.forEach(doc => {
                const data = doc.data();
                const timestamp = data.timestamp.toDate();
                const key = this._getIntervalKey(timestamp, interval);
                
                if (!groupedData.has(key)) {
                    groupedData.set(key, 0);
                }
                groupedData.set(key, groupedData.get(key) + 1);
            });

            // Convert to sorted array
            return Array.from(groupedData.entries())
                .map(([key, count]) => ({ date: key, count }))
                .sort((a, b) => new Date(a.date) - new Date(b.date));
        } catch (error) {
            logger.error('Error getting time series data:', error);
            throw error;
        }
    }

    // Helper method to generate interval key
    _getIntervalKey(date, interval) {
        const m = moment(date);
        switch (interval) {
            case 'hour':
                return m.format('YYYY-MM-DD HH:00');
            case 'day':
                return m.format('YYYY-MM-DD');
            case 'week':
                return m.format('YYYY-[W]WW');
            case 'month':
                return m.format('YYYY-MM');
            default:
                return m.format('YYYY-MM-DD');
        }
    }
}

module.exports = new AnalyticsService(); 