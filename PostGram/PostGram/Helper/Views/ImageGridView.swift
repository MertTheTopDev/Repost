import SwiftUI

struct ImageGridView: View {
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var offset: CGFloat = 0
    let scrollSpeed: Double = 30
    
    let imageHeight: CGFloat = 180
    let spacing: CGFloat = 30
    
    var body: some View {
        let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
        
        ZStack(alignment: .top) {
            imagesView
            .offset(y: offset)
            
            imagesView
            .offset(y: offset + 4 * (imageHeight + spacing) )
        }
        .onReceive(timer) { _ in
            withAnimation(.linear(duration: 0.016)) {
                offset -= scrollSpeed * 0.016
                
                let resetPoint = -4 * (imageHeight + spacing) - 32
                if offset <= resetPoint {
                    offset = 0
                }
            }
        }
        .frame(height: 3 * (imageHeight + spacing) + 32)
        .clipped()
        .background(Color.black.opacity(0.05))
        .edgesIgnoringSafeArea(.bottom)
    }
}

private extension ImageGridView {
    
    var imagesView: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(0...7, id: \.self) { _ in
                    Image("image1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: dw(0.3),height: imageHeight)
                        .cornerRadius(12)
                        .clipped()
                        .shadow(radius: 4)
                }
            }
            .padding(46)
        }
    }
    
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
