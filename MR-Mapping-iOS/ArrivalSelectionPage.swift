import SwiftUI

struct ArrivalSelectionPage: View {
    let onButtonTapped: (Int) -> Void
    
    var body: some View {
        VStack {
            Text("Arrival Selection Page")
            Button("Test 1") {
                onButtonTapped(1)
            }
            Button("Test 2") {
                onButtonTapped(2)
            }
        }
    }
}

