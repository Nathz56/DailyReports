//
//  ReportCardView.swift
//  DailyReport
//
//  Created by George Timothy Mars on 22/07/25.
//

import SwiftUI

struct ReportCardView: View {
    let report: Report
    let firestoreManager: FirestoreManager
    
    @State private var categoryName: String = "Loading..."
    @State private var volunteerName: String = "Loading..."
    @State private var locationDetails: String = "Loading..."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                Text("Report No. \(report.id ?? "Unknown")")
                    .font(.headline)

                HStack(alignment: .top, spacing: 12) {
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
 
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Category: \(categoryName)")
                            .font(.subheadline)

                        Text("Location: \(locationDetails)")
                            .font(.subheadline)
                        
                        
                        Text("Volunteer: \(volunteerName)")
                            .font(.subheadline)
                           

                        Text("Time: \(report.reportTime.formatted(date: .abbreviated, time: .shortened))")
                            .font(.subheadline)
                            

                    }
                }
            }
            .frame( width: 357, height: 173)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
            .background(Color.white)
        
        .padding()
        .onAppear {
            // Load category name when the row appears
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

#Preview {
    ReportCardView(report: Report(
        id: "00001",
        categoryID: "queue",
        description: "Crowded in Hall A",
        locationID: "BCA",
        reportTime: Date(),
        volunteerID: "vol01"
    ),
    firestoreManager: FirestoreManager())
}
