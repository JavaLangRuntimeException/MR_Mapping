import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                RoomListView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                login()
            }) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            NavigationLink(destination: RegisterView()) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationBarTitle("Login")
    }
    
    func login() {
        APIClient.shared.login(username: username, password: password) { result in
            switch result {
            case .success(let token):
                UserDefaults.standard.set(token, forKey: "token")
                isLoggedIn = true
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
}

struct RegisterView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                register()
            }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle("Register")
    }
    
    func register() {
        APIClient.shared.register(username: username, email: email, password: password) { result in
            switch result {
            case .success:
                print("Registration successful")
            case .failure(let error):
                print("Registration failed: \(error.localizedDescription)")
            }
        }
    }
}

struct RoomListView: View {
    @State private var rooms: [Room] = []
    
    var body: some View {
        List(rooms) { room in
            VStack(alignment: .leading) {
                Text(room.name)
                    .font(.headline)
                Text("X: \(room.x), Y: \(room.y)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            fetchRooms()
        }
        .navigationBarTitle("Rooms")
    }
    
    func fetchRooms() {
        APIClient.shared.fetchRooms { result in
            switch result {
            case .success(let rooms):
                self.rooms = rooms
            case .failure(let error):
                print("Failed to fetch rooms: \(error.localizedDescription)")
            }
        }
    }
}
