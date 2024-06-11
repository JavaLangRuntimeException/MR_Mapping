import SwiftUI

struct ContentView: View {
    
    @Environment(\.presentationMode) var presentationMode
        @State private var webSocket: URLSessionWebSocketTask?
    
    var body: some View {
        VStack {
            Text("Select a number:")
            
            HStack {
                Button("1") {
                    sendMessage(number: 1)
                }
                
                Button("2") {
                    sendMessage(number: 2)
                }
                
                Button("3") {
                    sendMessage(number: 3)
                }
                
                Button("4") {
                    sendMessage(number: 4)
                }
            }
            Button("Back") {
                            disconnectFromWebSocket()
                            presentationMode.wrappedValue.dismiss()
                        }
        }
        .onAppear {
            connectToWebSocket()
        }
        .onDisappear {
            disconnectFromWebSocket()
        }
    }
    
    func connectToWebSocket() {
        print("connected")
        let url = URL(string: "ws://mr-mapping-0803eb6691db.herokuapp.com/ws")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        
    }
    
    func disconnectFromWebSocket() {
        webSocket?.cancel(with: .normalClosure, reason: nil)
    }
    
    func sendMessage(number: Int) {
        let message = "{\"start\", \"\(number)\"}"
        let messageData = message.data(using: .utf8)
        webSocket?.send(.data(messageData!)) { error in
            if let error = error {
                print("Failed to send message: \(error)")
            } else {
                print("Message sent: \(message)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
