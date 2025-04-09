import Foundation
import FirebaseFirestore

struct Invitation: Codable, Identifiable {
    let id: String
    let senderId: String
    let recipientPhone: String
    let recipientName: String
    let status: InvitationStatus
    let messageType: MessageType
    let schoolName: String?
    let createdAt: Date
    let expiresAt: Date
    let clickedAt: Date?
    let installedAt: Date?
    
    enum InvitationStatus: String, Codable {
        case sent
        case clicked
        case installed
        case expired
    }
    
    enum MessageType: String, Codable {
        case standard
        case premium
        case schoolSpecific
    }
    
    init(id: String = UUID().uuidString,
         senderId: String,
         recipientPhone: String,
         recipientName: String,
         schoolName: String? = nil,
         messageType: MessageType = .standard) {
        self.id = id
        self.senderId = senderId
        self.recipientPhone = recipientPhone
        self.recipientName = recipientName
        self.status = .sent
        self.messageType = messageType
        self.schoolName = schoolName
        self.createdAt = Date()
        self.expiresAt = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
        self.clickedAt = nil
        self.installedAt = nil
    }
}

// MARK: - Firestore Conversion
extension Invitation {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "senderId": senderId,
            "recipientPhone": recipientPhone,
            "recipientName": recipientName,
            "status": status.rawValue,
            "messageType": messageType.rawValue,
            "schoolName": schoolName as Any,
            "createdAt": Timestamp(date: createdAt),
            "expiresAt": Timestamp(date: expiresAt),
            "clickedAt": clickedAt.map { Timestamp(date: $0) } as Any,
            "installedAt": installedAt.map { Timestamp(date: $0) } as Any
        ]
    }
    
    static func from(_ document: DocumentSnapshot) -> Invitation? {
        guard let data = document.data() else { return nil }
        
        return Invitation(
            id: document.documentID,
            senderId: data["senderId"] as? String ?? "",
            recipientPhone: data["recipientPhone"] as? String ?? "",
            recipientName: data["recipientName"] as? String ?? "",
            schoolName: data["schoolName"] as? String,
            messageType: MessageType(rawValue: data["messageType"] as? String ?? "") ?? .standard
        )
    }
} 