//
//  Extensions.swift
//  Stocks
//
//  Created by Shivam Rishi on 08/03/22.
//

import UIKit

// MARK: - FRAMING

extension UIView {
    var width:CGFloat {
        frame.size.width
    }
    var height:CGFloat {
        frame.size.height
    }
    var left:CGFloat {
        frame.origin.x
    }
    var right:CGFloat {
        left + width
    }
    var top:CGFloat {
        frame.origin.y
    }
    var bottom:CGFloat {
        top + height
    }
}
