//
//  FirestoreView.swift
//  DailyReport
//
//  Created by Yonathan Hilkia on 21/07/25.
//

import SwiftUI
import FirebaseAuth
import UIKit

struct FirestoreView: View {
    
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var showingAddReport = false
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(firestoreManager.reports) { report in
                        ReportRowView(report: report, firestoreManager: firestoreManager)
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
                .navigationBarItems(leading:  Button("Sign Out") {
                    try? Auth.auth().signOut()
                })
            }
        }
    }
}

struct ReportRowView: View {
    let report: Report
    let firestoreManager: FirestoreManager
    
    @State private var categoryName: String = "Loading..."
    @State private var volunteerName: String = "Loading..."
    @State private var locationDetails: String = "Loading..."
    
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Description: \(report.description)")
                    .font(.subheadline)
                
                Text("Category: \(categoryName)")
                    .font(.subheadline)
                
                Text("Location: \(locationDetails)")
                    .font(.subheadline)
                
                Text("Volunteer: \(volunteerName)")
                    .font(.subheadline)
                //                    .foregroundColor(.gray)
                
                Text("Time: \(report.reportTime.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if let imageURL = report.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                    }
                }

                
                
            }
            Spacer()
            //            Button("Delete") {
            ////                firestoreManager.deleteReport(report: report)
            //            }
        }
        .onAppear {
            firestoreManager.getCategoryName(fromCategoryID: report.categoryID) { name in
                DispatchQueue.main.async {
                    self.categoryName = name
                }
            }
            
            firestoreManager.getCurrentVolunteerName(fromVolunteerID: report.volunteerID) { name in
                DispatchQueue.main.async {
                    self.volunteerName = name
                }
            }
            
            firestoreManager.getLocationName(fromLocationID: report.locationID) { name in
                DispatchQueue.main.async {
                    self.locationDetails = name
                }
            }
            firestoreManager.getCurrentUser()
            firestoreManager.showAllCategory()
            firestoreManager.showAllLocation()
        }
    }
}

struct AddReportView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var firestoreManager: FirestoreManager
    
    @State private var categoryID = ""
    @State private var description = ""
    @State private var locationID = ""
    //    @State private var volunteerID = ""
    @State private var reportTime = Date()
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Report Details")) {
                    Button {
                        //show image picker
                        isShowingImagePicker = true
                    } label: {
                        if selectedImage == nil {
                            Image("placeholder_img")
                                .padding(60)
                        } else {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .padding(60)
                        }
                    }
                    .sheet (isPresented: $isShowingImagePicker, onDismiss: nil) {
                        //image picker
                        ImagePicker(selectedImage: $selectedImage, isShowingImagePicker: $isShowingImagePicker)
                    }
                    Picker("Select Category", selection: $categoryID) {
                        ForEach(firestoreManager.categories) { category in
                            Text(category.name).tag(category.id)
                        }
                    }
                    Picker("Select Location", selection: $locationID) {
                        ForEach(firestoreManager.booths) { location in
                            Text(location.name).tag(location.id)
                        }
                    }
                    Section {
                        HStack {
                            Text("Volunteer")
                            Spacer()
                            Text(firestoreManager.currentUser?.name ?? "Loading...")
                                .foregroundColor(.blue)
                        }
                    }
                    TextField("Description", text: $description)
                    
                    DatePicker("Report Time", selection: $reportTime, displayedComponents: [.date, .hourAndMinute])
                }
                
                Button("Save") {
                    guard let volunteer = firestoreManager.currentUser else {
                        print("❌ Volunteer not loaded")
                        return
                    }
                    
                    if let image = selectedImage {
                        let fileName = "reports/\(UUID().uuidString).jpg"
                        SupabaseManager.shared.uploadImage(image, fileName: fileName) { result in
                            switch result {
                            case .success(let imageURL):
                                DispatchQueue.main.async {
                                    saveReport(with: imageURL)
                                }
                            case .failure(let error):
                                print("❌ Failed to upload image: \(error.localizedDescription)")
                                DispatchQueue.main.async {
                                    saveReport(with: nil)
                                }
                            }
                        }
                    } else {
                        saveReport(with: nil)

                    }
                    
                    func saveReport(with imageURL: String?) {
                        guard let volunteer = firestoreManager.currentUser else {
                            print("❌ Volunteer not loaded")
                            return
                        }
                        firestoreManager.addReport(
                            categoryID: categoryID,
                            description: description,
                            locationID: locationID,
                            reportTime: reportTime,
                            volunteerID: volunteer.id,
                            imageURL: imageURL
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
}





#Preview {
    FirestoreView()
}




