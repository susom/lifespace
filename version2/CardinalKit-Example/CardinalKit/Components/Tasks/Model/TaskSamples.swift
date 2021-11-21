//
//  StudyTasks.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//
// EDIT TASKSAMPLES

import ResearchKit

/**
 This file contains some sample `ResearchKit` tasks
 that you can modify and use throughout your project!
*/
struct TaskSamples {
    
    /**
     Active tasks created with short-hand constructors from `ORKOrderedTask`
    */
    static let sampleTappingTask: ORKOrderedTask = {
        let intendedUseDescription = "Finger tapping is a universal way to communicate."
        
        return ORKOrderedTask.twoFingerTappingIntervalTask(withIdentifier: "TappingTask", intendedUseDescription: intendedUseDescription, duration: 10, handOptions: .both, options: ORKPredefinedTaskOption())
    }()
    
    static let sampleWalkingTask: ORKOrderedTask = {
        let intendedUseDescription = "Tests ability to walk"
        
        return ORKOrderedTask.shortWalk(withIdentifier: "ShortWalkTask", intendedUseDescription: intendedUseDescription, numberOfStepsPerLeg: 20, restDuration: 30, options: ORKPredefinedTaskOption())
    }()
    
    /**
        Coffee Task Example for 9/2 Workshop
     */
    static let sampleCoffeeTask: ORKOrderedTask = {
        var steps = [ORKStep]()
        
        // Coffee Step
        let healthScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 0, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "A Lot 😬", minimumValueDescription: "None 😴")
        let healthScaleQuestionStep = ORKQuestionStep(identifier: "CoffeeScaleQuestionStep", title: "Coffee Intake", question: "How many cups of coffee do you drink per day?", answer: healthScaleAnswerFormat)
        
        steps += [healthScaleQuestionStep]
        
        //SUMMARY
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you for tracking your coffee."
        summaryStep.text = "We appreciate your caffeinated energy! check out the results chart."
        
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: "SurveyTask-Coffee", steps: steps)
        
    }()
    
    /**
     Sample task created step-by-step!
    */
    static let sampleSurveyTask: ORKOrderedTask = {
        var steps = [ORKStep]()
        
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "Daily Questionnaire"
        instructionStep.text = "Please complete this survey daily to assess your own health."
        
        steps += [instructionStep]
        
        //How would you rate your health today?
        let healthScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Excellent", minimumValueDescription: "Poor")
        let healthScaleQuestionStep = ORKQuestionStep(identifier: "HealthScaleQuestionStep", title: "Question #1", question: "How would you rate your overall health today:", answer: healthScaleAnswerFormat)
        
        steps += [healthScaleQuestionStep]
        
        //How would you rate your mental health today?
        let mentalhealthScaleAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false, maximumValueDescription: "Excellent", minimumValueDescription: "Poor")
        let mentalhealthScaleQuestionStep = ORKQuestionStep(identifier: "mentalHealthScaleQuestionStep", title: "Question #2", question: "How would you rate your mental health today:", answer: mentalhealthScaleAnswerFormat)
        
        steps += [mentalhealthScaleQuestionStep]

        
        let booleanAnswer = ORKBooleanAnswerFormat(yesString: "Yes", noString: "No")
        let booleanQuestionStep = ORKQuestionStep(identifier: "QuestionStep", title: "Question #3", question: "Is this map of your daily activity accurate? If NO, why not?", answer: booleanAnswer)
        
        steps += [booleanQuestionStep]
        
        //SUMMARY
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: "SurveyTask-Assessment", steps: steps)
    }()
}
