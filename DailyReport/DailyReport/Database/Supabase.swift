//
//  Supabase.swift
//  DailyReport
//
//  Created by Yonathan Hilkia on 23/07/25.
//

import Supabase
import Foundation
import UIKit
import SwiftUI

class SupabaseManager {
    static let shared = SupabaseManager()

    private let client = SupabaseClient(
        supabaseURL: URL(string: "https://fwwlfmyclddmshezqnvq.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3d2xmbXljbGRkbXNoZXpxbnZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMyMzMyMzEsImV4cCI6MjA2ODgwOTIzMX0.haVK_rKXwaw9YxmNg5vFjToi1YGU3mYKJavmHnSsWaU" // replace with your real anon key
    )

    func uploadImage(_ image: UIImage, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(.failure(NSError(domain: "Invalid image", code: 0)))
            return
        }

        Task {
            do {
                let bucket = client.storage.from("dailygents")
                try await bucket.upload(path: fileName, file: imageData, options: FileOptions(contentType: "image/jpeg"))
                
                let publicURL = try bucket.getPublicURL(path: fileName)
                completion(.success(publicURL.absoluteString))
            } catch {
                completion(.failure(error))
            }
        }
    }
}





