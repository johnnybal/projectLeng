const mongoose = require('mongoose');

const retentionMetricsSchema = new mongoose.Schema({
    schoolId: {
        type: String,
        required: true,
        index: true
    },
    date: {
        type: Date,
        required: true,
        index: true
    },
    metrics: {
        dayOne: {
            total: Number,
            retained: Number,
            rate: Number
        },
        daySeven: {
            total: Number,
            retained: Number,
            rate: Number
        },
        dayThirty: {
            total: Number,
            retained: Number,
            rate: Number
        }
    },
    userSegments: {
        premium: {
            total: Number,
            retained: Number,
            rate: Number
        },
        free: {
            total: Number,
            retained: Number,
            rate: Number
        }
    },
    returnRates: {
        daily: Number,
        weekly: Number,
        monthly: Number
    }
}, {
    timestamps: true
});

// Indexes for common queries
retentionMetricsSchema.index({ schoolId: 1, date: -1 });
retentionMetricsSchema.index({ date: 1 });

module.exports = mongoose.model('RetentionMetrics', retentionMetricsSchema); 