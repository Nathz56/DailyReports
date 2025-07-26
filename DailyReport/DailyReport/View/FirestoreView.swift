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
    @EnvironmentObject var authManager: AuthManager
    @State private var isNavigatingToAddReport = false
    @State private var selectedLocationFilter: String? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main content with buttons and reports
                ScrollView {
                    VStack {
                        // Horizontal scroll view for hall filter buttons
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                // "All" button to show all reports
                                Button(action: {
                                    selectedLocationFilter = nil
                                }) {
                                    Text("All")
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedLocationFilter == nil ? Color(red: 219/255, green: 40/255, blue: 78/255) : Color(.systemGray5))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .layoutPriority(1)
                                // Buttons for Hall A, Hall B, Hall C
                                ForEach(["A", "B", "C"], id: \.self) { hall in
                                    Button(action: {
                                        selectedLocationFilter = hall
                                    }) {
                                        Text("Hall \(hall)")
                                            .foregroundColor(selectedLocationFilter == hall ? .white : .white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(selectedLocationFilter == hall ? Color(red: 219/255, green: 40/255, blue: 78/255) : Color(.systemGray5))
                                            )
//                                            .padding(.horizontal, 12)
//                                            .padding(.vertical, 8)
//                                            .background(selectedLocationFilter == nil ? Color(red: 219/255, green: 40/255, blue: 78/255) : Color(.systemGray5))
//                                            .foregroundColor(.white)
//                                            .cornerRadius(10)
                                    }
                                    .layoutPriority(1)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                        
                        // Report cards
                        LazyVStack {
                            ForEach(filteredReports) { report in
                                NavigationLink(destination: ReportDetailView(report: report, firestoreManager: firestoreManager)) {
                                        ReportCardView(report: report, firestoreManager: firestoreManager)
                                    
                                            .frame(width: 357, height: 173)
                                            .cornerRadius(10)
                                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Report List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Sign Out") {
                            try? Auth.auth().signOut()
                        }
                    }
                }
                .onAppear {
                    firestoreManager.getReport()
                    firestoreManager.showAllLocation()
                }
                
                // Floating button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: AddReportView(firestoreManager: firestoreManager), isActive: $isNavigatingToAddReport) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            isNavigatingToAddReport = true
                        }, label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .padding()
                                .background(Color(red: 219/255, green: 40/255, blue: 78/255))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        })
                        .padding()
                    }
                }
            }
        }
    }
    
    var filteredReports: [Report] {
        if let selectedHall = selectedLocationFilter {
            // Get booth IDs for the selected hall
            let boothIDs = firestoreManager.booths
                .filter { $0.hall == selectedHall }
                .map { $0.id }
            
            // Filter reports where locationID matches booth IDs
            return firestoreManager.reports
                .filter { boothIDs.contains($0.locationID) }
                .sorted(by: { $0.reportTime > $1.reportTime })
        } else {
            // Return all reports if no hall is selected
            return firestoreManager.reports
                .sorted(by: { $0.reportTime > $1.reportTime })
        }
    }
}







#Preview {
    FirestoreView()
}




