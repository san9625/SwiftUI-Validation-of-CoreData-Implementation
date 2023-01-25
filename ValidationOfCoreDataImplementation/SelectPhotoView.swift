//
//  SelectPhotoView.swift
//  ValidationOfCoreDataImplementation
//
//  Created by 吉川創麻 on 2023/01/22.
//

import SwiftUI
import PhotosUI

struct SelectPhotoView: UIViewControllerRepresentable {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var show:Bool
    //@Binding var image:Data
    var sourceType:UIImagePickerController.SourceType
    
    //@Binding var item: Item?
    @ObservedObject var viewModel : ViewModel

    func makeCoordinator() -> SelectPhotoView.Coodinator {
       return SelectPhotoView.Coordinator(parent: self)
    }
     
    func makeUIViewController(context: UIViewControllerRepresentableContext<SelectPhotoView>) -> UIImagePickerController {
       
       let controller = UIImagePickerController()
       controller.sourceType = sourceType
       controller.delegate = context.coordinator
       
       return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<SelectPhotoView>) {
    }

    class Coodinator: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
       
       var parent : SelectPhotoView
       
       init(parent : SelectPhotoView){
           self.parent = parent
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           self.parent.show.toggle()
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           //写真の選択結果をUIImage型にキャスト
           let image = info[.originalImage] as! UIImage
           //UIImage型からData?型にキャスト
           let data = image.pngData()
           
           self.parent.viewModel.imageData = data!
           
           //self.parent.image = data!
           self.parent.show.toggle()
       }
    }
    
    /*
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isShowSelectPhotoView: Bool
    @Binding var item: Item?
    var image: Data?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SelectPhotoView>) -> PHPickerViewController {
        var conf = PHPickerConfiguration()
        conf.filter = .images
        conf.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: conf)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //処理なし
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: SelectPhotoView
        
        init(parent: SelectPhotoView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    //写真の選択結果（image）をUIImage型にアンラップする
                    if let image_UiImage = image as? UIImage {
                        //SelectPhotoViewの変数imageに選択した写真のデータを格納する
                        self.parent.image = image_UiImage.pngData()
                        
                        //addPhotoData(data: self.parent.image)
                        
                        /*
                        //UIImage型からData型にアンラップする
                        //if let image_Data = image_UiImage.pngData() as? Data {
                            //image_DataからImageHolderをNewする
                            let newImageHolder = ImageHolder(context: viewContext)
                            newImageHolder.imageData = image_UiImage.pngData()
                            newImageHolder.toItem = item

                            do {
                                try viewContext.save()
                            } catch {
                                // Replace this implementation with code to handle the error appropriately.
                                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                            
                        //}
                        */
                        
                    } else {
                        print("写真は選択されていません")
                    }
                }
            }
            
            parent.isShowSelectPhotoView = false
        }//picker
        
    }
    */
    
}
