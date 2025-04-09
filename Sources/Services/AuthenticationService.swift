import Foundation
import FirebaseAuth
import FirebaseFirestore

public class AuthenticationService {
    public static let shared = AuthenticationService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Email Authentication
    public func createUserWithEmail(_ email: String, password: String) async throws -> AuthDataResult {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            
            // Create user document in Firestore
            let userData: [String: Any] = [
                "email": email,
                "createdAt": FieldValue.serverTimestamp(),
                "lastActive": FieldValue.serverTimestamp()
            ]
            
            try await db.collection("users").document(result.user.uid).setData(userData, merge: true)
            return result
        } catch {
            throw error
        }
    }
    
    // MARK: - Phone Authentication
    public func verifyPhoneNumber(_ phoneNumber: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let verificationID = verificationID {
                    continuation.resume(returning: verificationID)
                } else {
                    continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
    
    public func signIn(withVerificationID verificationID: String?, verificationCode: String) async throws -> AuthDataResult {
        guard let verificationID = verificationID else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing verification ID"])
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        return try await auth.signIn(with: credential)
    }
    
    // MARK: - User Management
    public func createUser(firstName: String,
                   lastName: String,
                   phoneNumber: String,
                   username: String? = nil) async throws {
        guard let uid = auth.currentUser?.uid else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "username": username ?? "",
            "createdAt": FieldValue.serverTimestamp(),
            "lastActive": FieldValue.serverTimestamp()
        ]
        
        _ = try await db.collection("users").document(uid).setData(userData, merge: true)
    }
    
    public func signOut() throws {
        try auth.signOut()
    }
    
    public var currentUser: FirebaseAuth.User? {
        auth.currentUser
    }
    
    internal func getCurrentUserData() async throws -> User? {
        guard let firebaseUser = auth.currentUser else { return nil }
        let document = try await db.collection("users").document(firebaseUser.uid).getDocument()
        return try? document.data(as: User.self)
    }
    
    internal func createUserDocument(_ user: FirebaseAuth.User, firstName: String, lastName: String, phoneNumber: String, username: String?) async throws {
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "username": username ?? "",
            "createdAt": FieldValue.serverTimestamp(),
            "lastActive": FieldValue.serverTimestamp()
        ]
        
        let docRef = db.collection("users").document(user.uid)
        try await docRef.setData(userData, merge: true)
    }
} 