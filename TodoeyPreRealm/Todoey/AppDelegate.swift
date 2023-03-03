
import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
         // figure out where realm is
         print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
           let realm = try Realm()
        } catch {
            print("Error initializing new realm \(error)")
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // user or system triggered (i.e relocate resources to something else)
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    // 'lazy' only gets triggered when you try to use it; so there's a memory benefit here
    lazy var persistentContainer: NSPersistentContainer = {
        // container is our permanent storage location (like having committed to git) 
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    // note 'context' is like staging in git prior to commit
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    

}

