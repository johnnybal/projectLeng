import SwiftUI

struct PhoneVerificationView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    @FocusState private var isPhoneFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "F8FAFF"),
                    Color(hex: "FFFFFF")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Back Button
                HStack {
                    Button(action: {
                        withAnimation {
                            viewModel.currentStep = .welcome
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(hex: "1A1F36"))
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .opacity(isAnimating ? 1 : 0)
                
                // Header
                VStack(spacing: 16) {
                    Text("Enter your phone number")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "1A1F36"))
                        .multilineTextAlignment(.center)
                    
                    Text("We'll send you a verification code")
                        .font(.system(size: 17))
                        .foregroundColor(Color(hex: "4A5578"))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                .padding(.horizontal, 24)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                
                // Phone Input
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        Text("🇺🇸 +1")
                            .font(.system(size: 17))
                            .foregroundColor(Color(hex: "1A1F36"))
                        
                        TextField("(000) 000-0000", text: $viewModel.phoneNumber)
                            .font(.system(size: 17))
                            .keyboardType(.numberPad)
                            .focused($isPhoneFieldFocused)
                            .onChange(of: viewModel.phoneNumber) { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count > 10 {
                                    viewModel.phoneNumber = String(filtered.prefix(10))
                                }
                                
                                // Format the phone number
                                if filtered.count <= 10 {
                                    var formatted = ""
                                    for (index, char) in filtered.enumerated() {
                                        if index == 0 {
                                            formatted += "("
                                        }
                                        formatted += String(char)
                                        if index == 2 {
                                            formatted += ") "
                                        }
                                        if index == 5 {
                                            formatted += "-"
                                        }
                                    }
                                    if formatted != newValue {
                                        viewModel.phoneNumber = formatted
                                    }
                                }
                            }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: isPhoneFieldFocused ? Color(hex: "246BFD").opacity(0.1) : Color.clear,
                            radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isPhoneFieldFocused ? Color(hex: "246BFD") : Color.clear, lineWidth: 1)
                    )
                    
                    if let error = viewModel.error as? OnboardingError {
                        Text(error.localizedDescription)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 40)
                .padding(.horizontal, 24)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    Task {
                        await viewModel.verifyPhoneNumber(viewModel.phoneNumber)
                    }
                }) {
                    ZStack {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(viewModel.phoneNumber.filter { $0.isNumber }.count == 10 ? Color(hex: "246BFD") : Color(hex: "246BFD").opacity(0.5))
                                    .shadow(color: Color(hex: "246BFD").opacity(0.25), radius: 8, y: 4)
                            )
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                }
                .disabled(viewModel.phoneNumber.filter { $0.isNumber }.count != 10 || viewModel.isLoading)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isPhoneFieldFocused = true
            }
        }
    }
}

// Custom View Extension for Placeholder
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    PhoneVerificationView(viewModel: OnboardingViewModel())
} 