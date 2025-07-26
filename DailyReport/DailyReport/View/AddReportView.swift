//
//  AddReportView.swift
//  DailyReport
//
//  Created by George Timothy Mars on 22/07/25.
//

import SwiftUI
import FirebaseAuth
import UIKit



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
    
    
    @State private var isShowingActionSheet = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Report Details")) {
                        Button {
                            isShowingActionSheet = true
                        } label: {
                            if selectedImage == nil {
                                Image("placeholder_img")
                                    .padding(60)
                            } else {
                                Image(uiImage: selectedImage!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 200)
                                    .padding(60)
                            }
                        }
                        .actionSheet(isPresented: $isShowingActionSheet) {
                            ActionSheet(
                                title: Text("Select Image Source"),
                                buttons: [
                                    .default(Text("Camera")) {
                                        imageSourceType = .camera
                                        isShowingImagePicker = true
                                    },
                                    .default(Text("Photo Library")) {
                                        imageSourceType = .photoLibrary
                                        isShowingImagePicker = true
                                    },
                                    .cancel()
                                ]
                            )
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePicker(
                                selectedImage: $selectedImage,
                                isShowingImagePicker: $isShowingImagePicker,
                                sourceType: .camera
                            )
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

                        HStack {
                            Text("Volunteer")
                            Spacer()
                            Text(firestoreManager.currentUser?.name ?? "Loading...")
                                .foregroundColor(.blue)
                        }

                        TextField("Description", text: $description)

                        DatePicker(
                            "Report Time",
                            selection: $reportTime,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }

                    Button("Save") {
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
                            
                            firestoreManager.getReport()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(red: 0.86, green: 0.16, blue: 0.31)) // #DB284E
                    .cornerRadius(12)
                }
                
                .navigationTitle("Add Report")
                .navigationBarItems(trailing: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }

}



#Preview {
    AddReportView(firestoreManager: FirestoreManager())
}
