//
//  Timestamp.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 10/8/24.
//

import Foundation
import Firebase

extension Timestamp {
    func toTimeAgoString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self.dateValue(), to: Date()) ?? ""
    }
}
