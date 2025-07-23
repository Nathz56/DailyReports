//
//  AddReportView.swift
//  DailyReport
//
//  Created by George Timothy Mars on 22/07/25.
//

import SwiftUI

struct AddReportView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var firestoreManager: FirestoreManager
    
    @State private var categoryID = ""
    @State private var description = ""
    @State private var locationID = ""
    @State private var volunteerID = ""
    @State private var reportTime = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Report Details")) {
                    TextField("Category ID", text: $categoryID)
                    TextField("Description", text: $description)
                    TextField("Location ID", text: $locationID)
                    TextField("Volunteer ID", text: $volunteerID)
                    DatePicker("Report Time", selection: $reportTime, displayedComponents: [.date, .hourAndMinute])
                }
                
                Button("Save") {
                    firestoreManager.addReport(
                        categoryID: categoryID,
                        description: description,
                        locationID: locationID,
                        reportTime: reportTime,
                        volunteerID: volunteerID
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("New Report")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    AddReportView(firestoreManager: FirestoreManager())
}
