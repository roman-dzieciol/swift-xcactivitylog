import Foundation

extension _SLFDecoder: SingleValueDecodingContainer {
    internal func decodeNil() -> Bool {
        fatalError("Not implemented")
    }
    
    internal func decode(_ type: Bool.Type) throws -> Bool {
        fatalError("Not implemented")
    }
    
    internal func decode(_ type: String.Type) throws -> String {
        return try data.decodeString()
    }
    
    internal func decode(_ type: Double.Type) throws -> Double {
        return try data.decodeDouble()
    }
    
    internal func decode(_ type: Float.Type) throws -> Float {
        return try data.decodeFloat()
    }
    
    internal func decode(_ type: Int.Type) throws -> Int {
        return try data.decodeInteger()
    }

    internal func decode(_ type: Int8.Type) throws -> Int8 {
        return data.readBinaryNumber()
    }

    internal func decode(_ type: Int16.Type) throws -> Int16 {
        return data.readBinaryNumber()
    }

    internal func decode(_ type: Int32.Type) throws -> Int32 {
        return data.readBinaryNumber()
    }

    internal func decode(_ type: Int64.Type) throws -> Int64 {
        return data.readBinaryNumber()
    }
    
    internal func decode(_ type: UInt.Type) throws -> UInt {
        return try data.decodeUnsignedInteger()
    }
    
    internal func decode(_ type: UInt8.Type) throws -> UInt8 {
        return data.readBinaryNumber()
    }
    
    internal func decode(_ type: UInt16.Type) throws -> UInt16 {
        return data.readBinaryNumber()
    }
    
    internal func decode(_ type: UInt32.Type) throws -> UInt32 {
        return data.readBinaryNumber()
    }
    
    internal func decode(_ type: UInt64.Type) throws -> UInt64 {
        return data.readBinaryNumber()
    }
  
    internal func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        print("decode \(type) \(data.index) \(self.codingPath.map{$0.stringValue})")
        switch type {
        case is NSRange.Type:
            return try data.decodeRange() as! T
        case is SLFCodable.Type:
            if let codableType = try data.decodeObjectType() {
                let object = try codableType.init(from: self)
                return SLFCodable.object(object) as! T
            } else {
                return SLFCodable.none as! T
            }

        case is Array<SLFCodable>.Type:
            return try data.decodeObjectList(decoder: self) as! T
        default:
            return try T(from: self)
        }
    }
    
}

