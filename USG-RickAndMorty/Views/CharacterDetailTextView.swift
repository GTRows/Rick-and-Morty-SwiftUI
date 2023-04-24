//
//  CharacterDetailTextView.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 22.04.2023.
//

import SwiftUI

struct CharacterDetailTextView: View {
    let title: String
    let data: String
    let verticalPadding: CGFloat

    init(title: String, data: String, verticalPadding: CGFloat = 5) {
        self.title = title
        self.verticalPadding = verticalPadding

        if title == "Episodes: " {
            self.data = data.replacingOccurrences(of: "https://rickandmortyapi.com/api/episode/", with: "")
        } else if title == "Created at (in API): " {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: data) {
                dateFormatter.dateFormat = "dd MMM yyyy, HH:mm:ss"
                self.data = dateFormatter.string(from: date)
            } else {
                self.data = data
            }
        } else {
            self.data = data
        }
    }

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.custom("Avenir", size: 22))
                .fontWeight(.bold)
                .frame(width: 125, alignment: .leading)
            if data.widthOfString(usingFont: UIFont.systemFont(ofSize: 22)) > UIScreen.main.bounds.width - 200 {
                ScrollView(.horizontal) {
                    Text(data)
                        .font(.custom("Avenir", size: 22))
                        .fontWeight(.regular)
                }
            } else {
                Text(data)
                    .font(.system(size: 22))
                    .fontWeight(.regular)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, verticalPadding)
    }
}


struct DetailTextView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailTextView(title: "String", data: "String")
    }
}
