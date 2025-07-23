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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                Text("Report No. \(report.id ?? "Unknown")")
                    .font(.headline)

                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Category: \(categoryName)")
                            .font(.subheadline)

                        Text("Location: \(report.locationID)")
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
            
            firestoreManager.getVolunteerName(fromVolunteerID: report.volunteerID) { name in
                DispatchQueue.main.async {
                    self.volunteerName = name
                }
            }
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
