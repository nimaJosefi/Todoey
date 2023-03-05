
import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name = ""
    
    // eventual forward relationship category will have to many items
    
    //let items = List<Item>() // initialize as an empty list of items is outdated, therefore:
    @Persisted var items = List<Item>()
}

// to make the opposite relationship we need to head back to item file

