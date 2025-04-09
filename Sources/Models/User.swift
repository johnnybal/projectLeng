import Foundation
import FirebaseFirestore

struct User: Codable {
    let id: String
    var firstName: String
    var lastName: String
    var username: String?
    var phoneNumber: String
    var schoolId: String?
    var profileImageURL: String?
    var flamesCount: Int
    var gemsCount: Int
    var invitesRemaining: Int
    var isPremium: Bool
    var lastActive: Date
    var createdAt: Date
    
    // Stats
    var pollsCompleted: Int
    var streakCount: Int
    var receivedVotes: Int
    
    // Privacy and Settings
    var allowLocationServices: Bool
    var allowContactSync: Bool
    
    init(id: String = UUID().uuidString,
         firstName: String,
         lastName: String,
         username: String? = nil,
         phoneNumber: String,
         schoolId: String? = nil,
         profileImageURL: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.phoneNumber = phoneNumber
        self.schoolId = schoolId
        self.profileImageURL = profileImageURL
        self.flamesCount = 0
        self.gemsCount = 0
        self.invitesRemaining = 10 // Initial invite count
        self.isPremium = false
        self.lastActive = Date()
        self.createdAt = Date()
        self.pollsCompleted = 0
        self.streakCount = 0
        self.receivedVotes = 0
        self.allowLocationServices = false
        self.allowContactSync = false
    }
} 