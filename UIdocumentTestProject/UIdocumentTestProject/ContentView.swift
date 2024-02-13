//
//  ContentView.swift
//  UIdocumentTestProject
//
//  Created by Kyungsoo Lee on 2/14/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State var fileName = ""
    @State var openFile = false
    @State var saveFile = false
    
    
    var body: some View {
        VStack {
            Text(fileName)
                .fontWeight(.bold)
            
            Button {
                openFile.toggle()
            } label: {
                Text("Open")
            }
            
            Button {
                saveFile.toggle()
            } label: {
                Text("Save")
            }
        }
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf]) { (res) in
            do {
                let fileUrl = try res.get()
                
                print(fileUrl)
                
                let fileNameWithoutExtension = fileUrl.deletingPathExtension().lastPathComponent
                print("File name without extension: \(fileNameWithoutExtension)")
                let fileExtension = fileUrl.pathExtension
                print("File extension: \(fileExtension)")
                
                self.fileName = fileUrl.lastPathComponent
                
                print("File extension: \(fileName)")
                
            } catch {
                print("Error reading docs")
                print(error.localizedDescription)
            }
        }
        .fileExporter(isPresented: $saveFile, document: Doc(url: Bundle.main.path(forResource: "audio", ofType: "mp3")!), contentType: .audio) { (res) in
            
            do {
                let fileUrl = try res.get()
                print(fileUrl)
                let fileNameWithoutExtension = fileUrl.deletingPathExtension().lastPathComponent
                print("File name without extension: \(fileNameWithoutExtension)")
                let fileExtension = fileUrl.pathExtension
                print("File extension: \(fileExtension)")
            } catch {
                print("cannot save doc")
                print(error.localizedDescription)
            }
        }
    }
}

struct Doc: FileDocument {
    
    var url: String
    
    static var readableContentTypes: [UTType]{[.audio]}
    
    
    init(url: String) {
        
        self.url = url
        
    }
    
    init(configuration: ReadConfiguration) throws {
        
        url = ""
        
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        
        let file = try! FileWrapper(url: URL(fileURLWithPath: url), options: .immediate)
        
        return file
        
    }
}

#Preview {
    ContentView()
}
