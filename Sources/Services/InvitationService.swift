import Foundation
import Contacts

class InvitationService: ObservableObject {
    private let baseURL = "https://lengleng.app/api"
    
    @Published var availableInvites: Int = 0
    @Published var sentInvitations: [Invitation] = []
    
    // MARK: - Invitation Credits Management
    
    func fetchAvailableInvites() async throws -> Int {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            throw NSError(domain: "InvitationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let url = URL(string: "\(baseURL)/invitation/credits?userId=\(userId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CreditsResponse.self, from: data)
        return response.availableInvites
    }
    
    // MARK: - Invitation Management
    
    func sendInvitation(to recipient: CNContact, messageType: Invitation.MessageType = .standard) async throws {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            throw NSError(domain: "InvitationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let url = URL(string: "\(baseURL)/invitation/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let phone = recipient.phoneNumbers.first?.value.stringValue ?? ""
        let payload = [
            "userId": userId,
            "recipientPhone": phone,
            "recipientName": "\(recipient.givenName) \(recipient.familyName)",
            "messageType": messageType.rawValue
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SendInvitationResponse.self, from: data)
        
        if response.success {
            // Send the message using the system's message UI
            try await sendMessage(response.message, to: phone)
        } else {
            throw NSError(domain: "InvitationService", code: -2, userInfo: [NSLocalizedDescriptionKey: response.error ?? "Failed to send invitation"])
        }
    }
    
    func fetchSentInvitations() async throws -> [Invitation] {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return [] }
        
        let url = URL(string: "\(baseURL)/invitation/sent?userId=\(userId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(InvitationsResponse.self, from: data)
        return response.invitations
    }
    
    // MARK: - Message Sending
    
    private func sendMessage(_ message: String, to phone: String) async throws {
        // Implement message sending using MessageUI or other messaging APIs
        // This will be handled by the iOS system UI
        print("Would send message: \(message) to \(phone)")
    }
}

// MARK: - Contact Management
extension InvitationService {
    func fetchContacts() async throws -> [CNContact] {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        var contacts: [CNContact] = []
        try store.enumerateContacts(with: request) { contact, stop in
            contacts.append(contact)
        }
        
        return contacts.sorted { $0.givenName < $1.givenName }
    }
    
    func filterSchoolContacts(_ contacts: [CNContact]) -> [CNContact] {
        // Implement school-specific filtering logic here
        // This could involve checking against a list of known school contacts
        // or using other criteria to identify school connections
        return contacts
    }
}

// MARK: - API Response Types
private struct CreditsResponse: Codable {
    let availableInvites: Int
}

private struct SendInvitationResponse: Codable {
    let success: Bool
    let invitation: Invitation?
    let message: String
    let error: String?
}

private struct InvitationsResponse: Codable {
    let invitations: [Invitation]
} 