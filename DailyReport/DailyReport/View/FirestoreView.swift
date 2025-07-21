//
//  FirestoreView.swift
//  DailyReport
//
//  Created by Yonathan Hilkia on 21/07/25.
//

import SwiftUI

struct FirestoreView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var showingAddReport = false
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(firestoreManager.reports) { report in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Description: \(report.description)")
                                    .font(.headline)
                                
                                Text("Category: \(report.categoryID)")
                                    .font(.subheadline)
                                
                                Text("Location: \(report.locationID)")
                                    .font(.subheadline)
                                
//                                if let photo = report.photo {
//                                    Text("Photo URL: \(photo)")
//                                        .font(.footnote)
//                                        .foregroundColor(.blue)
//                                }
                                
                                Text("Time: \(report.reportTime.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text("Volunteer: \(report.volunteerID)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button("Delete") {
                                firestoreManager.deleteReport(report: report)
                            }
                        }
                        .swipeActions {
                            Button("Edit") {
                                // implement your editing logic
                                showingAddReport = true
                            }
                            .tint(.blue)
                        }
                    }
                }
                .navigationTitle("Reports")
                .navigationBarItems(trailing: Button(action: {
                    showingAddReport = true
                }) {
                    Image(systemName: "plus")
                })
                .onAppear {
                    firestoreManager.getReport()
                }
                .sheet(isPresented: $showingAddReport) {
                    AddReportView(firestoreManager: firestoreManager)
                }
            }
        }
    }
}

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
            .navigationTitle("Add Report")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

