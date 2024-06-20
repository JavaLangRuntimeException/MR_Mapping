import SwiftUI

struct TitlePage: View {
    let onStartButtonTapped: () -> Void
    
    var body: some View {
        VStack {
            Text("Title Page")
            Button("Start") {
                onStartButtonTapped()
            }
        }
    }
}

