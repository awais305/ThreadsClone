//
//  ThreadFilterEnum.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/20/24.
//

import Foundation

enum ThreadsFilterEnum: Int, CaseIterable, Identifiable {
    case threads
    case replies
    
    var title: String {
        switch self {
        case .threads: return "Threads"
        case .replies: return "Replies"
        }
    }
    
    var id: Int { return self.rawValue }
}
