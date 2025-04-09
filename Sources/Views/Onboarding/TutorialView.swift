import SwiftUI

struct TutorialView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    @State private var currentPage = 0
    
    let tutorials = [
        TutorialPage(
            image: "tutorial1",
            title: "Connect with Classmates",
            description: "Find and chat with students from your classes and school"
        ),
        TutorialPage(
            image: "tutorial2",
            title: "Join Study Groups",
            description: "Create or join study groups for better collaboration"
        ),
        TutorialPage(
            image: "tutorial3",
            title: "Stay Updated",
            description: "Get notified about important school events and deadlines"
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Skip Button
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.currentStep = .premiumOffer
                    }
                }) {
                    Text("Skip")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
            .opacity(isAnimating ? 1 : 0)
            
            // Tutorial Content
            TabView(selection: $currentPage) {
                ForEach(0..<tutorials.count, id: \.self) { index in
                    TutorialPageView(page: tutorials[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .opacity(isAnimating ? 1 : 0)
            
            // Page Control
            HStack(spacing: 8) {
                ForEach(0..<tutorials.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentPage == index ? 1.2 : 1)
                        .animation(.spring(), value: currentPage)
                }
            }
            .padding(.top, 24)
            .opacity(isAnimating ? 1 : 0)
            
            Spacer()
            
            // Next/Get Started Button
            Button(action: {
                withAnimation {
                    if currentPage < tutorials.count - 1 {
                        currentPage += 1
                    } else {
                        viewModel.currentStep = .premiumOffer
                    }
                }
            }) {
                Text(currentPage < tutorials.count - 1 ? "Next" : "Get Started")
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

struct TutorialPage: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

struct TutorialPageView: View {
    let page: TutorialPage
    
    var body: some View {
        VStack(spacing: 32) {
            Image(page.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
        }
        .padding(.top, 40)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(viewModel: OnboardingViewModel())
    }
} 