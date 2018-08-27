//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Leonardo Brito on 23/08/2018.
//  Copyright © 2018 Leonardo Brito. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    let router = RouterSpy()
    
    func test_start_withNoQuestion_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routerQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routerQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routerQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(router.routerQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routerQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        router.answerCallBack("A1")
        router.answerCallBack("A2")

        XCTAssertEqual(router.routerQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestions_doesNotRoutesToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routerQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestion_routesToResult() {
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResult!, [:])
    }
    
    func test_start_withOneQuestion_doesNotRouteToResult() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallBack("A1")
        router.answerCallBack("A2")
        XCTAssertEqual(router.routedResult, ["Q1": "A1", "Q2": "A2"])
    }
    
    
    // MARK: Helpers
    func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }
    
    class RouterSpy: Router {
        var routerQuestions: [String] = []
        var routedResult: [String:String]? = nil
        var answerCallBack: Router.AnswerCallback = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routerQuestions.append(question)
            self.answerCallBack = answerCallback
        }
        
        func routeTo(result: [String : String]) {
            routedResult = result
        }
    }
    
}
