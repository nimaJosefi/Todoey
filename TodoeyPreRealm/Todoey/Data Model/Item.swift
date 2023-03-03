

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var done = false
    @Persisted var title = ""
    
    // relation to category:
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
