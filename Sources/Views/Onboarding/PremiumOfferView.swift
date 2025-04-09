import SwiftUI

struct PremiumOfferView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    @State private var selectedPlan: PlanType = .yearly
    
    enum PlanType {
        case monthly
        case yearly
        
        var price: String {
            switch self {
            case .monthly:
                return "£4.99"
            case .yearly:
                return "£39.99"
            }
        }
        
        var period: String {
            switch self {
            case .monthly:
                return "month"
            case .yearly:
                return "year"
            }
        }
        
        var savings: String? {
            switch self {
            case .monthly:
                return nil
            case .yearly:
                return "Save 33%"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text("Upgrade to Premium")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text("Get access to all premium features")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 10)
            }
            .padding(.top, 60)
            .padding(.horizontal, 24)
            
            // Features List
            VStack(spacing: 24) {
                PremiumFeatureRow(
                    icon: "star.fill",
                    title: "Unlimited Connections",
                    description: "Connect with as many classmates as you want"
                )
                
                PremiumFeatureRow(
                    icon: "bell.badge.fill",
                    title: "Priority Notifications",
                    description: "Get instant alerts for important updates"
                )
                
                PremiumFeatureRow(
                    icon: "chart.bar.fill",
                    title: "Advanced Analytics",
                    description: "Track your academic progress in detail"
                )
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
            
            // Plan Selection
            VStack(spacing: 16) {
                // Monthly Plan
                PlanSelectionButton(
                    type: .monthly,
                    isSelected: selectedPlan == .monthly,
                    action: { selectedPlan = .monthly }
                )
                
                // Yearly Plan
                PlanSelectionButton(
                    type: .yearly,
                    isSelected: selectedPlan == .yearly,
                    action: { selectedPlan = .yearly }
                )
            }
            .padding(.top, 32)
            .padding(.horizontal, 24)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
            
            Spacer()
            
            // Subscribe Button
            Button(action: {
                // Handle subscription
            }) {
                Text("Subscribe Now")
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
            .padding(.bottom, 8)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
            
            // Skip Button
            Button(action: {
                // Handle skip
            }) {
                Text("Maybe Later")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 16)
            .opacity(isAnimating ? 1 : 0)
        }
        .background(Color(UIColor.systemBackground))
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.yellow)
                .frame(width: 48, height: 48)
                .background(Color.yellow.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PlanSelectionButton: View {
    let type: PremiumOfferView.PlanType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(type == .monthly ? "Monthly" : "Yearly")
                            .font(.system(size: 17, weight: .semibold))
                        
                        if let savings = type.savings {
                            Text(savings)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    Text("\(type.price)/\(type.period)")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .blue : .secondary.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PremiumOfferView(viewModel: OnboardingViewModel())
} 