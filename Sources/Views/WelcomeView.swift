import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Logo and Title
            VStack(spacing: 16) {
                Text("🎉")
                    .font(.system(size: 64))
                
                Text("Welcome to LengLeng!")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("Boost your friends anonymously\nand see who's rating you!")
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Features
            VStack(spacing: 20) {
                FeatureRow(emoji: "🎭", text: "Send anonymous compliments")
                FeatureRow(emoji: "🔥", text: "Get instant notifications")
                FeatureRow(emoji: "🔍", text: "Discover who voted for you")
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Get Started Button
            Button(action: {
                withAnimation {
                    viewModel.moveToNextStep()
                }
            }) {
                Text("Get Started")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
            }
            
            // Terms and Privacy
            Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct FeatureRow: View {
    let emoji: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(emoji)
                .font(.system(size: 32))
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    WelcomeView(viewModel: OnboardingViewModel())
} 