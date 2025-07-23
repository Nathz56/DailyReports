//
//  DailyReportApp.swift
//  DailyReport
//
//  Created by Yonathan Hilkia on 21/07/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct DailyReportApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authManager = AuthManager()
    var body: some Scene {
        WindowGroup {
            Group{
                if authManager.isLoading {
                    ZStack {
                        Image("fd")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                    }.transition(.opacity)
                } else if authManager.isLoggedIn {
                    if authManager.isAdmin {
                        DashboardView()  // Admin view
                           
                    } else {
                        FirestoreView()  // Volunteer view
                         
                    }
                } else {
                    LandingPageView()  // Login view
                  
                }
            }
            .animation(.easeInOut(duration: 1), value: authManager.isLoading)
            .animation(.easeInOut(duration: 1), value: authManager.isLoggedIn)
            .environmentObject(authManager)
        }
            SimpleLoginView()        }
    }
}
