import Foundation

extension _SLFDecoder {

    /// The SWXCActivityLog archive is not keyed
    ///
    /// The automatically synthesized Codable conformance uses keyed containers
    /// Decodes properties in provided order, ignores keys
    final internal class KeyedContainer<Key> where Key: CodingKey {
        internal var decoder: _SLFDecoder
        internal var codingPath: [CodingKey]
        internal var userInfo: [CodingUserInfoKey: Any]

        internal init(decoder: _SLFDecoder, codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.decoder = decoder
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

extension _SLFDecoder.KeyedContainer: KeyedDecodingContainerProtocol {
    internal var allKeys: [Key] {
        fatalError("Not implemented")
    }
    
    internal func contains(_ key: Key) -> Bool {
        fatalError("Not implemented")
    }
    
    internal func decodeNil(forKey key: Key) throws -> Bool {
        fatalError("Not implemented")
    }
    
    internal func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        decoder.codingPath.append(key)
        //print("decode: \(decoder.codingPath.map {$0.stringValue}.joined(separator: ".")) \(type)")
        defer {
            let _ = decoder.codingPath.popLast()
        }
        return try decoder.decode(type)
    }
 
    internal func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError("Not implemented")
    }
    
    internal func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("Not implemented")
    }
    
    internal func superDecoder() throws -> Decoder {
        fatalError("Not implemented")
    }
    
    internal func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError("Not implemented")
    }
}

