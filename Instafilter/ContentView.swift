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
    
    @State private var filterIntensity = 0.5
    @State private var intensityEnabled = false

    @State private var filterRadius = 0.5
    @State private var radiusEnabled = false

    @State private var filterScale = 0.5
    @State private var scaleEnabled = false
    
    @State private var filterAngle = 0.5
    @State private var angleEnabled = false
    
    @State private var filterWidth = 0.5
    @State private var widthEnabled = false
    
    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()

    let context = CIContext()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                SliderView(
                    label: "Intensity",
                    filterAmount: $filterIntensity,
                    filterEnabled: intensityEnabled
                )
                    .onChange(of: filterIntensity) { _ in applyProcessing() }
                
                SliderView(
                    label: "Radius",
                    filterAmount: $filterRadius,
                    filterEnabled: radiusEnabled
                )
                    .onChange(of: filterRadius) { _ in applyProcessing() }
                
                SliderView(
                    label: "Scale",
                    filterAmount: $filterScale,
                    filterEnabled: scaleEnabled
                )
                    .onChange(of: filterScale) { _ in applyProcessing() }
                
                SliderView(
                    label: "Angle",
                    filterAmount: $filterAngle,
                    filterEnabled: angleEnabled
                )
                    .onChange(of: filterAngle) { _ in applyProcessing() }
                
                SliderView(
                    label: "Width",
                    filterAmount: $filterWidth,
                    filterEnabled: widthEnabled
                )
                    .onChange(of: filterWidth) { _ in applyProcessing() }
                
                HStack {
                    Button("Change Filter") { showingFilterSheet = true }
                    Spacer()
                    Button("Save", action: save)
                        .disabled(image == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Dot Screen") { setFilter(CIFilter.dotScreen()) }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            intensityEnabled = true
        } else {
            intensityEnabled = false
            filterIntensity = 0.5
        }

        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
            radiusEnabled = true
        } else {
            radiusEnabled = false
            filterRadius = 0.5
        }

        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)
            scaleEnabled = true
        } else {
            scaleEnabled = false
            filterScale = 0.5
        }
        
        if inputKeys.contains(kCIInputAngleKey) {
            currentFilter.setValue(filterAngle * 360, forKey: kCIInputAngleKey)
            angleEnabled = true
        } else {
            angleEnabled = false
            filterAngle = 0.5
        }
        
        if inputKeys.contains(kCIInputWidthKey) {
            currentFilter.setValue(filterWidth * 10, forKey: kCIInputWidthKey)
            widthEnabled = true
        } else {
            widthEnabled = false
            filterWidth = 0.5
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage (cgImage: cgimg)
            processedImage = uiImage
            image = Image(uiImage: uiImage)
        }
    }
    
    func save() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        imageSaver.successHandler = { print("Success!") }
        imageSaver.errorHandler = { error in print("Oops! \(error.localizedDescription)") }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
