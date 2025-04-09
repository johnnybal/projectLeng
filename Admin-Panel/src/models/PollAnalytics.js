const mongoose = require('mongoose');

const pollAnalyticsSchema = new mongoose.Schema({
    pollId: {
        type: String,
        required: true,
        index: true
    },
    schoolId: {
        type: String,
        required: true,
        index: true
    },
    totalVotes: {
        type: Number,
        default: 0
    },
    uniqueVoters: {
        type: Number,
        default: 0
    },
    averageResponseTime: {
        type: Number,
        default: 0
    },
    completionRate: {
        type: Number,
        default: 0
    },
    demographicBreakdown: {
        gender: {
            type: Map,
            of: Number
        },
        ageGroup: {
            type: Map,
            of: Number
        }
    },
    timeDistribution: [{
        hour: Number,
        count: Number
    }],
    startTime: {
        type: Date,
        required: true
    },
    endTime: {
        type: Date,
        required: true
    }
}, {
    timestamps: true
});

// Indexes for common queries
pollAnalyticsSchema.index({ schoolId: 1, startTime: -1 });
pollAnalyticsSchema.index({ pollId: 1, startTime: -1 });

module.exports = mongoose.model('PollAnalytics', pollAnalyticsSchema); 