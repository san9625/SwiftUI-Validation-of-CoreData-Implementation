//
//  ViewModel.swift
//  ValidationOfCoreDataImplementation
//
//  Created by 吉川創麻 on 2023/01/24.
//

import SwiftUI
import CoreData
 
class ViewModel : ObservableObject{
    
    //Itemのプロパティ
    @Published var timestamp = Date()
    @Published var toImageHolder: NSSet?
    @Published var itemProvider = false
    @Published var updateItem : Item?
    
    //ImageHolderのプロパティ
    @Published var imageData: Data = .init(capacity:0)
    @Published var toItem: NSSet?
    
    func writeItemData(context : NSManagedObjectContext ){
        
        if updateItem != nil{
            updateItem!.timestamp = timestamp
            try! context.save()
            
            updateItem = nil
            itemProvider.toggle()
            timestamp = Date()
            return
        }
        
        let newItem = Item(context: context)
        newItem.timestamp = timestamp
        
        do{
            try context.save()
            itemProvider.toggle()
            timestamp = Date()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func setEditedItem(item: Item){
        updateItem = item
        
        timestamp = item.timestamp!
        itemProvider.toggle()
    }
    
    func createImageHolder(item: Item, context : NSManagedObjectContext) {
        //imageDataがある時のみimageHolderを作成する
        if imageData.count != 0 {
            let newImageHolder = ImageHolder(context: context)
            newImageHolder.imageData = imageData
            newImageHolder.timestamp = Date()
            newImageHolder.toItem = item
            
            do{
                try context.save()
                //itemProvider.toggle()
                imageData = .init(capacity:0)
                //toItem = nil
            }
            catch{
                print(error.localizedDescription)
            }
        }

    }
    
}
