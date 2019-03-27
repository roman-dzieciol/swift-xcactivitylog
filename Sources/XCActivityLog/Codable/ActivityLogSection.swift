//
//  ActivityLogSection.swift
//  XCActivityLog
//
//  Created by Roman Dzieciol on 3/18/19.
//

import Foundation

public class ActivityLogSection: Codable {

    public let sectionType: Int
    public let recorder: String
    public let title: String
    public let signature: String
    public let timeStartedRecording: Double
    public let timeStoppedRecording: Double
    public let subsections: [SLFCodable]
    public let text: String
    public let messages: [SLFCodable]
    public let wasCancelled: Int
    public let isQuiet: Int
    public let wasFetchedFromCache: Int
    public let subtitle: String
    public let location: SLFCodable
    public let commandDetailDesc: String
    public let uniqueIdentifier: String
    public let localizedResultString: String
    public let xcbuildSignature: String // hexString
    public let collectMetrics: Int
}

public class ActivityLogUnitTestSection: Codable {

    public let sectionType: Int
    public let recorder: String
    public let title: String
    public let signature: String
    public let timeStartedRecording: Double
    public let timeStoppedRecording: Double
    public let subsections: [SLFCodable]
    public let text: String
    public let messages: [SLFCodable]
    public let wasCancelled: Int
    public let isQuiet: Int
    public let wasFetchedFromCache: Int
    public let subtitle: String
    public let location: SLFCodable
    public let commandDetailDesc: String
    public let uniqueIdentifier: String
    public let localizedResultString: String
    public let xcbuildSignature: String // hexString
    public let collectMetrics: Int

    public let testsPassedString: String
    public let durationString: String
    public let summaryString: String
    public let suiteName: String
    public let testName: String
    public let performanceTestOutputString: String
}

public class CommandLineBuildLog: ActivityLogSection {
}
