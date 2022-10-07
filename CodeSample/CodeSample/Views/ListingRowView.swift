//
//  ListingRowView.swift
//  CodeSample
//
//  Created by Ryan Lons on 9/30/22.
//  Copyright © 2022 Ryan Lons. All rights reserved.
//

import Foundation
import SwiftUI

struct ListRow: View {
    
    var listingViewModel: ListingViewModel
    @State var image: UIImage = UIImage(named: "NoImagePlaceholder")!
    @State var favoriteButtonImage: UIImage = UIImage(named: "favoriteStar")!
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geo in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .task {
                        image = await listingViewModel.loadImage()
                    }
            }
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    Text(listingViewModel.propertyTypeString ?? "")
                        .font(Font.custom("CompassSans-Bold", size: 12))
                        .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
                        .foregroundColor(Color.white)
                        .background(Color.black)
                    
                    if (listingViewModel.subtitleString?.isEmpty == false) {
                        Text(listingViewModel.subtitleString!)
                            .font(Font.custom("CompassSans-Bold", size: 12))
                            .padding(EdgeInsets(top: 1, leading: 3, bottom: 1, trailing: 3))
                            .foregroundColor(Color.white)
                            .background(Color.black)
                    }
                    Spacer()
                    Button {
                        Task {
                            await listingViewModel.toogleFavoriteStatus()
                        }
                    } label: {
                        Image(uiImage: favoriteButtonImage)
                        
                            .onReceive(listingViewModel.$favoriteButtonImage) { image in
                                favoriteButtonImage = image
                            }
                    }
                }
                Spacer()
                HStack(alignment: .bottom) {
                    VStack (alignment: .leading){
                        Text(listingViewModel.priceString ?? "")
                            .fontWeight(.medium)
                            .font(Font.custom("CompassSans-Medium", size: 28))
                        Text(listingViewModel.addressLine1String ?? "")
                            .font(Font.custom("CompassSans-Regular", size: 15))
                        Text(listingViewModel.addressLine2String ?? "")
                            .font(Font.custom("CompassSans-Regular", size: 15))
                    }
                    Spacer()
                    VStack(alignment:.trailing) {
                        Spacer()
                        HStack(alignment: .bottom) {
                            VStack {
                                Text(listingViewModel.bedsString ?? "")
                                    .font(Font.custom("CompassSans-Regular", size: 23))
                                Text("Beds")
                                    .font(Font.custom("CompassSans-Regular", size: 16))
                            }
                            Divider()
                                .overlay(.white)
                                .frame(height: 40)
                                .padding(.bottom, 5)
                            VStack {
                                Text(listingViewModel.bathsString ?? "")
                                    .font(Font.custom("CompassSans-Regular", size: 23))
                                Text("Baths")
                                    .font(Font.custom("CompassSans-Regular", size: 16))
                            }
                            Divider()
                                .overlay(.white)
                                .frame(height: 40)
                                .padding(.bottom, 5)
                            VStack {
                                Text(listingViewModel.sqFtString ?? "")
                                    .font(Font.custom("CompassSans-Regular", size: 23))
                                Text("Sq. Ft.")
                                    .font(Font.custom("CompassSans-Regular", size: 16))
                            }
                        }
                    }
                }
            }
            .padding(15)
            .foregroundColor(Color.white)
            .background(
                LinearGradient(gradient: Gradient(colors: [.clear, Color(hue: 0,
                                                                         saturation: 0,
                                                                         brightness: 0.0,
                                                                         opacity: 0.7)]),
                               startPoint: UnitPoint(x: 0, y: 0.4),
                               endPoint: UnitPoint(x: 0, y: 1))
            )//ends vstack
        }//ends zstack
        .frame(height: 220)
        .padding(0)
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        let listing = Listing(id: "listingId", thumbUrl: "https://picsum.photos/id/865/600/220.jpg", address: "642 Waterloo Ln", addressLine2: "Apt #1337", subTitle: "Newly Listed", price: 1656000, squareFootage: 3272, beds: 4, baths: 3, halfBaths: 1, isFavorited: false, propertyType: .condo)
        let listingViewModel = ListingViewModel(listing: listing,
                                                listingsService: ApplicationConfiguration.shared.listingsService)
        ListRow(listingViewModel: listingViewModel)
    }
}
