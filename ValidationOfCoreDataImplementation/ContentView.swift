//
//  ContentView.swift
//  ValidationOfCoreDataImplementation
//
//  Created by 吉川創麻 on 2023/01/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @FetchRequest(
        entity: ImageHolder.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ImageHolder.timestamp, ascending: false)]
    )
    private var itemImages: FetchedResults<ImageHolder>
    
    //isShowSelectPhotoView, imageData, sourceはSelectPhotoViewに渡す状態変数
    @State var isShowSelectPhotoView = false
    @State var imageData : Data = .init(capacity:0)
    @State var source:UIImagePickerController.SourceType = .photoLibrary
    
    @StateObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        //各itemごとのView
                        VStack {
                            HStack{
                                //各item画面のカメラボタンを押すことで写真を撮ってitemに写真データを追加する
                                Button(action: {
                                    print("itemに写真データを追加する")
                                    source = .camera
                                    isShowSelectPhotoView.toggle()
                                }, label: {
                                    Image(systemName: "camera")
                                })
                                .padding()
                                
                                //各item画面のアルバムボタンを押すことでitemに写真データを追加する
                                Button(action: {
                                    print("itemに写真データを追加する")
                                    source = .photoLibrary
                                    isShowSelectPhotoView.toggle()
                                }, label: {
                                    Image(systemName: "photo")
                                })
                                .padding()
                                
                                //各item画面のプラスボタンを押すことでitemを追加する
                                Button(action: {
                                    print("itemを追加する")
                                    viewModel.writeItemData(context: viewContext)
                                }, label: {
                                    Image(systemName: "plus")
                                })
                                .padding()
                            }
                            
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            
                            //写真データがあれば表示する
                            if item.toImageHolder?.count != 0 {
                                Text("データがあります")
                                let images = itemImages.filter({ image in image.toItem == item})
                                ForEach(images) {image in
                                    Image(uiImage: UIImage(data: image.imageData!)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 250)
                                        .cornerRadius(15)
                                        .padding()
                                }
                            }
                            
                        }//VStack
                        .sheet(isPresented: $isShowSelectPhotoView) {
                            SelectPhotoView(show: $isShowSelectPhotoView, sourceType: source, viewModel: viewModel)
                                .onDisappear{
                                    viewModel.createImageHolder(item: item, context: viewContext)
                            }
                        }
                        
                        
                    } label: {
                        //ForEachで繰り返し表示するかくitemのView
                        Text(item.timestamp!, formatter: itemFormatter)
                    }//NavigationLink
                }
                .onDelete(perform: deleteItems)
            }//List
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
