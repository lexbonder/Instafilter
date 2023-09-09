//
//  ContentView.swift
//  Instafilter
//
//  Created by Alex Bonder on 8/19/23.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        // Load Picture as UIImage
        guard let inputImage = UIImage(named: "Example") else { return }
        // Convert UIImage to CIImage
        let beginImage = CIImage(image: inputImage)
        
        // CIContext converts CIImage data to CGImage
        let context = CIContext()
        // CIFilter manipulates the CIImage data.
        let currentFilter = CIFilter.crystallize() // Has 2 properties, input image, and intensity - set both.
        
        // Current filter is a recipe. Give it the properties it needs to create the image wanted.
        currentFilter.inputImage = beginImage // set the image for the filter to operate on.
        
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }
        
        // This property is the filter's processed image
        guard let outputImage = currentFilter.outputImage else { return }
        
        // A method from context that spits out a CGImage based on the result of the filter
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            // Convert to UIImage
            let uiImage = UIImage(cgImage: cgimg)
            // Convert to SwiftUI Image and save to variable
            image = Image(uiImage: uiImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// CoreImage Filter List: https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
