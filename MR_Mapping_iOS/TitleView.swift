import SwiftUI

struct TitleView: View {
    
    @State private var showContentView = false
    
    var body: some View {
        VStack {
            Text("MR Mapping")
                .font(.largeTitle)
                .padding()
            
            Button("Start") {
                showContentView = true
            }
            .font(.title)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .fullScreenCover(isPresented: $showContentView) {
            ContentView()
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
