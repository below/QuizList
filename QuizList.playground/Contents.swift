import Foundation

let url = URL(string: "file:///below/foo.bar")!

let name = url.deletingPathExtension().lastPathComponent
