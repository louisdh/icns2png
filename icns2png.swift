import Foundation

@discardableResult
func shell(_ args: String...) -> Int32 {
	let task = Process()
	task.launchPath = "/usr/bin/env"
	task.arguments = args
	task.launch()
	task.waitUntilExit()
	return task.terminationStatus
}

let fileManager = FileManager.default

let inputPath = fileManager.currentDirectoryPath + "/icns/"
let outputPath = fileManager.currentDirectoryPath + "/png/"

let inputURL = URL(fileURLWithPath: inputPath)

guard fileManager.fileExists(atPath: inputURL.path) else {
	print("Create an input directory called \"icns\"")
	exit(1)
}

let outputURL = URL(fileURLWithPath: outputPath)

guard fileManager.fileExists(atPath: outputURL.path) else {
	print("Create an output directory called \"png\"")
	exit(1)
}

// sizes in pt.
let outputSizes = [32, 64, 128]
let outputScales = [1, 2, 3]

for content in try fileManager.contentsOfDirectory(at: inputURL, includingPropertiesForKeys: nil) {
	
	let fileName = content.deletingPathExtension().lastPathComponent
	print(fileName)
	
	for size in outputSizes {
		
		for scale in outputScales {
			
			let width = size * scale
			
			var outputFilename = fileName + "-\(size)"
			
			if scale > 1 {
				outputFilename += "@\(scale)x"
			}
			
			shell("sips", "-Z", "\(width)", "-s", "format", "png", "\(inputPath)\(fileName).icns", "--out", "\(outputPath)\(outputFilename).png")
			
		}
		
	}
	
}
