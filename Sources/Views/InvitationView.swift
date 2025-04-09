import SwiftUI
import Contacts
import MessageUI

struct InvitationView: View {
    @StateObject private var invitationService = InvitationService()
    @State private var contacts: [CNContact] = []
    @State private var searchText = ""
    @State private var showingContactPicker = false
    @State private var selectedContact: CNContact?
    @State private var showingMessageComposer = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    private var filteredContacts: [CNContact] {
        if searchText.isEmpty {
            return contacts
        }
        return contacts.filter {
            "\($0.givenName) \($0.familyName)".lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Available Invites Counter
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                    Text("\(invitationService.availableInvites) invites remaining")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                // Search Bar
                SearchBar(text: $searchText)
                    .padding()
                
                // Contacts List
                List(filteredContacts, id: \.identifier) { contact in
                    ContactRow(contact: contact) {
                        selectedContact = contact
                        showingMessageComposer = true
                    }
                }
                .listStyle(PlainListStyle())
                
                // Quick Actions
                VStack(spacing: 12) {
                    Button(action: { showingContactPicker = true }) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Select from Contacts")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Invite Friends")
            .onAppear {
                loadContacts()
                loadInviteCredits()
            }
            .sheet(isPresented: $showingContactPicker) {
                ContactPickerView(selectedContact: $selectedContact)
            }
            .alert(isPresented: $showingError) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: selectedContact) { contact in
                if let contact = contact {
                    sendInvitation(to: contact)
                }
            }
        }
    }
    
    private func loadContacts() {
        Task {
            do {
                let fetchedContacts = try await invitationService.fetchContacts()
                DispatchQueue.main.async {
                    self.contacts = fetchedContacts
                }
            } catch {
                showError("Failed to load contacts: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadInviteCredits() {
        Task {
            do {
                let credits = try await invitationService.fetchAvailableInvites()
                DispatchQueue.main.async {
                    invitationService.availableInvites = credits
                }
            } catch {
                showError("Failed to load invite credits: \(error.localizedDescription)")
            }
        }
    }
    
    private func sendInvitation(to contact: CNContact) {
        Task {
            do {
                isLoading = true
                try await invitationService.sendInvitation(to: contact)
                DispatchQueue.main.async {
                    isLoading = false
                    selectedContact = nil
                    loadInviteCredits()
                }
            } catch {
                showError(error.localizedDescription)
            }
        }
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            errorMessage = message
            showingError = true
            isLoading = false
        }
    }
}

// MARK: - Supporting Views

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search contacts", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct ContactRow: View {
    let contact: CNContact
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(contact.givenName.prefix(1))
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading) {
                    Text("\(contact.givenName) \(contact.familyName)")
                        .font(.system(size: 16, weight: .medium))
                    
                    if let phone = contact.phoneNumbers.first?.value.stringValue {
                        Text(phone)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Contact Picker
struct ContactPickerView: UIViewControllerRepresentable {
    @Binding var selectedContact: CNContact?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPickerView
        
        init(_ parent: ContactPickerView) {
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            parent.selectedContact = contact
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
} 