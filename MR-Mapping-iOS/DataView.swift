import SwiftUI

struct DataView: View {
    @ObservedObject var client: WebSocketClient
    
    init() {
        client = WebSocketClient()
        client.setup(url: "ws://mr-mapping-ws-3f76a2e253dd.herokuapp.com/ws")
    }
    
    let options = [1, 2, 3, 4, 5]
    @State private var selectedOption1 = 1
    @State private var selectedOption2 = 1
    
    var body: some View {
        VStack {
            HStack {
                Picker("出発地", selection: $selectedOption1) {
                    ForEach(options, id: \.self) { option in
                        Text("\(option)")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("到着地", selection: $selectedOption2) {
                    ForEach(options, id: \.self) { option in
                        Text("\(option)")
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Button("スタート") {
                let message = ["id1": selectedOption1, "id2": selectedOption2]
                let jsonData = try? JSONEncoder().encode(message)
                if let jsonString = String(data: jsonData!, encoding: .utf8) {
                    client.send(jsonString)
                }
            }
            .disabled(!client.isConnected)
        }
        .onAppear {
            client.connect()
        }
        .onDisappear {
            client.disconnect()
        }
    }
}
