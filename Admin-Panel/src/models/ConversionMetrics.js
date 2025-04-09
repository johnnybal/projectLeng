const mongoose = require('mongoose');

const conversionMetricsSchema = new mongoose.Schema({
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
    premiumConversions: {
        total: Number,
        rate: Number,
        revenue: Number
    },
    inviteMetrics: {
        sent: Number,
        accepted: Number,
        conversionRate: Number
    },
    userSegments: {
        type: Map,
        of: {
            total: Number,
            conversions: Number,
            rate: Number
        }
    },
    revenueMetrics: {
        totalRevenue: Number,
        arpu: Number, // Average Revenue Per User
        arppu: Number // Average Revenue Per Paying User
    },
    conversionFunnel: {
        impression: Number,
        click: Number,
        signup: Number,
        trial: Number,
        purchase: Number
    }
}, {
    timestamps: true
});

// Indexes for common queries
conversionMetricsSchema.index({ schoolId: 1, date: -1 });
conversionMetricsSchema.index({ date: 1 });

module.exports = mongoose.model('ConversionMetrics', conversionMetricsSchema); 