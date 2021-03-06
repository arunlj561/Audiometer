//
//  TestsRouter.swift
//  Audiometer
//
//  Created by Alex Bibikov on 5/10/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import UIKit
import AgoraRtmKit

struct TestsRouter {
    static func showPreviousTests(type: Tests, patient: PatientInfo, from: UIViewController, report: Report) {
        if type == .tone {
            let viewModel = PreviousACBCTestsViewModel(testType: type, patientInfo: patient, report: report)
            let vc = PreviousTestsViewController.viewController
            vc.viewModel = viewModel
            from.navigationController?.pushViewController(vc, animated: true)
        }
        else if type == .speech {
            let viewModel = PreviousSRTSDSINTestsViewModel(testType: type, patientInfo: patient, report: report)
            let vc = PreviousTestsViewController.viewController
            vc.viewModel = viewModel
            from.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

   
    static func showHistoryTest(info: TestInfoProtocol, from: UIViewController, report: Report) {
        let storyboard = UIStoryboard.testsStoryboard
        let router = Router(storyboard: storyboard)
        if let testResult = info as? TestResult {
            let testResultPage = TestResultPage(app: App(), testResult: testResult, report: report)
            testResultPage.canEdit = false
            let vc = router.createController(page: testResultPage) as TestResultViewController
            from.navigationController?.pushViewController(vc, animated: true)
        }
        else if let testResult = info as? WordTestResult {
            let testResultPage = TestResultPage(app: App(), testResult: testResult, report: report)
            testResultPage.canEdit = false
            let vc = testResultPage.createController(router: router)
            from.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    static func showTest(type: Tests, patient: PatientInfo, from: UIViewController, report: Report) {
        let router = Router(storyboard: UIStoryboard.testsStoryboard)
        let testsPage = TestsPage()
        switch type {
        case .tone:
             let viewModel = PreviousACBCTestsViewModel(testType: type, patientInfo: patient, report: report)
             
            let testPage = testsPage.toneTestPage(patientId: patient.id ?? "", report: report, viewModel: viewModel)
            
             testinfo.SetViewModel(viewModels: viewModel)
            //type: type, patient: patient, from: self, report: report!)
            
            let vc = testPage.createController(router: router)
           
            from.navigationController?.pushViewController(vc, animated: true)
        case .speech:
            let testPage = testsPage.wordTestPage(patientId: patient.id ?? "", report: report)
            let viewModel = PreviousACBCTestsViewModel(testType: type, patientInfo: patient, report: report)
            
            let vc = testPage.createController(router: router)
             testinfo.SetViewModel(viewModels: viewModel)
            from.navigationController?.pushViewController(vc, animated: true)
        case .tinnitus:
            NSLog("Hello tinnitus")
            let vc = router.storyboard.instantiateViewController(withIdentifier: "TinnitusTestViewController") as! TinnitusTestViewController
             from.navigationController?.pushViewController(vc, animated: true)
        case .minicog:
            NSLog("Hello mini cog")
            //
            let vc = router.storyboard.instantiateViewController(withIdentifier: "MinicogStep1ViewController") as! MinicogStep1ViewController
            from.navigationController?.pushViewController(vc, animated: true)
            
        case .__unknown(let rawValue):
            let alertVC = UIAlertController(title: "Whoops", message: "Can't show test with type \(rawValue)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: { (action) -> Void in
            })
            alertVC.addAction(okAction)
            from.present(alertVC, animated: true, completion:{ () -> Void in
            })
        }
    }
}

@IBDesignable
class StackView: UIStackView {
   @IBInspectable private var color: UIColor?
    override var backgroundColor: UIColor? {
        get { return color }
        set {
            color = newValue
            self.setNeedsLayout()
        }
    }

    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = self.backgroundColor?.cgColor
    }
}
