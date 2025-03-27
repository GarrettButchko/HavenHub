//
//  SpeechBubble.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/23/25.
//

import SwiftUI

struct SpeechBubble: Shape {
    var rectangleWidth: CGFloat // Add a dynamic width property for the rectangle
    var rectangleHeight: CGFloat // Add a dynamic width property for the rectangle
    
    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 20
        let triangleHeight: CGFloat = 10
        let triangleWidth: CGFloat = 20
        
        var path = Path()
        
        // Define the rounded rectangle with dynamic width
        let rectHeight = rect.height - triangleHeight
        let roundedRect = CGRect(x: rect.minX + ((150 - rectangleWidth) / 2), y: rect.minY, width: rectangleWidth, height: rectangleHeight)
        path.addRoundedRect(in: roundedRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        // Define the triangle
        let triangleBaseLeft = CGPoint(x: rect.midX - triangleWidth / 2, y: rectHeight) // Left base of the triangle
        let triangleBaseRight = CGPoint(x: rect.midX + triangleWidth / 2, y: rectHeight) // Right base of the triangle
        let triangleTip = CGPoint(x: rect.midX, y: rectHeight + triangleHeight) // Tip of the triangle (downward)
        
        // Add the triangle to the path
        path.move(to: triangleBaseLeft)
        path.addLine(to: triangleTip)
        path.addLine(to: triangleBaseRight)
        path.closeSubpath()
        
        return path
    }
}
