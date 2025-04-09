const mongoose = require('mongoose');

const userActivitySchema = new mongoose.Schema({
    userId: {
        type: String,
        required: true,
        index: true
    },
    schoolId: {
        type: String,
        required: true,
        index: true
    },
    activityType: {
        type: String,
        enum: ['login', 'poll_vote', 'poll_create', 'invite_sent', 'premium_conversion'],
        required: true
    },
    timestamp: {
        type: Date,
        default: Date.now,
        index: true
    },
    metadata: {
        type: Map,
        of: mongoose.Schema.Types.Mixed
    }
}, {
    timestamps: true
});

// Indexes for common queries
userActivitySchema.index({ userId: 1, timestamp: -1 });
userActivitySchema.index({ schoolId: 1, timestamp: -1 });
userActivitySchema.index({ activityType: 1, timestamp: -1 });

module.exports = mongoose.model('UserActivity', userActivitySchema); 