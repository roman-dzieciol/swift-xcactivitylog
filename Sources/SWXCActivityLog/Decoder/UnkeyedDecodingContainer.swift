import Foundation

extension _SLFDecoder {
    final internal class UnkeyedContainer {
        internal var decoder: Decoder
        internal var codingPath: [CodingKey]
        internal var userInfo: [CodingUserInfoKey: Any]
       
        internal init(decoder: Decoder, codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.decoder = decoder
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

extension _SLFDecoder.UnkeyedContainer: UnkeyedDecodingContainer {
    internal var count: Int? {
        fatalError("Not implemented")
    }
    
    internal var isAtEnd: Bool {
        fatalError("Not implemented")
    }
    
    internal var currentIndex: Int {
        fatalError("Not implemented")
    }
    
    internal func decodeNil() throws -> Bool {
        fatalError("Not implemented")
    }
    
    internal func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        fatalError("Not implemented")
    }
    
    internal func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("Not implemented")
    }
    
    internal func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("Not implemented")
    }

    internal func superDecoder() throws -> Decoder {
        fatalError("Not implemented")
    }
}

