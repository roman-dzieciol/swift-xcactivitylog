//
//  SLFCodable.swift
//  SWXCActivityLog
//
//  Created by Roman Dzieciol on 3/24/19.
//

import Foundation

/// Wrapper for decoding dynamic object types
///
/// - object: Object of unknown Codable type. Class name is read from SWXCActivityLog
/// - none: nil value
public enum SLFCodable: Codable {

    case object(Codable)
    case none

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try container.decode(SLFCodable.self)
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .object(obj):
            try obj.encode(to: encoder)
        case .none:
            break
        }
    }
}
