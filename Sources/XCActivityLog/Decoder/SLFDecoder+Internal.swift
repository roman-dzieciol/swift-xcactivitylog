//
//  SLFDecoder+Internal.swift
//  XCActivityLog
//
//  Created by Roman Dzieciol on 3/27/19.
//

import Foundation

final internal class _SLFDecoder {

    internal var data: SLFData
    internal var codingPath: [CodingKey] = []
    internal var userInfo: [CodingUserInfoKey : Any] = [:]

    internal init(data: Data) {
        self.data = SLFData(data: data, index: 0)
    }
}

extension _SLFDecoder: Decoder {

    internal func container<Key>(keyedBy type: Key.Type) -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = KeyedContainer<Key>(decoder: self, codingPath: self.codingPath, userInfo: self.userInfo)
        return KeyedDecodingContainer(container)
    }

    internal func unkeyedContainer() -> UnkeyedDecodingContainer {
        let container = UnkeyedContainer(decoder: self, codingPath: self.codingPath, userInfo: self.userInfo)
        return container
    }

    internal func singleValueContainer() -> SingleValueDecodingContainer {
        return self
    }
}

extension SLFDecoder {

    func decompress(data: Data) throws -> Data {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = [
            "gzip",
            "--decompress",
            "--verbose",
            "--stdout"
        ]

        let standardInputPipe = Pipe()
        standardInputPipe.fileHandleForWriting.writeabilityHandler = { handle in

        }
        process.standardInput = standardInputPipe

        var standardOutputData = Data()
        let standardOutputPipe = Pipe()
        standardOutputPipe.fileHandleForReading.readabilityHandler = { handle in
            standardOutputData.append(handle.readDataToEndOfFile())
        }
        process.standardOutput = standardOutputPipe

        try process.run()

        standardInputPipe.fileHandleForWriting.write(data)
        standardInputPipe.fileHandleForWriting.closeFile()

        process.waitUntilExit()
        guard process.terminationStatus == EXIT_SUCCESS else {
            fatalError("Error: \(process) \(process.terminationReason)")
        }
        return standardOutputData
    }
}
