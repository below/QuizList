//
//  Compression.swift
//  QuizList
//
//  Created by Alexander von Below on 23.11.22.
//  Copyright © 2022 Alexander v. Below. All rights reserved.
//

import AppleArchive
import Foundation
import System

enum CompressionError: Error {
    case writeStreamFailure
    case readStreamFailure
    case compressionStreamFailure
    case encodingStreamFailure
    case extractionError
    case keyError
    case urlError
}

func compress(url: URL) throws -> URL {
    
    let name = url.deletingPathExtension().lastPathComponent
    let archiveDestination = NSTemporaryDirectory() + name + ".aar"
    let archiveFilePath = FilePath(archiveDestination)
    
    guard let writeFileStream = ArchiveByteStream.fileStream(
        path: archiveFilePath,
        mode: .writeOnly,
        options: [ .create ],
        permissions: FilePermissions(rawValue: 0o644)) else {
        throw CompressionError.writeStreamFailure
    }
    defer {
        try? writeFileStream.close()
    }
    
    guard let compressStream = ArchiveByteStream.compressionStream(
        using: .lzfse,
        writingTo: writeFileStream) else {
        throw CompressionError.compressionStreamFailure
    }
    defer {
        try? compressStream.close()
    }
    
    guard let encodeStream = ArchiveStream.encodeStream(writingTo: compressStream) else {
        throw CompressionError.encodingStreamFailure
    }
    defer {
        try? encodeStream.close()
    }
    
    guard let keySet = ArchiveHeader.FieldKeySet("TYP,PAT,LNK,DEV,DAT,UID,GID,MOD,FLG,MTM,BTM,CTM") else {
        throw CompressionError.keyError
    }
    
    let source = FilePath(url.path)
    
    try encodeStream.writeDirectoryContents(
        archiveFrom: source,
        keySet: keySet)
    
    if #available(iOS 16.0, watchOS 9.0, *) {
        guard let result = URL(filePath: archiveFilePath) else {
            throw CompressionError.urlError
        }
        return result
    } else {
        return URL(fileURLWithPath: archiveFilePath.string)
    }
}

func decompress(url: URL, to: URL) throws {
    let path = url.path
    let archiveFilePath = FilePath(path)
    
    guard let readFileStream = ArchiveByteStream.fileStream(
        path: archiveFilePath,
        mode: .readOnly,
        options: [ ],
        permissions: FilePermissions(rawValue: 0o644)) else {
        throw CompressionError.readStreamFailure
    }
    defer {
        try? readFileStream.close()
    }
    
    guard let decompressStream = ArchiveByteStream.decompressionStream(readingFrom: readFileStream) else {
        throw CompressionError.compressionStreamFailure
    }
    defer {
        try? decompressStream.close()
    }
    
    guard let decodeStream = ArchiveStream.decodeStream(readingFrom: decompressStream) else {
        throw CompressionError.encodingStreamFailure
    }
    defer {
        try? decodeStream.close()
    }
    
    let decompressPath = to.path
    
    if !FileManager.default.fileExists(atPath: decompressPath) {
        try FileManager.default.createDirectory(atPath: decompressPath,
                                                withIntermediateDirectories: false)
    }
    
    let decompressDestination = FilePath(decompressPath)
    
    guard let extractStream = ArchiveStream.extractStream(
        extractingTo: decompressDestination,
        flags: [ .ignoreOperationNotPermitted ]) else {
        throw CompressionError.extractionError
    }
    defer {
        try? extractStream.close()
    }
    
    _ = try ArchiveStream.process(readingFrom: decodeStream,
                                      writingTo: extractStream)
}
