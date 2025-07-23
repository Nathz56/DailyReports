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
                    firestoreManager.addReport(
                        categoryID: categoryID,
                        description: description,
                        locationID: locationID,
                        reportTime: reportTime,
                        volunteerID: volunteer.id
                        
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
        }
        
    }
}

#Preview {
    AddReportView(firestoreManager: FirestoreManager())
}
