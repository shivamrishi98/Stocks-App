//
//  Extensions.swift
//  Stocks
//
//  Created by Shivam Rishi on 08/03/22.
//

import UIKit

// MARK: - NUMBERFORMATTER

extension NumberFormatter {
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}


// MARK: - UIIMAGEVIEW

extension UIImageView {
    func setImage(with url: URL?) {
        guard let url = url else {
            return
        }
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let task = URLSession.shared.dataTask(with: url) { data, _ , error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}


 // MARK: - STRING

extension String {
    static func string(from timeInterval:TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
    static func percentage(from double: Double) -> String {
        let formatter = NumberFormatter.percentFormatter
        return formatter.string(from: NSNumber(value: double)) ?? "\(double)"
    }
    static func formatted(number: Double) -> String {
        let formatter = NumberFormatter.numberFormatter
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}


// MARK: - DATEFORMATTER

extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let prettyDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}


// MARK: - ADD SUBVIEW

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

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
