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
        var config = PHPickerConfiguration()
        config.filter = .images
        
        return PHPickerViewController(configuration: config)
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
}
