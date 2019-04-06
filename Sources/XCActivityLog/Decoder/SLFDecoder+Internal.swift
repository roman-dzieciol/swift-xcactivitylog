//
//  SLFDecoder+Internal.swift
//  XCActivityLog
//
//  Created by Roman Dzieciol on 3/27/19.
//

import Foundation
import RDGZip

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
        return try GZipArchive(from: data).decompress()
    }
}
