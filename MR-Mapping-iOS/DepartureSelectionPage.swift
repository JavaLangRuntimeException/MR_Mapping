import SwiftUI

struct DepartureSelectionPage: View {
    let onButtonTapped: (Int) -> Void
    
    var body: some View {
        VStack {
            Text("Departure Selection Page")
            Button("Test 1") {
                onButtonTapped(1)
            }
            Button("Test 2") {
                onButtonTapped(2)
            }
        }
    }
}

