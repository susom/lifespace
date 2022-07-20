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
            instructionStep.text = "Please complete this survey daily to assess your own health."
            steps += [instructionStep]
        }

        // How would you rate your health today?
        let healthScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Excellent", minimumValueDescription: "Poor")
        let healthScaleQuestionStep = ORKQuestionStep(identifier: "HealthScaleQuestionStep", title: "Question #1", question: "How would you rate your overall health today:", answer: healthScaleAnswerFormat)
        steps += [healthScaleQuestionStep]

        // How would you rate your mental health today?
        let mentalhealthScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Excellent", minimumValueDescription: "Poor")
        let mentalhealthScaleQuestionStep = ORKQuestionStep(identifier: "mentalHealthScaleQuestionStep", title: "Question #2", question: "How would you rate your mental health today:", answer: mentalhealthScaleAnswerFormat)
        steps += [mentalhealthScaleQuestionStep]

        // Is this map of your daily activity accurate?
        let booleanAnswer = ORKBooleanAnswerFormat(yesString: "Yes", noString: "No")
        let booleanQuestionStep = JHMapQuestionStep(identifier: "mapstep", title: "Question #3", question: "Is this map of your daily activity accurate? If NO, why not?", answer: booleanAnswer)
        steps += [booleanQuestionStep]

        // Please explain why not
        let textQuestionStep = ORKQuestionStep(identifier: "whyNot", title: "Please explain why not", question: nil, answer: ORKTextAnswerFormat())
        textQuestionStep.isOptional = false
        steps += [textQuestionStep]

        // Summary step
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."

        steps += [summaryStep]
        super.init(identifier: "DailySurveyTask", steps: steps)

        let resultSelector = ORKResultSelector(resultIdentifier: "mapstep")
        let booleanAnswerType = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultSelector, expectedAnswer: false)

        let predicateRule = ORKPredicateStepNavigationRule(resultPredicates: [booleanAnswerType],
                                                               destinationStepIdentifiers: ["whyNot"],
                                                               defaultStepIdentifier: "SummaryStep",
                                                               validateArrays: true)
        self.setNavigationRule(predicateRule, forTriggerStepIdentifier: "mapstep")
        
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
       if step.identifier == "mapstep"{
           return JHMapQuestionStepViewController(step: step)
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
