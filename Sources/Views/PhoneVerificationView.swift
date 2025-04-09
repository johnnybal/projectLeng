import SwiftUI

struct PhoneVerificationView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var isPhoneFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Enter Your Phone")
                    .font(.system(size: 24, weight: .bold))
                
                Text("We'll send you a verification code")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            
            // Phone Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Phone Number")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    // Country Code
                    Text("+44")
                        .font(.system(size: 18))
                        .padding(.horizontal, 12)
                        .frame(height: 56)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    // Phone Number TextField
                    TextField("", text: $viewModel.phoneNumber)
                        .font(.system(size: 18))
                        .keyboardType(.numberPad)
                        .focused($isPhoneFieldFocused)
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                Task {
                    await viewModel.verifyPhoneNumber()
                }
            }) {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    viewModel.phoneNumber.count >= 10 ? Color.blue : Color.blue.opacity(0.5)
                )
                .cornerRadius(16)
            }
            .disabled(viewModel.phoneNumber.count < 10 || viewModel.isLoading)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden(viewModel.isLoading)
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
        .onAppear {
            isPhoneFieldFocused = true
        }
    }
}

#Preview {
    PhoneVerificationView(viewModel: OnboardingViewModel())
} 