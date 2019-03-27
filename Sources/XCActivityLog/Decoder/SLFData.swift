//
//  SLFData.swift
//  XCActivityLog
//
//  Created by Roman Dzieciol on 3/19/19.
//

import Foundation

internal struct ByteMarker {
    internal static let string: UInt8 = 0x22
    internal static let integer: UInt8 = 0x23
    internal static let float: UInt8 = 0x24
    internal static let className: UInt8 = 0x25
    internal static let array: UInt8 = 0x28
    internal static let noValue: UInt8 = 0x2d
    internal static let classIndex: UInt8 = 0x40
    internal static let double: UInt8 = 0x5e
}

internal class SLFData {

    var data: Data
    var index: Data.Index
    var classNames: [UInt: AnyClass] = [:]

    internal init(data: Data, index: Data.Index) {
        self.data = data
        self.index = index
    }

    internal func seek(offset: Int) {
        index += offset
        guard data.indices.contains(index) else {
            fatalError()
        }
    }
}

extension SLFData {

    internal func readUnsignedAsciiInteger() -> UInt {
        guard data.indices.contains(index) else {
            fatalError()
        }

        var value: UInt = 0
        repeat {
            let byte = data[index]
            if byte < 0x30 || byte > 0x39 {
                break
            }
            value = value * 10 + UInt(byte - 0x30)
            index = index + 1
        } while index < data.count
        return value
    }

    internal func readString(length: UInt) -> String {
        let bytes = data[index..<index+Int(length)]
        let string = String(bytes: bytes, encoding: .utf8)!
        seek(offset: Int(length))
        return string
    }

    internal func readBinaryNumber<T>() -> T {
        let size = MemoryLayout<T>.size
        guard index + size <= data.count else {
            fatalError()
        }

        let value: T = data[index..<index+size].withUnsafeBytes { $0.pointee }
        index += size
        return value
    }
}

extension SLFData {

    internal func decodeObjectType() throws -> Codable.Type? {
        let value = readUnsignedAsciiInteger()
        let byteMarker: UInt8 = readBinaryNumber()

        switch byteMarker {
        case ByteMarker.className:
            guard value > 0 else {
                fatalError()
            }

            var className = readString(length: value)
            let classIndex = readUnsignedAsciiInteger()
            let byteMarker: UInt8 = readBinaryNumber()
            if byteMarker != ByteMarker.classIndex {
                fatalError()
            }

            if className.hasPrefix("IDE") {
                className = String(className.dropFirst("IDE".count))
            }
            else if className.hasPrefix("DVT") {
                className = String(className.dropFirst("DVT".count))
            }

            guard let type = NSClassFromString("XCActivityLog." + className) else {
                fatalError()
            }

            guard let codableType = type as? Codable.Type else {
                fatalError()
            }

            classNames[classIndex] = type
            return codableType

        case ByteMarker.noValue:
            return nil

        case ByteMarker.classIndex:
            let type: AnyClass = classNames[value]!
            guard let codableType = type as? Codable.Type else {
                fatalError()
            }
            return codableType

        default:
            fatalError()
        }
    }

    internal func decodeObjectList(decoder: Decoder) throws -> [SLFCodable] {
        let objectCount = readUnsignedAsciiInteger()
        let byteMarker: UInt8 = readBinaryNumber()

        switch byteMarker {
        case ByteMarker.noValue:
            return []

        case ByteMarker.array:
            var objects: [SLFCodable] = []
            for _ in 0..<objectCount {
                if let codableType = try decodeObjectType() {
                    let object = try codableType.init(from: decoder)
                    objects.append(SLFCodable.object(object))
                }
            }
            return objects

        default:
            fatalError()
        }
    }

    internal func decodeInteger() throws -> Int {
        let value = readUnsignedAsciiInteger()
        let byteMarker: UInt8 = readBinaryNumber()
        if (byteMarker != ByteMarker.integer) {
            fatalError()
        }
        return Int(bitPattern: value)
    }

    internal func decodeUnsignedInteger() throws -> UInt {
        let value = readUnsignedAsciiInteger()
        let byteMarker: UInt8 = readBinaryNumber()
        if (byteMarker != ByteMarker.integer) {
            fatalError()
        }
        return value
    }

    internal func decodeFloat() throws -> Float {
        let data = try decodeHexBytes(length: 4, magic: ByteMarker.float)
        return data.withUnsafeBytes { $0.pointee }
    }

    internal func decodeDouble() throws -> Double {
        let data = try decodeHexBytes(length: 8, magic: ByteMarker.double)
        return data.withUnsafeBytes { $0.pointee }
    }

    internal func decodeString() throws -> String {
        let stringLength = readUnsignedAsciiInteger()
        let byteMarker: UInt8 = readBinaryNumber()

        switch byteMarker {
        case ByteMarker.noValue:
            return ""

        case ByteMarker.string:
            return readString(length: stringLength)

        default:
            fatalError()
        }
    }

    private func byteValue(asciiByte: UInt8) -> UInt8 {
        switch asciiByte {
        case 0x30...0x39:
            return UInt8(asciiByte - 0x30)
        case 0x41...0x46:
            return UInt8(asciiByte - 0x41 + 10)
        case 0x61...0x66:
            return UInt8(asciiByte - 0x61 + 10)
        default:
            fatalError()
        }
    }

    internal func decodeHexBytes(length: Int, magic: UInt8) throws -> Data {
        var result = Data()

        for i in stride(from: index, to: index+length*2, by: 2) {
            let lc: UInt8 = data[i]
            let rc = data[i+1]

            let value = byteValue(asciiByte: lc) << 0x4 + byteValue(asciiByte: rc)
            result.append(value)
        }
        index += length * 2
        let byteMarker: UInt8 = readBinaryNumber()
        guard byteMarker == magic else {
            fatalError()
        }
        return result
    }

    internal func decodeRange() throws -> NSRange {
        let location = try decodeInteger()
        let length = try decodeInteger()

        return NSRange(location: location == UInt.max ? -1 : Int(location),
                       length: Int(length)
        )
    }
}
