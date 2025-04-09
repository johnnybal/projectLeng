import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthenticationService {
    static let shared = AuthenticationService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Phone Authentication
    func verifyPhoneNumber(_ phoneNumber: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let verificationID = verificationID {
                    continuation.resume(returning: verificationID)
                } else {
                    continuation.resume(throwing: NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Verification ID is nil"]))
                }
            }
        }
    }
    
    func signIn(withVerificationID verificationID: String, verificationCode: String) async throws -> User {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        let result = try await auth.signIn(with: credential)
        let firebaseUser = result.user
        
        // Check if user exists in Firestore
        let userDoc = try await db.collection("users").document(firebaseUser.uid).getDocument()
        
        if userDoc.exists {
            let userData = try userDoc.data(as: User.self)
            return userData
        } else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found in database"])
        }
    }
    
    // MARK: - User Management
    func createUser(firstName: String,
                   lastName: String,
                   phoneNumber: String,
                   username: String? = nil) async throws -> User {
        guard let firebaseUser = auth.currentUser else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        
        let newUser = User(id: firebaseUser.uid,
                          firstName: firstName,
                          lastName: lastName,
                          username: username,
                          phoneNumber: phoneNumber)
        
        try await db.collection("users").document(firebaseUser.uid).setData(from: newUser)
        return newUser
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    var currentUser: User? {
        guard let firebaseUser = auth.currentUser else { return nil }
        // Note: This should be cached in a real implementation
        return try? db.collection("users").document(firebaseUser.uid).getDocument(as: User.self)
    }
} 