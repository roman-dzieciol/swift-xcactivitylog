import XCTest
import XCActivityLog

@available(OSX 10.13, *)
final class XCActivityLogTests: XCTestCase {

    var tempDirURL: URL!

    override func setUp() {
        super.setUp()
        tempDirURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    }

    override func tearDown() {
        tempDirURL = nil
        super.tearDown()
    }

    func testCleanAnalyzeTest() throws {
        let url = URL(fileURLWithPath: "\(#file)")
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("ResultBundles")
            .appendingPathComponent("CleanAnalyzeTest.result")

        try testLog(url: url
            .appendingPathComponent("1_Run")
            .appendingPathComponent("build.xcactivitylog"))

        try testLog(url: url
            .appendingPathComponent("2_Analyze")
            .appendingPathComponent("build.xcactivitylog"))

        try testLog(url: url
            .appendingPathComponent("3_Test")
            .appendingPathComponent("build.xcactivitylog"))

        try testLog(url: url
            .appendingPathComponent("3_Test")
            .appendingPathComponent("action.xcactivitylog"))
    }

    static var allTests = [
        ("testCleanAnalyzeTest", testCleanAnalyzeTest),
    ]
}

@available(OSX 10.13, *)
extension XCActivityLogTests {

    func testLog(url: URL) throws {
        do {
            // Decode
            let decoder = SLFDecoder()
            let data = try Data(contentsOf: url)
            let log = try decoder.decode(ActivityLog.self, from: data)

            // Encode as JSON
            let outputURL = try self.outputURL(from: url)
            try writeAsJSON(log: log, from: url, to: outputURL)

            // Compare JSON to baseline
            let baselineURL = url.appendingPathExtension("json")
            XCTAssertTrue(try diff(url: outputURL, with: baselineURL))
        } catch {
            NSLog("\(error)")
            throw error
        }
    }

    private func outputURL(from url: URL) throws -> URL {
        let components = url.pathComponents.dropLast().suffix(3)
        let outputDirURL = components.reduce(tempDirURL) { (url, component) -> URL in
            return url.appendingPathComponent(component)
        }
        try FileManager.default.createDirectory(at: outputDirURL, withIntermediateDirectories: true, attributes: [:])
        let outputURL = outputDirURL
            .appendingPathComponent(url.lastPathComponent)
            .appendingPathExtension("json")
        return outputURL
    }

    private func writeAsJSON(log: ActivityLog, from: URL, to: URL) throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let outputData = try jsonEncoder.encode(log)
        NSLog("Writing to: \(to.path)")
        try outputData.write(to: to)
    }

    private func diff(url: URL, with otherURL: URL) throws -> Bool {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = [
            "diff",
            url.standardized.path,
            otherURL.standardized.path
        ]
        try process.run()
        process.waitUntilExit()
        return process.terminationStatus == EXIT_SUCCESS
    }
}
