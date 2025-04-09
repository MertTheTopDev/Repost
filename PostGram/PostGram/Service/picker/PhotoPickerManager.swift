import SwiftUI
import PhotosUI

final class PhotoPickerManager: NSObject {
    static let shared = PhotoPickerManager()
    
    @Published var selectedImage: UIImage?
    var isPresenting = false
    private var completion: ((UIImage?) -> Void)?
    
    private override init() {
        super.init()
    }
    
    func selectPhoto(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Root view controller bulunamadı")
            completion(nil)
            return
        }
        
        // En üstteki görünür view controller'ı bul
        var topController = rootViewController
        while let presentedController = topController.presentedViewController {
            topController = presentedController
        }
        
        // Eğer controller zaten bir sunumu işliyorsa, önceki sunumun bitmesini bekle
        if topController.isBeingPresented || topController.isBeingDismissed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.selectPhoto(completion: completion)
            }
            return
        }
        
        // Picker oluştur
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        topController.present(picker, animated: true)
    }
}

extension PhotoPickerManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else {
            completion?(nil)
            return
        }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self?.completion?(nil)
                    }
                    return
                }
                
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.completion?(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.completion?(nil)
                    }
                }
            }
        } else {
            completion?(nil)
        }
    }
}

// Kullanım örneği
/*
struct ContentView: View {
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("Resim seçmek için tıklayın")
                    .padding()
            }
        }
        .onTapGesture {
            PhotoPickerManager.shared.selectPhoto { image in
                selectedImage = image
            }
        }
    }
}
*/
