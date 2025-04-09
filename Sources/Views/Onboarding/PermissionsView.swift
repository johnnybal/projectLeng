import SwiftUI
import Contacts

struct PermissionsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text("Enable permissions")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text("Help us provide you with the best experience")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 10)
            }
            .padding(.top, 60)
            .padding(.horizontal, 24)
            
            // Permissions List
            VStack(spacing: 24) {
                // Contacts Permission
                PermissionRow(
                    icon: "person.2.fill",
                    title: "Contacts",
                    description: "Find your friends already on LengLeng",
                    isGranted: viewModel.isContactsAuthorized
                ) {
                    viewModel.requestContactsAccess()
                }
                
                // Location Permission
                PermissionRow(
                    icon: "location.fill",
                    title: "Location",
                    description: "Connect with people nearby",
                    isGranted: viewModel.isLocationAuthorized
                ) {
                    // Request location access
                }
                
                // Notifications Permission
                PermissionRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    description: "Stay updated with important alerts",
                    isGranted: false
                ) {
                    // Request notifications access
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                withAnimation {
                    viewModel.currentStep = .schoolSelection
                }
            }) {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, y: 4)
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
        }
        .background(Color(UIColor.systemBackground))
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
    }
}

struct PermissionRow: View {
    let icon: String
    let title: String
    let description: String
    let isGranted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                    .frame(width: 48, height: 48)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                    
                    Text(description)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isGranted ? "checkmark.circle.fill" : "chevron.right")
                    .font(.system(size: 20))
                    .foregroundColor(isGranted ? .green : .secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PermissionsView(viewModel: OnboardingViewModel())
} 