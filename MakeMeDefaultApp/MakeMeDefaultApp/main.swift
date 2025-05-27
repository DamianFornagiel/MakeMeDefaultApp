//
//  main.swift
//  MakeMeDefaultApp
//
//  Created by Fornagiel, Damian on 27/05/2025.
//

import Foundation
import UniformTypeIdentifiers
import AppKit

enum DefaultAppError: Error {
    case noAppForBundleID
    case noUTIForFileExtension
    case invalidArguments
}

func printHelp() {
    print("""
    Usage:
      --fileExtension <extension>   File extension (e.g., pdf)
      --bundleID <bundle_id>        Application bundle identifier (e.g., com.adobe.Acrobat.Pro)
      --help                        Show this help message

    Example:
      /Library/Management/MakeMeDefaultApp/MakeMeDefaultApp --fileExtension pdf --bundleID com.adobe.Acrobat.Pro
          
    You must run the script as the logged-in user when executing it via MDM:   
    userName=$(stat -f "%Su" /dev/console); userID=$(id -u "$userName"); launchctl asuser "$userID" sudo -u "$userName" /Library/Management/MakeMeDefaultApp/MakeMeDefaultApp --fileExtension pdf --bundleID com.adobe.Acrobat.Pro
    
    """)
}

func setDefaultApp(for fileExtension: String, bundleIdentifier: String) async throws {
    guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else {
        throw DefaultAppError.noAppForBundleID
    }

    if let uti = UTType(filenameExtension: fileExtension, conformingTo: .data) {
        print("Setting default app for .\(fileExtension) to \(bundleIdentifier)")
        try await NSWorkspace.shared.setDefaultApplication(at: appURL, toOpen: uti)
        print("Success.")
    } else {
        throw DefaultAppError.noUTIForFileExtension
    }
}

// MARK: - Argument Parsing
let args = CommandLine.arguments
var fileExtension: String?
var bundleID: String?

if args.contains("--help") {
    printHelp()
    exit(0)
}

if let fileExtensionIndex = args.firstIndex(of: "--fileExtension"), fileExtensionIndex + 1 < args.count {
    fileExtension = args[fileExtensionIndex + 1]
}

if let bundleIDIndex = args.firstIndex(of: "--bundleID"), bundleIDIndex + 1 < args.count {
    bundleID = args[bundleIDIndex + 1]
}

guard let ext = fileExtension, let bundle = bundleID else {
    print("Error: Missing required arguments.")
    printHelp()
    exit(1)
}

// MARK: - Execution
Task {
    do {
        try await setDefaultApp(for: ext, bundleIdentifier: bundle)
    } catch {
        print("Error:", error)
        exit(1)
    }
    exit(0)
}

RunLoop.main.run()  // Keep the script running for async to complete
