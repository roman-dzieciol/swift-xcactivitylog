//
//  ActivityLog.swift
//  XCActivityLog
//
//  Created by Roman Dzieciol on 3/24/19.
//

import Foundation

/// XCActivityLog top level structure
public struct ActivityLog: Codable {

    public let magic: UInt32
    public let version: UInt
    public let root: SLFCodable
}
