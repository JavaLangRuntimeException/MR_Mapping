import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    MapShape()
                        .frame(height: 200)
                        .padding(.horizontal, 20)
                    
                    Text("Interactive World Navigator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    NavigationLink(destination: DataView()) {
                        Text("スタート")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationBarTitle("メイン画面", displayMode: .inline)
        }
    }
}

struct MapShape: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 0.75
                let spacing = width * 0.030
                let middle = width * 0.5
                let topWidth = width * 0.226
                let topHeight = height * 0.488
                
                path.addLines([
                    CGPoint(x: middle, y: spacing),
                    CGPoint(x: middle - topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing),
                    CGPoint(x: middle + topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: spacing)
                ])
                
                path.move(to: CGPoint(x: middle, y: topHeight / 2 + spacing * 3))
                path.addLines([
                    CGPoint(x: middle - topWidth, y: topHeight + spacing),
                    CGPoint(x: spacing, y: height - spacing),
                    CGPoint(x: width - spacing, y: height - spacing),
                    CGPoint(x: middle + topWidth, y: topHeight + spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing * 3)
                ])
            }
            .fill(Color.white)
            .overlay(
                Path { path in
                    let width = min(geometry.size.width, geometry.size.height)
                    let height = width * 0.75
                    let spacing = width * 0.030
                    let middle = width * 0.5
                    let topWidth = width * 0.226
                    let topHeight = height * 0.488
                    
                    path.addLines([
                        CGPoint(x: middle, y: spacing),
                        CGPoint(x: middle - topWidth, y: topHeight - spacing),
                        CGPoint(x: middle, y: topHeight / 2 + spacing),
                        CGPoint(x: middle + topWidth, y: topHeight - spacing),
                        CGPoint(x: middle, y: spacing)
                    ])
                    
                    path.move(to: CGPoint(x: middle, y: topHeight / 2 + spacing * 3))
                    path.addLines([
                        CGPoint(x: middle - topWidth, y: topHeight + spacing),
                        CGPoint(x: spacing, y: height - spacing),
                        CGPoint(x: width - spacing, y: height - spacing),
                        CGPoint(x: middle + topWidth, y: topHeight + spacing),
                        CGPoint(x: middle, y: topHeight / 2 + spacing * 3)
                    ])
                }
                .stroke(Color.blue, lineWidth: 4)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
}
