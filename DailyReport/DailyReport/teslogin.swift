//
//  teslogin.swift
//  DailyReport
//
//  Created by Yonathan Hilkia on 22/07/25.
//

import SwiftUI
import FirebaseAuth

struct SimpleLoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginStatus = ""
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            FirestoreView() // langsung masuk ke halaman utama
        } else {
            VStack(spacing: 20) {
                Text("Login").font(.largeTitle)

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Login") {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            loginStatus = "❌ \(error.localizedDescription)"
                        } else {
                            loginStatus = "✅ Logged in!"
                            isLoggedIn = true
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Text(loginStatus)
                    .foregroundColor(loginStatus.contains("✅") ? .green : .red)
                    .font(.caption)
            }
            .padding()
        }
    }
}
