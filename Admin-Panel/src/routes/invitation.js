const express = require('express');
const router = express.Router();
const { admin } = require('../config/firebase');
const { logger } = require('../utils/logger');

// Get available invites for a user
router.get('/credits', async (req, res) => {
    try {
        const userId = req.query.userId;
        if (!userId) {
            return res.status(400).json({ error: 'User ID is required' });
        }

        const userDoc = await admin.firestore().collection('users').doc(userId).get();
        const availableInvites = userDoc.data()?.availableInvites || 0;

        res.json({ availableInvites });
    } catch (error) {
        logger.error('Error fetching invite credits:', error);
        res.status(500).json({ error: 'Failed to fetch invite credits' });
    }
});

// Update invite credits
router.post('/credits/update', async (req, res) => {
    try {
        const { userId, amount } = req.body;
        if (!userId || amount === undefined) {
            return res.status(400).json({ error: 'User ID and amount are required' });
        }

        await admin.firestore()
            .collection('users')
            .doc(userId)
            .update({
                availableInvites: admin.firestore.FieldValue.increment(amount)
            });

        res.json({ success: true });
    } catch (error) {
        logger.error('Error updating invite credits:', error);
        res.status(500).json({ error: 'Failed to update invite credits' });
    }
});

// Send invitation
router.post('/send', async (req, res) => {
    try {
        const { userId, recipientPhone, recipientName, schoolName, messageType } = req.body;

        // Validate required fields
        if (!userId || !recipientPhone || !recipientName) {
            return res.status(400).json({ error: 'Missing required fields' });
        }

        // Check available invites
        const userDoc = await admin.firestore().collection('users').doc(userId).get();
        const availableInvites = userDoc.data()?.availableInvites || 0;
        
        if (availableInvites <= 0) {
            return res.status(400).json({ error: 'No invites available' });
        }

        // Check weekly invitation limit for recipient
        const weekAgo = new Date();
        weekAgo.setDate(weekAgo.getDate() - 7);

        const receivedInvites = await admin.firestore()
            .collection('invitations')
            .where('recipientPhone', '==', recipientPhone)
            .where('createdAt', '>=', weekAgo)
            .get();

        if (receivedInvites.size >= 3) {
            return res.status(400).json({ error: 'Recipient has reached weekly invitation limit' });
        }

        // Create invitation
        const invitation = {
            id: generateInvitationId(),
            senderId: userId,
            recipientPhone,
            recipientName,
            schoolName,
            messageType: messageType || 'standard',
            status: 'sent',
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 hours from now
        };

        // Save invitation
        await admin.firestore()
            .collection('invitations')
            .doc(invitation.id)
            .set(invitation);

        // Deduct invite credit
        await admin.firestore()
            .collection('users')
            .doc(userId)
            .update({
                availableInvites: admin.firestore.FieldValue.increment(-1)
            });

        // Generate message
        const message = generateMessage(invitation);

        res.json({
            success: true,
            invitation,
            message
        });
    } catch (error) {
        logger.error('Error sending invitation:', error);
        res.status(500).json({ error: 'Failed to send invitation' });
    }
});

// Get sent invitations
router.get('/sent', async (req, res) => {
    try {
        const { userId } = req.query;
        if (!userId) {
            return res.status(400).json({ error: 'User ID is required' });
        }

        const invitationsSnapshot = await admin.firestore()
            .collection('invitations')
            .where('senderId', '==', userId)
            .orderBy('createdAt', 'desc')
            .get();

        const invitations = invitationsSnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
        }));

        res.json({ invitations });
    } catch (error) {
        logger.error('Error fetching sent invitations:', error);
        res.status(500).json({ error: 'Failed to fetch sent invitations' });
    }
});

// Update invitation status
router.post('/status', async (req, res) => {
    try {
        const { invitationId, status } = req.body;
        if (!invitationId || !status) {
            return res.status(400).json({ error: 'Invitation ID and status are required' });
        }

        const validStatuses = ['sent', 'clicked', 'installed', 'expired'];
        if (!validStatuses.includes(status)) {
            return res.status(400).json({ error: 'Invalid status' });
        }

        const updateData = {
            status,
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        };

        if (status === 'clicked') {
            updateData.clickedAt = admin.firestore.FieldValue.serverTimestamp();
        } else if (status === 'installed') {
            updateData.installedAt = admin.firestore.FieldValue.serverTimestamp();
        }

        await admin.firestore()
            .collection('invitations')
            .doc(invitationId)
            .update(updateData);

        res.json({ success: true });
    } catch (error) {
        logger.error('Error updating invitation status:', error);
        res.status(500).json({ error: 'Failed to update invitation status' });
    }
});

// Helper functions
function generateInvitationId() {
    return Math.random().toString(36).substring(2, 15) + 
           Math.random().toString(36).substring(2, 15);
}

function generateMessage(invitation) {
    const baseUrl = 'https://lengleng.app/invite/';
    const link = `${baseUrl}${invitation.id}`;

    const templates = {
        standard: [
            `Someone at ${invitation.schoolName || '[School Name]'} picked you on LengLeng 🔥 Find out who! ${link}`,
            `[X] people from ${invitation.schoolName || '[School Name]'} have rated you on LengLeng. See what they said! ${link}`,
            `Someone thinks you're 👑 at ${invitation.schoolName || '[School Name]'}. Find out who on LengLeng! ${link}`,
            `Your crush might be waiting for you on LengLeng 👀 ${link}`
        ],
        premium: [
            `Someone you know just gave you a flame on LengLeng 🔥 They're waiting for you! ${link}`
        ],
        schoolSpecific: [
            `Someone at ${invitation.schoolName || 'your school'} picked you on LengLeng 🔥 Find out who! ${link}`
        ]
    };

    const messageList = templates[invitation.messageType] || templates.standard;
    return messageList[Math.floor(Math.random() * messageList.length)];
}

module.exports = router; 