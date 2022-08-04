//
//  DailySurveyViewController.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 18/04/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import CareKit
import ResearchKit
import CareKitUI

class DailySurveyTask: ORKNavigableOrderedTask {
    init(showInstructions: Bool = true) {
        var steps = [ORKStep]()
        
        if showInstructions {
            // Instruction step
            let instructionStep = ORKInstructionStep(identifier: "IntroStep")
            instructionStep.title = "Daily Questionnaire"
            instructionStep.text = "Please complete this survey once daily."
            steps += [instructionStep]
        }

        // Question 1 - How would you rate your day?
        let dayRatingAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Excellent", minimumValueDescription: "Poor")
        let dayRatingQuestionStep = ORKQuestionStep(identifier: "DayRatingQuestionStep", title: "Question #1", question: "How would you rate your day?", answer: dayRatingAnswerFormat)
        steps += [dayRatingQuestionStep]

        // Question 2 - How would generally rate your enjoyment of the physical environments in which you spent time today?
        let environmentScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Excellent", minimumValueDescription: "Poor")
        let environmentScaleQuestionStep = ORKQuestionStep(identifier: "EnvironmentScaleQuestionStep", title: "Question #2", question: "How would generally rate your enjoyment of the physical environments in which you spent time today?", answer: environmentScaleAnswerFormat)
        steps += [environmentScaleQuestionStep]

        // Question 3 - Is this map of your daily activity accurate?
        let mapAccuracyBooleanAnswer = ORKBooleanAnswerFormat(yesString: "Yes", noString: "No")
        let mapAccuracyBooleanQuestionStep = MapQuestionStep(identifier: "MapAccuracyBooleanQuestionStep", title: "Question #3", question: "Is this map of your daily activity accurate? If NO, why not?", answer: mapAccuracyBooleanAnswer)
        steps += [mapAccuracyBooleanQuestionStep]

        // Question 4 - Please explain why not (please do not disclose any health information)
        let explainMapInaccuracyQuestionStep = ORKQuestionStep(identifier: "ExplainMapInaccuracyQuestionStep", title: nil, question: "Please explain why not (please do not disclose any health information).", answer: ORKTextAnswerFormat())
        explainMapInaccuracyQuestionStep.isOptional = false
        steps += [explainMapInaccuracyQuestionStep]

        // Summary step
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        steps += [summaryStep]

        super.init(identifier: "DailySurveyTask", steps: steps)

        let resultSelector = ORKResultSelector(resultIdentifier: "MapAccuracyBooleanQuestionStep")
        let booleanAnswerType = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultSelector, expectedAnswer: false)

        let predicateRule = ORKPredicateStepNavigationRule(resultPredicates: [booleanAnswerType],
                                                               destinationStepIdentifiers: ["ExplainMapInaccuracyQuestionStep"],
                                                               defaultStepIdentifier: "SummaryStep",
                                                               validateArrays: true)
        self.setNavigationRule(predicateRule, forTriggerStepIdentifier: "MapAccuracyBooleanQuestionStep")
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DailySurveyViewController: OCKInstructionsTaskViewController, ORKTaskViewControllerDelegate {

    // 2. This method is called when the use taps the button!
    override func taskView(_ taskView: UIView & OCKTaskDisplayable, didCompleteEvent isComplete: Bool, at indexPath: IndexPath, sender: Any?) {
        // 2a. If the task was marked incomplete, fall back on the super class's default behavior or deleting the outcome.
       if !isComplete {
           super.taskView(taskView, didCompleteEvent: isComplete, at: indexPath, sender: sender)
           return
       }
       
       let surveyViewController = ORKTaskViewController(task: DailySurveyTask(), taskRun: nil)
       surveyViewController.delegate = self

       // 3a. Present the survey to the user
       present(surveyViewController, animated: true, completion: nil)
   }

   // 3b. This method will be called when the user completes the survey.
   func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
       taskViewController.dismiss(animated: true, completion: nil)
       guard reason == .completed else {
           taskView.completionButton.isSelected = false
           return
       }
       controller.appendOutcomeValue(value: true, at: IndexPath(item: 0, section: 0), completion: nil)
   }

   func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
       if step.identifier == "MapAccuracyBooleanQuestionStep"{
           return MapQuestionStepViewController(step: step)
       } else {
           switch step {
           case is ORKInstructionStep:
               return ORKInstructionStepViewController(step: step)
           case is ORKCompletionStep:
               return ORKCompletionStepViewController(step: step)
           default:
               return ORKQuestionStepViewController(step: step)
           }
       }
   }
}

class DailySurveyViewSynchronizer: OCKInstructionsTaskViewSynchronizer {
    // Customize the initial state of the view
    override func makeView() -> OCKInstructionsTaskView {
        let instructionsView = super.makeView()
        instructionsView.completionButton.label.text = "Start"
        return instructionsView
    }

    override func updateView(_ view: OCKInstructionsTaskView, context: OCKSynchronizationContext<OCKTaskEvents>) {
        super.updateView(view, context: context)
        view.headerView.detailLabel.text = "Complete Every Day at 7:00 PM"
    }
}
