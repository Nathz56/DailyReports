//
//  FirestoreViewBackup.swift
//  DailyReport
//
//  Created by George Timothy Mars on 24/07/25.
//

import SwiftUI
import FirebaseAuth
import UIKit

struct FirestoreViewBackup: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var showingAddReport = false
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack{
            VStack {
                NavigationView {
                    ScrollView {
                        LazyVStack{
                            ForEach(firestoreManager.reports) { report in
                                ReportCardView(report: report, firestoreManager: firestoreManager)
                                    .swipeActions {
                                        Button("Edit") {
                                            // implement your editing logic
                                            showingAddReport = true
                                        }
                                        .tint(.blue)
                                    }
                            }
                            .frame( width: 357, height: 173)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                        }
                        .padding()
                    }
                    .navigationTitle("Report List")
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
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        showingAddReport = true
                    }, label: {
                        Image(systemName: "plus")
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                            .background(Color(red: 219/255, green: 40/255, blue: 78/255))
                            .clipShape(Circle())
                    })
                    .padding()
                    .shadow(radius: 2)
                }
                
            }
            
        }
        
    }
}


#Preview {
    FirestoreViewBackup()
}
