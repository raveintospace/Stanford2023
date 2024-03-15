//
//  PieShape.swift
//  Memorize
//
//  Created by Uri on 15/3/24.
//

import SwiftUI
import CoreGraphics

struct PieShape: Shape {
    
    var startAngle: Angle = .zero
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        var p = Path()
        p.move(to: center)
        
        
        return p
    }
}
