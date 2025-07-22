//
//  FirebaseViewModel.swift
//  DailyReport
//
//  Created by Yonathan Hilkia on 21/07/25.
//

import FirebaseFirestore

class FirestoreManager: ObservableObject {
    
    private var db = Firestore.firestore()
    @Published var reports: [Report] = []
    
    //create report
    func addReport(categoryID: String, description: String, locationID: String, reportTime: Date, volunteerID: String) {
        
        let newReport = Report(categoryID: categoryID, description: description, locationID: locationID, reportTime: reportTime, volunteerID: volunteerID)
        
        do {
            _ = try db.collection("Reports").addDocument(from: newReport)
        } catch {
            print("Error adding report: \(error)")
        }
    }
    
    // read reports
    func getReport() {
        db.collection("Reports").order(by: "reportTime").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting reports: \(error)")
                return
            }
            
            self.reports = snapshot?.documents.compactMap { document in
                try? document.data(as: Report.self)
            } ?? []
        }
    }
    
    // update reports
    func updateReport(report: Report) {
        guard let reportID = report.id else { return }
        
        do {
            try db.collection("Reports").document(reportID).setData(from: report)
        } catch {
            print("Error updating report: \(error)")
        }
    }
    
    // Delete reports
    func deleteReport(report: Report) {
        guard let reportID = report.id else { return }
        
        db.collection("Reports").document(reportID).delete { error in
            if let error = error {
                print("Error deleting reports: \(error)")
            }
        }
    }
    

    func getCategoryName(fromCategoryID categoryID: String, completion: @escaping (String) -> Void) {
        db.collection("Categories").document(categoryID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching category: \(error)")
                completion("Unknown Category")
                return
            }
            
            guard let data = snapshot?.data(),
                  let categoryName = data["name"] as? String else {
                print("⚠️ Category name not found.")
                completion("Unknown Category")
                return
            }
            
            completion(categoryName)
        }
    }

    func getVolunteerName (fromVolunteerID volunteerID: String, completion: @escaping (String) -> Void) {
        db.collection("Volunteers").document(volunteerID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching category: \(error)")
                completion("Unknown Volunteer")
                return
            }
            
            guard let data = snapshot?.data(),
                  let volunteerName = data["vname"] as? String else {
                print("⚠️ Volunteer name not found.")
                completion("Unknown Volunteer")
                return
            }
            
            completion(volunteerName)
        }
    }



    
}
