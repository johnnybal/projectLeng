import Foundation
import Combine
import FirebaseAuth
import Contacts
import SwiftUI

public enum OnboardingStep {
    case welcome
    case phoneVerification
    case codeVerification
    case profile
    case permissions
    case schoolSelection
    case tutorial
    case premiumOffer
}

public enum OnboardingError: LocalizedError {
    case invalidPhoneNumber
    case invalidVerificationCode
    case networkError
    case userCancelled
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return "Please enter a valid phone number"
        case .invalidVerificationCode:
            return "The verification code is invalid. Please try again"
        case .networkError:
            return "Network error. Please check your connection and try again"
        case .userCancelled:
            return "Operation cancelled by user"
        case .unknown:
            return "An unknown error occurred. Please try again"
        }
    }
}

@MainActor
public class OnboardingViewModel: ObservableObject {
    @Published public var currentStep: OnboardingStep = .welcome
    @Published public var phoneNumber: String = ""
    @Published public var verificationCode: String = ""
    @Published public var verificationID: String?
    @Published public var firstName: String = ""
    @Published public var lastName: String = ""
    @Published public var username: String = ""
    @Published public var selectedSchool: School?
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
    // Permissions
    @Published public var isContactsAuthorized = false
    @Published public var isLocationAuthorized = false
    
    private let authService = AuthenticationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    // MARK: - Phone Verification
    public func verifyPhoneNumber(_ phoneNumber: String) async {
        let digits = phoneNumber.filter { $0.isNumber }
        let truncated = String(digits.prefix(10))
        var formatted = ""
        for (index, digit) in truncated.enumerated() {
            if index == 3 || index == 6 {
                formatted += " "
            }
            formatted += String(digit)
        }
        
        guard !formatted.isEmpty else {
            await MainActor.run {
                self.error = OnboardingError.invalidPhoneNumber
            }
            return
        }
        
        isLoading = true
        do {
            verificationID = try await authService.verifyPhoneNumber(formatted)
            await MainActor.run {
                currentStep = .codeVerification
                isLoading = false
            }
        } catch {
            await MainActor.run {
                if let authError = error as? AuthErrorCode {
                    switch authError.code {
                    case .networkError:
                        self.error = OnboardingError.networkError
                    case .invalidPhoneNumber:
                        self.error = OnboardingError.invalidPhoneNumber
                    default:
                        self.error = OnboardingError.unknown
                    }
                } else {
                    self.error = OnboardingError.unknown
                }
                isLoading = false
            }
        }
    }
    
    public func submitVerificationCode() async {
        guard !verificationCode.isEmpty, verificationCode.count == 6 else {
            await MainActor.run {
                self.error = OnboardingError.invalidVerificationCode
            }
            return
        }
        
        isLoading = true
        do {
            _ = try await authService.signIn(withVerificationID: verificationID, verificationCode: verificationCode)
            await MainActor.run {
                currentStep = .profile
                isLoading = false
            }
        } catch {
            await MainActor.run {
                if let authError = error as? AuthErrorCode {
                    switch authError.code {
                    case .networkError:
                        self.error = OnboardingError.networkError
                    case .invalidVerificationCode:
                        self.error = OnboardingError.invalidVerificationCode
                    default:
                        self.error = OnboardingError.unknown
                    }
                } else {
                    self.error = OnboardingError.unknown
                }
                isLoading = false
            }
        }
    }
    
    // MARK: - Profile Creation
    public func createProfile() async {
        guard !firstName.isEmpty, !lastName.isEmpty else {
            await MainActor.run {
                self.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please enter your name"])
            }
            return
        }
        
        isLoading = true
        do {
            _ = try await authService.createUser(
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                username: username.isEmpty ? nil : username
            )
            await MainActor.run {
                currentStep = .permissions
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                isLoading = false
            }
        }
    }
    
    // MARK: - Permissions
    public func requestContactsAccess() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isContactsAuthorized = granted
                if let error = error {
                    self?.error = error
                }
            }
        }
    }
    
    // MARK: - Email Authentication
    public func createUserWithEmailAndPassword(email: String, password: String) async {
        isLoading = true
        do {
            let result = try await authService.createUserWithEmail(email, password: password)
            await MainActor.run {
                isLoading = false
                // Handle successful user creation
                print("Successfully created user with email: \(email)")
            }
        } catch {
            await MainActor.run {
                self.error = error
                isLoading = false
            }
        }
    }
    
    // MARK: - Helpers
    private func formatPhoneNumber(_ number: String) -> String {
        // Remove any non-digit characters
        let digits = number.filter { $0.isNumber }
        
        // Limit to 10 digits
        let truncated = String(digits.prefix(10))
        
        // Format as XXX XXX XXXX
        var formatted = ""
        for (index, digit) in truncated.enumerated() {
            if index == 3 || index == 6 {
                formatted += " "
            }
            formatted += String(digit)
        }
        
        return formatted
    }
    
    public func moveToNextStep() {
        switch currentStep {
        case .welcome:
            currentStep = .phoneVerification
        case .phoneVerification:
            Task {
                await verifyPhoneNumber(phoneNumber)
            }
        case .codeVerification:
            Task {
                await submitVerificationCode()
            }
        case .profile:
            Task {
                await createProfile()
            }
        case .permissions:
            currentStep = .schoolSelection
        case .schoolSelection:
            currentStep = .tutorial
        case .tutorial:
            currentStep = .premiumOffer
        case .premiumOffer:
            // Complete onboarding
            break
        }
    }
} 