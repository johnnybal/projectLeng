const { admin } = require('../config/firebase');
const db = admin.firestore();

class PollAnalytics {
    static async create(data) {
        try {
            const docRef = await db.collection('pollAnalytics').add({
                ...data,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                updatedAt: admin.firestore.FieldValue.serverTimestamp()
            });
            return { id: docRef.id, ...data };
        } catch (error) {
            throw new Error(`Error creating poll analytics: ${error.message}`);
        }
    }

    static async findById(id) {
        try {
            const doc = await db.collection('pollAnalytics').doc(id).get();
            if (!doc.exists) {
                return null;
            }
            return { id: doc.id, ...doc.data() };
        } catch (error) {
            throw new Error(`Error finding poll analytics: ${error.message}`);
        }
    }

    static async findAll(query = {}) {
        try {
            let ref = db.collection('pollAnalytics');
            
            // Apply filters if any
            if (query.filters) {
                Object.entries(query.filters).forEach(([field, value]) => {
                    ref = ref.where(field, '==', value);
                });
            }

            // Apply sorting
            if (query.sort) {
                const [field, order] = query.sort.split(':');
                ref = ref.orderBy(field, order === 'desc' ? 'desc' : 'asc');
            }

            // Apply pagination
            if (query.limit) {
                ref = ref.limit(parseInt(query.limit));
            }

            const snapshot = await ref.get();
            return snapshot.docs.map(doc => ({
                id: doc.id,
                ...doc.data()
            }));
        } catch (error) {
            throw new Error(`Error finding poll analytics: ${error.message}`);
        }
    }

    static async update(id, data) {
        try {
            await db.collection('pollAnalytics').doc(id).update({
                ...data,
                updatedAt: admin.firestore.FieldValue.serverTimestamp()
            });
            return { id, ...data };
        } catch (error) {
            throw new Error(`Error updating poll analytics: ${error.message}`);
        }
    }

    static async delete(id) {
        try {
            await db.collection('pollAnalytics').doc(id).delete();
            return true;
        } catch (error) {
            throw new Error(`Error deleting poll analytics: ${error.message}`);
        }
    }

    static async aggregate(pipeline) {
        try {
            // For complex aggregations, you might want to use Cloud Functions
            // This is a simple example that could be expanded based on needs
            const snapshot = await db.collection('pollAnalytics').get();
            const docs = snapshot.docs.map(doc => ({
                id: doc.id,
                ...doc.data()
            }));

            // Implement aggregation logic here based on pipeline
            // This would depend on your specific needs
            return docs;
        } catch (error) {
            throw new Error(`Error aggregating poll analytics: ${error.message}`);
        }
    }
}

module.exports = PollAnalytics; 