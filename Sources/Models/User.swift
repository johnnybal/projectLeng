import Foundation
import FirebaseFirestoreSwift

public struct User: Codable, Identifiable {
    @DocumentID public var id: String?
    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
    public let username: String?
    public let email: String?
    public let createdAt: Date?
    public let lastActive: Date?
    
    public var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case phoneNumber
        case username
        case email
        case createdAt
        case lastActive
    }
} 