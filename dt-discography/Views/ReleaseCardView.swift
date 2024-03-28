//
//  ReleaseCardView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import SwiftUI

struct ReleaseCardView: View {
    
    let release: Release
    
    var body: some View {
        VStack(alignment: .center) {
            thumbnail
            Text(release.title)
            Text("Label: \(release.label ?? "N/A")")
            if let year = release.year {
                Text(verbatim: "Released: \(year)")
            }
            Text("Format: \(release.format ?? "N/A")")
        }
    }
    
    private var thumbnail: some View {
//        GeometryReader { reader in
            AsyncImage(
                url: URL(string: release.thumb),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
//                        .frame(width: reader.size.width)
                },
                placeholder: {}
            )
//        }
    }
}

#Preview {
    ReleaseCardView(
        release: Release(
            id: 0,
            format: "12\", Maxi",
            title: "mock",
            label: "Capitol",
            resourceUrl: "https://mock.com",
            year: 1500,
            thumb: "https://i.discogs.com/otrB6zRwRDNhznIkjQ5_DwLO3dNjNvWxdbYV4g6tXTs/rs:fit/g:sm/q:40/h:150/w:150/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTkwNDc1/NjEtMTQ3Mzg1NzUz/NS01Mzc0LmpwZWc.jpeg"
        )
    )
}
