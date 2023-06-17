////
////  MarqueeText.swift
////  HB Private Browser
////
////  Created by Benjamin Prentiss on 6/16/23.
////
//
//import SwiftUI
//
//struct MarqueeText: View {
//    @State var isAnimating = false
//
//    var body: some View {
//        GeometryReader { geometry in
//            let textWidth = "HyperBold Private Browser".size(withAttributes: [.font: UIFont.systemFont(ofSize: 36, weight: .bold)]).width
//            let initialOffsetX = geometry.size.width + textWidth
//
//            Text("HyperBold Private Browser")
//                .font(.system(size: 60))
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//                .lineLimit(1)
//                .fixedSize(horizontal: true, vertical: false)
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .offset(x: isAnimating ? -initialOffsetX : initialOffsetX, y: geometry.size.height * 0.3)
//                .animation(Animation.linear(duration: 8).repeatForever(autoreverses: false), value: isAnimating)
//                .onAppear {
//                    isAnimating = true
//                }
//        }
//    }
//}
//
