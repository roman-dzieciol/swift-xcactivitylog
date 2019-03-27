import Foundation

/// Decoder for XCActivityLog archives
@available(OSX 10.13, *)
final public class SLFDecoder {

    public init() {
    }

    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let data = try decompress(data: data)
        let decoder = _SLFDecoder(data: data)
        return try decoder.decode(type)
    }
}
