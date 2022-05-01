//
//  ActivityCell.swift
//  Gitlab
//
//  Created by a-pavlov on 23.04.22.
//

import SwiftUI

struct ActivityCell: View {
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 15) {
                Circle().frame(width: 30, height: 30, alignment: .bottom)
                VStack(alignment: .leading, spacing: 2) {
                    HStack{
                        Text("Алексей").font(.subheadline).fontWeight(.medium)
                        Text("@pavlof01").font(.caption).foregroundColor(.gray)
                    }
                    HStack {
                        Image(systemName: "circle.circle").foregroundColor(.green).font(.footnote)
                        Text("Opened merge request").font(.subheadline).foregroundColor(.gray)
                        Text("!12").font(.subheadline).foregroundColor(.accentColor)
                    }
                    Text("[Snyk] Security upgrade react-native from 0.64.2 to 0.65.0").font(.subheadline).foregroundColor(.gray).lineLimit(2)
                }
                
            }.padding(.horizontal, 10)
            Divider()
        }
    }
}

struct ActivityCell_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCell()
    }
}
