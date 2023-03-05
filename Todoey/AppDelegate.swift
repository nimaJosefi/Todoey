
import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // the following config settings are necessary to update "try! Realm()" to current realm needs 
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // do nothing, realm will manage
                }
            })

        Realm.Configuration.defaultConfiguration = config
        
         // figure out path to realm file:
         //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            
            _ = try Realm()
        } catch let error as NSError { // let error as NSError self added from docs 
            print("Error initializing new realm \(error)")
        }
        
        return true
    }
    
}

