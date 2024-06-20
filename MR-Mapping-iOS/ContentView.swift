import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: DataView()) {
                    Text("データ送受信画面へ")
                }
            }
            .navigationBarTitle("メイン画面", displayMode: .inline)
        }
    }
}

