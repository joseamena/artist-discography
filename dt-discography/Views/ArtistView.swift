//
//  ArtistView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Kingfisher
import SwiftUI

struct ArtistView: View {
    
    @StateObject var viewModel = ArtistViewModel(client: DTDiscographyClient())
    
    var body: some View {
        VStack {
            artistImage
            summary
        }
    }
    
    private var summary: some View {
        VStack {
            Text(viewModel.artistName)
            Text(viewModel.currentMembers)
            Button(action: {}) {
                Text("Discography")
            }
        }
    }
    
    private var artistImage: some View {
        KFImage(viewModel.primaryImageUrl)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    ArtistView()
}
