//
//  SliderView.swift
//  Instafilter
//
//  Created by Alex Bonder on 8/24/23.
//

import SwiftUI

struct SliderView: View {
    let label: String
    @Binding var filterAmount: Double
    let filterEnabled: Bool
    
    var body: some View {
        HStack {
            Text(label)
            Slider(value: $filterAmount)
                .disabled(!filterEnabled)
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    static func emptyFunc() {}
    static var previews: some View {
        SliderView(label: "Intensity", filterAmount: .constant(0.5), filterEnabled: true)
    }
}
