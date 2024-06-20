import Foundation
import SocketIO

class DataViewModel: ObservableObject {
    private let manager = SocketManager(socketURL: URL(string: "https://mr-mapping-ws-3f76a2e253dd.herokuapp.com")!, config: [.log(true), .compress])
    private var socket: SocketIOClient!
    
    @Published var receivedData: String = ""
    
    func connect() {
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("SocketIOに接続しました")
            self?.socket.emit("connection", "Connected to server")
        }
        
        socket.on("data received") { [weak self] data, ack in
            if let dict = data[0] as? [String: Int],
               let id1 = dict["id1"],
               let id2 = dict["id2"] {
                DispatchQueue.main.async {
                    self?.receivedData = "Received data: id1=\(id1), id2=\(id2)"
                }
            }
        }
        
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func sendData(id1: Int, id2: Int) {
        let data = ["id1": id1, "id2": id2]
        socket.emit("send data", data)
    }
}
