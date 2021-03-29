//
//  CircularLoadingView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/24.
//

import SwiftUI

struct CircularLoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    }
}

struct CircularLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CircularLoadingView()
    }
}
