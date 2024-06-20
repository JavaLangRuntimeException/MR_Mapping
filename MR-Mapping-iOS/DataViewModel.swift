import Foundation
import SocketIO

class DataViewModel: ObservableObject {
    private let manager = SocketManager(socketURL: URL(string: "ws://mr-mapping-ws-3f76a2e253dd.herokuapp.com/ws")!, config: [.log(true), .compress])
    private var socket: SocketIOClient!
    
    @Published var receivedData: String = ""
    
    func connect() {
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SocketIOに接続しました")
        }
        
        socket.on("data received") { [weak self] data, ack in
            if let receivedData = data[0] as? String {
                DispatchQueue.main.async {
                    self?.receivedData = receivedData
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
