import SwiftUI
import FirebaseFirestore

struct SchoolSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    @State private var searchText = ""
    @State private var schools = [
        School(id: "1", 
              name: "University of Oxford", 
              address: "Oxford", 
              city: "Oxford",
              postcode: "OX1 2JD",
              latitude: 51.7548,
              longitude: -1.2544,
              type: .university),
        School(id: "2", 
              name: "Imperial College London", 
              address: "South Kensington Campus",
              city: "London",
              postcode: "SW7 2AZ",
              latitude: 51.4988,
              longitude: -0.1749,
              type: .university),
        School(id: "3", 
              name: "University College London", 
              address: "Gower Street",
              city: "London",
              postcode: "WC1E 6BT",
              latitude: 51.5246,
              longitude: -0.1340,
              type: .university)
    ]
    
    var filteredSchools: [School] {
        if searchText.isEmpty {
            return schools
        }
        return schools.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text("Select your school")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text("Connect with your school community")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 10)
            }
            .padding(.top, 60)
            .padding(.horizontal, 24)
            
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.secondary)
                
                TextField("Search schools", text: $searchText)
                    .font(.system(size: 17))
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemGray6))
            )
            .padding(.top, 24)
            .padding(.horizontal, 24)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
            
            // Schools List
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredSchools) { school in
                        SchoolRow(
                            school: school,
                            isSelected: viewModel.selectedSchool?.id == school.id
                        ) {
                            viewModel.selectedSchool = school
                        }
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
            }
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                withAnimation {
                    viewModel.currentStep = .tutorial
                }
            }) {
                Text("Continue")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(viewModel.selectedSchool != nil ? Color.blue : Color.gray.opacity(0.5))
                            .shadow(color: viewModel.selectedSchool != nil ? Color.blue.opacity(0.3) : Color.clear, radius: 8, y: 4)
                    )
            }
            .disabled(viewModel.selectedSchool == nil)
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

struct SchoolRow: View {
    let school: School
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(school.name)
                        .font(.system(size: 17, weight: .semibold))
                    
                    Text(school.location)
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
    SchoolSelectionView(viewModel: OnboardingViewModel())
} 