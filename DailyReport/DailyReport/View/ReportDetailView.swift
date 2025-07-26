//
//  ReportDetailView.swift
//  DailyReport
//
//  Created by George Timothy Mars on 24/07/25.
//

import SwiftUI

struct ReportDetailView: View {
    let report: Report
    @ObservedObject var firestoreManager: FirestoreManager
    
    @State private var categoryName = ""
    @State private var volunteerName = ""
    @State private var locationName = ""
    @State private var hallName = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL = report.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 200)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                        case .failure:
                            Text("Failed to load image")
                                .frame(height: 200)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Text("Reporter:")
                    .font(.headline)
                TextBox(text: volunteerName)
                
                Text("Hall:")
                    .font(.headline)
                TextBox(text: hallName)
                
                Text("Location:")
                    .font(.headline)
                TextBox(text: locationName)
                
                Text("Category:")
                    .font(.headline)
                TextBox(text: categoryName)

                Text("Report Time:")
                    .font(.headline)
                TextBox(text: report.reportTime.formatted(date: .long, time: .shortened))
                
                Text("Note:")
                    .font(.headline)
                TextBox(text: report.description)
            }
            .padding()
        }
        .navigationTitle("Report Detail")
        .onAppear {
            firestoreManager.getCategoryName(fromCategoryID: report.categoryID) { name in
                categoryName = name
            }
            firestoreManager.getCurrentVolunteerName(fromVolunteerID: report.volunteerID) { name in
                volunteerName = name
            }
            firestoreManager.getLocationForDetail(fromLocationID: report.locationID) { name in
                locationName = name
            }
            firestoreManager.getHall(fromLocationID: report.locationID) { name in
                hallName = name
            }
        }
    }

}

struct TextBox: View {
    var text: String
    var body: some View {
        Text(text)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

#Preview {
    ReportDetailView(report: Report(
        id: "00001",
        categoryID: "queue",
        description: "Crowded in Hall A",
        locationID: "BCA",
        reportTime: Date(),
        volunteerID: "vol01"
    ),
    firestoreManager: FirestoreManager())
}
