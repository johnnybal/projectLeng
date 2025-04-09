import Foundation

struct Poll: Codable, Identifiable {
    let id: String
    var question: String
    var emoji: String
    var options: [String] // User IDs
    var votes: [String: String] // [VoterID: VotedForUserID]
    var schoolId: String
    var isActive: Bool
    var expiresAt: Date
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         question: String,
         emoji: String,
         schoolId: String,
         options: [String] = [],
         expiresIn: TimeInterval = 24 * 60 * 60) { // 24 hours default
        self.id = id
        self.question = question
        self.emoji = emoji
        self.schoolId = schoolId
        self.options = options
        self.votes = [:]
        self.isActive = true
        self.createdAt = Date()
        self.expiresAt = Date().addingTimeInterval(expiresIn)
    }
    
    var totalVotes: Int {
        return votes.count
    }
    
    func hasVoted(_ userId: String) -> Bool {
        return votes[userId] != nil
    }
    
    mutating func addVote(from userId: String, for votedUserId: String) -> Bool {
        guard options.contains(votedUserId),
              !hasVoted(userId),
              isActive,
              Date() < expiresAt else {
            return false
        }
        
        votes[userId] = votedUserId
        return true
    }
} 