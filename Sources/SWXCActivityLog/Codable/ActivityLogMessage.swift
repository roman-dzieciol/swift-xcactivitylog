//
//  ActivityLogMessage.swift
//  SWXCActivityLog
//
//  Created by Roman Dzieciol on 3/18/19.
//

import Foundation

public class ActivityLogMessage: Codable {

    public let title: String
    public let shortTitle: String
    public let timeEmitted: Int
    public let rangeInSectionText: NSRange
    public let submessages: [SLFCodable]
    public let severity: Int
    public let type: String
    public let location: SLFCodable
    public let categoryIdent: String
    public let secondaryLocations: [SLFCodable]
    public let additionalDescription: String
}

public class DiagnosticActivityLogMessage: ActivityLogMessage {
}

public class ClangDiagnosticActivityLogMessage: DiagnosticActivityLogMessage {
}
