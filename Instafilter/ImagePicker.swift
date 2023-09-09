//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Alex Bonder on 8/20/23.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PHPickerViewController {
        // we can make our own adjustments to the picker
        var config = PHPickerConfiguration()
        // we want to pick only images, ignore videos
        config.filter = .images
        
        return PHPickerViewController(configuration: config)
    }
    
    // don't need to use this for this project
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    // used to generate correct protocol stubs
//    typealias UIViewControllerType = PHPickerViewController
}
