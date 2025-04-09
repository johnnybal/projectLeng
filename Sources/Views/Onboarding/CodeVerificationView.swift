import SwiftUI

struct CodeVerificationView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    @State private var timer: Timer?
    @State private var timeRemaining = 60
    @FocusState private var focusedField: Int?
    
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
                            viewModel.currentStep = .phoneVerification
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
                    Text("Enter verification code")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "1A1F36"))
                        .multilineTextAlignment(.center)
                    
                    Text("We've sent a code to \(viewModel.phoneNumber)")
                        .font(.system(size: 17))
                        .foregroundColor(Color(hex: "4A5578"))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                .padding(.horizontal, 24)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                
                // Code Input
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        ForEach(0..<6) { index in
                            let digit = index < viewModel.verificationCode.count ? String(viewModel.verificationCode[viewModel.verificationCode.index(viewModel.verificationCode.startIndex, offsetBy: index)]) : ""
                            
                            TextField("", text: .constant(digit))
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 50, height: 56)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: focusedField == index ? Color(hex: "246BFD").opacity(0.1) : Color.clear,
                                        radius: 8, x: 0, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(focusedField == index ? Color(hex: "246BFD") : Color.clear, lineWidth: 1)
                                )
                                .focused($focusedField, equals: index)
                                .onChange(of: digit) { newValue in
                                    if !newValue.isEmpty {
                                        let currentCode = viewModel.verificationCode
                                        if index < currentCode.count {
                                            var chars = Array(currentCode)
                                            chars[index] = newValue.last!
                                            viewModel.verificationCode = String(chars)
                                        } else {
                                            viewModel.verificationCode += newValue
                                        }
                                        
                                        if index < 5 {
                                            focusedField = index + 1
                                        } else {
                                            focusedField = nil
                                        }
                                    }
                                }
                        }
                    }
                    
                    if let error = viewModel.error as? OnboardingError {
                        Text(error.localizedDescription)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                    }
                    
                    // Resend Timer
                    Button(action: {
                        if timeRemaining == 0 {
                            Task {
                                await viewModel.verifyPhoneNumber(viewModel.phoneNumber)
                                timeRemaining = 60
                                startTimer()
                            }
                        }
                    }) {
                        Text(timeRemaining > 0 ? "Resend code in \(timeRemaining)s" : "Resend code")
                            .font(.system(size: 15))
                            .foregroundColor(timeRemaining > 0 ? Color(hex: "4A5578") : Color(hex: "246BFD"))
                    }
                    .disabled(timeRemaining > 0)
                }
                .padding(.top, 40)
                .padding(.horizontal, 24)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    Task {
                        await viewModel.submitVerificationCode()
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
                                    .fill(viewModel.verificationCode.count == 6 ? Color(hex: "246BFD") : Color(hex: "246BFD").opacity(0.5))
                                    .shadow(color: Color(hex: "246BFD").opacity(0.25), radius: 8, y: 4)
                            )
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                }
                .disabled(viewModel.verificationCode.count != 6 || viewModel.isLoading)
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
                focusedField = 0
            }
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
}

#Preview {
    CodeVerificationView(viewModel: OnboardingViewModel())
} 