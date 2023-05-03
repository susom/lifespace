//
//  JHMapQuestionStep.swift
//  LifeSpace
//
//  Created by Esteban Ramos on 18/04/22.
//  Copyright © 2022 LifeSpace. All rights reserved.
//

import Foundation
import ResearchKit
import UIKit
import SwiftUI
import MapboxMaps

public class MapQuestionStep: ORKQuestionStep{
    public override init(identifier: String) {
        super.init(identifier: identifier)
        self.answerFormat = ORKAnswerFormat.booleanAnswerFormat()
    }

    @available(*, unavailable)
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class MapQuestionStepViewController: ORKQuestionStepViewController {
    internal var mapView: MapView!

    public override func viewDidLoad() {
        let QuestionLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 450, height: 50 ))
        QuestionLabel.center.x = view.center.x
        QuestionLabel.text = "Is this map of your daily activity accurate?"
        QuestionLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(QuestionLabel)

        // Map of today's points
        mapView = MapView(frame: CGRect(x: 0, y: 120, width: 400, height: 400))
        mapView.center.x = view.center.x
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)

        // "Yes" button
        let yesButton = UIButton(frame: CGRect(x: 0, y: 450, width: 350, height: 50))
        yesButton.center.x = view.center.x
        yesButton.setTitle("Yes", for: .normal)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.layer.cornerRadius = 10
        yesButton.backgroundColor = .systemBlue
        yesButton.addTarget(self, action: #selector(OnClickYesButton), for: .touchUpInside)
        self.view.addSubview(yesButton)

        // "No" button
        let noButton = UIButton(frame: CGRect(x: 0, y: 505, width: 350, height: 50))
        noButton.center.x = view.center.x
        noButton.setTitle("No", for: .normal)
        noButton.setTitleColor(.white, for: .normal)
        noButton.layer.cornerRadius = 10
        noButton.backgroundColor = .systemBlue
        noButton.addTarget(self, action: #selector(OnClickNoButton), for: .touchUpInside)
        self.view.addSubview(noButton)

        // "Skip" button
        let skipButton = UIButton(frame: CGRect(x: 0, y: 555, width: 350, height: 50))
        skipButton.center.x = view.center.x
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.systemBlue, for: .normal)
        skipButton.layer.cornerRadius = 10
        skipButton.backgroundColor = .white
        skipButton.addTarget(self, action: #selector(OnClickSkipButton), for: .touchUpInside)
        self.view.addSubview(skipButton)

        self.view.backgroundColor = .white
        MapboxMap.initializeMap(mapView: mapView, reload: false)
    }

    @objc func OnClickYesButton() {
      self.setAnswer(true)
      super.goForward()
    }

    @objc func OnClickNoButton() {
        self.setAnswer(false)
        super.goForward()
    }

    @objc func OnClickSkipButton() {
        super.skipForward()
    }
}
