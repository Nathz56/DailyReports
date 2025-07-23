//
//  Firebase.swift
//  DailyReport
//
//  Created by Yonathan Hilkia on 21/07/25.
//

import FirebaseFirestore

struct Report: Identifiable, Codable {
    @DocumentID var id: String?
    var categoryID: String
    var description: String
    var locationID: String
    var reportTime: Date
    var volunteerID: String
//    var imageURL: String?
}
