import SwiftUI

struct ProfileSetupView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case firstName
        case lastName
        case username
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text("Create your profile")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text("Let's get to know you better")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 10)
            }
            .padding(.top, 60)
            .padding(.horizontal, 24)
            
            // Profile Form
            VStack(spacing: 24) {
                // First Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("First Name")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    TextField("", text: $viewModel.firstName)
                        .textContentType(.givenName)
                        .focused($focusedField, equals: .firstName)
                        .font(.system(size: 17))
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(focusedField == .firstName ? Color.blue : Color.clear, lineWidth: 1)
                        )
                }
                
                // Last Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Last Name")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    TextField("", text: $viewModel.lastName)
                        .textContentType(.familyName)
                        .focused($focusedField, equals: .lastName)
                        .font(.system(size: 17))
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(focusedField == .lastName ? Color.blue : Color.clear, lineWidth: 1)
                        )
                }
                
                // Username
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username (optional)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    TextField("", text: $viewModel.username)
                        .textContentType(.username)
                        .focused($focusedField, equals: .username)
                        .font(.system(size: 17))
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(focusedField == .username ? Color.blue : Color.clear, lineWidth: 1)
                        )
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
            
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.top, 16)
                    .transition(.opacity)
            }
            
            Spacer()
            
            // Continue Button
            Button(action: {
                Task {
                    await viewModel.createProfile()
                }
            }) {
                ZStack {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .opacity(viewModel.isLoading ? 0 : 1)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(!viewModel.firstName.isEmpty && !viewModel.lastName.isEmpty ? Color.blue : Color.gray.opacity(0.5))
                        .shadow(color: !viewModel.firstName.isEmpty && !viewModel.lastName.isEmpty ? Color.blue.opacity(0.3) : Color.clear, radius: 8, y: 4)
                )
            }
            .disabled(viewModel.firstName.isEmpty || viewModel.lastName.isEmpty || viewModel.isLoading)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                focusedField = .firstName
            }
        }
    }
}

#Preview {
    ProfileSetupView(viewModel: OnboardingViewModel())
} 