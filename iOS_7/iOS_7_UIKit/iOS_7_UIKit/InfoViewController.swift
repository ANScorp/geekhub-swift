//
//  InfoViewController.swift
//  iOS_7_UIKit
//
//  Created by Alex on 12/15/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit
import MapKit

class InfoViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var mapView: MKMapView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        let annotation = MKPointAnnotation()

        super.viewDidLoad()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 49.426_101, longitude: 32.094_683)
        annotation.title = "GeekHub"
        annotation.subtitle = "Ukraine Cherkasy Gorkogo 60"
        centerMapOnLocation(location: annotation.coordinate, radius: 6_000)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }

    // MARK: - Methods
    func centerMapOnLocation(location: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: radius,
                                                  longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

@IBDesignable class UITextViewTrimmed: UITextView {
    override var intrinsicContentSize: CGSize {
        var textView = super.intrinsicContentSize
        if text.isEmpty {
            textView.height = 1.0
        }
        return textView
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        removePadding()
    }
    func removePadding() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
