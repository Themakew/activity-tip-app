//
//  CoreDataAPIService.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

import UIKit
import CoreData

protocol CoreDataAPIServiceProtocol {
    func saveData(data: (ActivityEntity, ActivityStatusEntity))
    func fetchData()
}

final class CoreDataAPIService: CoreDataAPIServiceProtocol {

    // MARK: Private Property

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate

    private var context: NSManagedObjectContext?
    private var newActivity: NSManagedObject?

    // MARK: Initializer

    init() {
        context = nil
        newActivity = nil

        openDatabase()
    }

    // MARK: Internal Methods

    func saveData(data: (ActivityEntity, ActivityStatusEntity)) {
        guard let newActivity else {
            return
        }

        newActivity.setValue(data.0.accessibility, forKey: "accessibility")
        newActivity.setValue(data.0.activity, forKey: "activity")
        newActivity.setValue(data.0.key, forKey: "key")
        newActivity.setValue(data.0.link, forKey: "link")
        newActivity.setValue(data.0.participants, forKey: "participants")
        newActivity.setValue(data.0.price.rawValue, forKey: "price")
        newActivity.setValue(data.0.type.rawValue, forKey: "type")
        newActivity.setValue(data.1.status.rawValue, forKey: "userStatus")
        newActivity.setValue(data.1.timeSpent, forKey: "userTimeSpent")

        debugPrint("Storing Data..")
        do {
            try context?.save()
        } catch {
            debugPrint("Storing data Failed")
        }

        fetchData()
    }

    func fetchData() {
        debugPrint("Fetching Data..")

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context?.fetch(request)

            guard let resultCasted = result as? [NSManagedObject] else {
                return
            }

            for (index, data) in resultCasted.enumerated() {
                let activityName = data.value(forKey: "activity") as? String
                let activityType = data.value(forKey: "type") as? String
                debugPrint("Activity Store, number \(index + 1):")
                debugPrint("Activity Name: \(activityName ?? "") | Activity Type: \(activityType ?? "")")
            }
        } catch {
            debugPrint("Fetching data Failed")
        }
    }

    // MARK: Private Methods

    private func openDatabase() {
        if let viewContext = appDelegate?.persistentContainer.viewContext,
           let entity = NSEntityDescription.entity(forEntityName: "Activity", in: viewContext) {
            context = viewContext
            newActivity = NSManagedObject(entity: entity, insertInto: context)
        }
    }
}
