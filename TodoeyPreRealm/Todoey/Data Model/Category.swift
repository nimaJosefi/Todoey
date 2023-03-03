

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name = ""
    
    // let's make the forward relationship category has to item
    let items = List<Item>() // initialize as an empty list of items
    // to make the opposite relationship we need to head back to item file 
}
