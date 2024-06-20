import Foundation
import Starscream

class DataViewModel: ObservableObject {
    private var socket: WebSocket!
    
    @Published var receivedData: String = ""
    
    func connect() {
        guard let url = URL(string: "wss://mr-mapping-ws-3f76a2e253dd.herokuapp.com") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func sendData(id1: Int, id2: Int) {
        let data = ["id1": id1, "id2": id2]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        socket.write(string: jsonString)
    }
}

extension DataViewModel: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("Websocket connected with headers: \(headers)")
        case .disconnected(let reason, let code):
            print("Websocket disconnected with reason: \(reason) and code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            if let data = string.data(using: .utf8),
               let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Int],
               let id1 = dict["id1"],
               let id2 = dict["id2"] {
                DispatchQueue.main.async {
                    self.receivedData = "Received data: id1=\(id1), id2=\(id2)"
                }
            }
        case .binary(let data):
            print("Received binary data: \(data)")
        case .ping(_), .pong(_), .viabilityChanged(_), .reconnectSuggested(_), .cancelled:
            break
        case .error(let error):
            print("Websocket error: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
    
    func didReceive(error: Error, client: WebSocket) {
        print("Websocket error: \(error.localizedDescription)")
    }
    
    func didReceive(webSocketConnectionChange connectionChange: WebSocketConnectionChange, client: WebSocket) {
        switch connectionChange {
        case .connected:
            print("Websocket connected")
        case .disconnected:
            print("Websocket disconnected")
        }
    }
}
