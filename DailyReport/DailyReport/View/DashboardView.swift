//
//  DashboardView.swift
//  DailyReport
//
//  Created by sam on 22/07/25.
//

import SwiftUI
import FirebaseAuth

struct DashboardView: View {
    var body: some View {
        Text("Dasbord!")
        Button("Sign Out") {
            try? Auth.auth().signOut()
        }
    }
}
