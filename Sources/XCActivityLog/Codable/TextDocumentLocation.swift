//
//  TextDocumentLocation.swift
//  XCActivityLog
//
//  Created by Roman Dzieciol on 3/18/19.
//

import Foundation

public class DocumentLocation: Codable {

    public let documentURLString: String
    public let timestamp: Double
}

public class TextDocumentLocation: Codable {

    public let documentURLString: String
    public let timestamp: Double
    public let startingLineNumber: Int
    public let startingColumnNumber: Int
    public let endingLineNumber: Int
    public let endingColumnNumber: Int
    public let characterRange: NSRange
    public let locationEncoding: Int
}
