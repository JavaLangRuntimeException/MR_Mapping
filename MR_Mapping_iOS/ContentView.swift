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
    @State private var showNaviList = false
    
    var body: some View {
        VStack {
            List(rooms) { room in
                VStack(alignment: .leading) {
                    Text(room.name)
                        .font(.headline)
                    Text("X: \(room.x), Y: \(room.y)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Button(action: {
                showNaviList = true
            }) {
                Text("Start Navigation")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            fetchRooms()
        }
        .navigationBarTitle("Rooms")
        .sheet(isPresented: $showNaviList) {
            NaviListView()
        }
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
    struct NaviListView: View {
        @State private var navis: [Navi] = []
        @State private var rooms: [Room] = []
        @State private var selectedDepRoom: Int?
        @State private var selectedArrRoom: Int?
        @State private var showPopup = false
        
        var body: some View {
            VStack {
                List(navis) { navi in
                    VStack(alignment: .leading) {
                        Text("From Room \(navi.depRoom) to Room \(navi.arrRoom)")
                    }
                }
                
                Picker("Departure Room", selection: $selectedDepRoom) {
                    Text("Select a room").tag(nil as Int?)
                    ForEach(rooms.indices, id: \.self) { index in
                        Text(rooms[index].name).tag(index as Int?)
                    }
                }
                
                Picker("Arrival Room", selection: $selectedArrRoom) {
                    Text("Select a room").tag(nil as Int?)
                    ForEach(rooms.indices, id: \.self) { index in
                        Text(rooms[index].name).tag(index as Int?)
                    }
                }
                
                Button(action: {
                    sendNavi()
                }) {
                    Text("Send Navi")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .onAppear {
                fetchNavis()
                fetchRooms()
            }
            .navigationBarTitle("Navi List")
            .sheet(isPresented: $showPopup) {
                if let depRoomIndex = selectedDepRoom,
                   let arrRoomIndex = selectedArrRoom {
                    let depRoom = rooms[depRoomIndex]
                    let arrRoom = rooms[arrRoomIndex]
                    PopupView(depRoom: depRoom, arrRoom: arrRoom)
                }
            }
        }
        
        func fetchNavis() {
            APIClient.shared.fetchNavis { result in
                switch result {
                case .success(let navis):
                    self.navis = navis
                case .failure(let error):
                    print("Failed to fetch navis: \(error.localizedDescription)")
                }
            }
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
        
        func sendNavi() {
            guard let depRoomIndex = selectedDepRoom,
                  let arrRoomIndex = selectedArrRoom else {
                return
            }
            
            let depRoom = rooms[depRoomIndex]
            let arrRoom = rooms[arrRoomIndex]
            
            APIClient.shared.postNavi(depRoomId: depRoom.id, arrRoomId: arrRoom.id, userId: 1) { result in
                switch result {
                case .success:
                    self.fetchNavis()
                    self.showPopup = true
                case .failure(let error):
                    print("Failed to post navi: \(error.localizedDescription)")
                }
            }
        }
    }


