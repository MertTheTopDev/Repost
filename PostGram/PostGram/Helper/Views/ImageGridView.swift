import SwiftUI

struct ImageGridView: View {
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var offset: CGFloat = 0
    let scrollSpeed: Double = 30
    
    let imageHeight: CGFloat = 180
    let spacing: CGFloat = 40
    
    var body: some View {
        let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
        
        GeometryReader { geometry in
            let contentHeight = calculateContentHeight(width: geometry.size.width)
            
            ZStack(alignment: .top) {
                // First set of images
                imagesView
                    .offset(y: offset)
                
                // Second set of images (identical) positioned exactly after the first set
                imagesView
                    .offset(y: offset + contentHeight)
                
                // Third set for extra smoothness
                imagesView
                    .offset(y: offset + 2 * contentHeight)
            }
            .onReceive(timer) { _ in
                withAnimation(.linear(duration: 0.016)) {
                    offset -= scrollSpeed * 0.016
                    
                    // Reset exactly when first set is completely off-screen
                    if offset <= -contentHeight {
                        offset = 0
                    }
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.7)
        .clipped()
    }
    
    // Calculate exact content height for seamless looping
    func calculateContentHeight(width: CGFloat) -> CGFloat {
        let numberOfItems = 12 // Update this based on your actual number of items
        let rows = ceil(Double(numberOfItems) / 3.0)
        return CGFloat(rows) * (imageHeight + spacing)
    }
}

private extension ImageGridView {
    var imagesView: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(0..<12, id: \.self) { index in
                let isMiddleColumn = index % 3 == 1
                let verticalOffset: CGFloat = isMiddleColumn ? 20 : 0
                
                Image("image1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: dw(0.25), height: imageHeight)
                    .cornerRadius(12)
                    .clipped()
                    .shadow(radius: 4)
                    .offset(y: verticalOffset)
            }
        }
        .padding(.horizontal, 16)
    }
}

// Assuming dw is a function for dynamic width, if not defined:
func dw(_ multiplier: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.width * multiplier
}

struct ContentView: View {
    var body: some View {
        ImageGridView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
