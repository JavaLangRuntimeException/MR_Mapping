import SwiftUI
import SocketIO

struct DataView: View {
    @ObservedObject var viewModel = DataViewModel()
    
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
                viewModel.sendData(id1: selectedOption1, id2: selectedOption2)
            }
        }
        .onAppear {
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
}
