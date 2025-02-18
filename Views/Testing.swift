//
//  Testing.swift
//  MobChat
//
//  Created by Mac on 27/01/25.
//

import SwiftUI

struct Testing: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: true, content: {
                        LazyVStack(alignment: .center, spacing: nil, pinnedViews: [], content: {
                            ForEach(1...5, id: \.self) { count in
                                ScrollView(.horizontal, showsIndicators: false, content: {
                                    LazyHStack(alignment: .center, spacing: nil, pinnedViews: [], content: {
                                        ForEach(1...10, id: \.self) { count in
                                            Text("Placeholder \(count)").rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                        }
                                    })
                                })
                            }
                        })
                    }).rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
    }
}

#Preview {
    Testing()
}
