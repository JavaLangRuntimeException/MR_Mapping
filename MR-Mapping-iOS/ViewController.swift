import UIKit

class ViewController: UIViewController {
    
    var webSocket: URLSessionWebSocketTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WebSocketの接続先URL
        let url = URL(string: "ws://mr-mapping-0803eb6691db.herokuapp.com/ws")!
        
        // WebSocketの接続
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
    }
    
    // 1から4の数値が選択されたときに呼ばれるメソッド
    func numberSelected(_ number: Int) {
        // 選択された数値に対応するメッセージを作成
        let message = "{\"name\", \"\(number)\"}"
        
        // メッセージをUTF8エンコードしてData型に変換
        let messageData = message.data(using: .utf8)
        
        // メッセージの送信
        webSocket?.send(.data(messageData!)) { error in
            if let error = error {
                print("Failed to send message: \(error)")
            } else {
                print("Message sent: \(message)")
            }
        }
    }
    
    // 1番が選択されたとき
    @IBAction func button1Tapped(_ sender: Any) {
        numberSelected(1)
    }
    
    // 2番が選択されたとき
    @IBAction func button2Tapped(_ sender: Any) {
        numberSelected(2)
    }
    
    // 3番が選択されたとき
    @IBAction func button3Tapped(_ sender: Any) {
        numberSelected(3)
    }
    
    // 4番が選択されたとき
    @IBAction func button4Tapped(_ sender: Any) {
        numberSelected(4)
    }
}

