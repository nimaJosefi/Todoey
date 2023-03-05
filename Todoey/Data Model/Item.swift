

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title = ""
    @Persisted var done = false
    @Persisted var dateCreated: Date?
    
    // relation to category:
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
