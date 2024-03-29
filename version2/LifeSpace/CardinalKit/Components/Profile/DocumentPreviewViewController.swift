//
//  DocumentPreviewViewController.swift
//
//  Created for the CardinalKit framework.
//  Copyright © 2020 CardinalKit. All rights reserved.
//

import UIKit
import SwiftUI

struct DocumentPreviewViewController: UIViewControllerRepresentable {
    private var isActive: Binding<Bool>
    private let viewController = UIViewController()
    private var docController: UIDocumentInteractionController?

    init(_ isActive: Binding<Bool>, url: URL?) {
        self.isActive = isActive
        if let url = url {
            self.docController = UIDocumentInteractionController(url: url)
        }
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPreviewViewController>) -> UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DocumentPreviewViewController>) {
        if self.isActive.wrappedValue && docController?.delegate == nil { // to not show twice
            self.docController?.delegate = context.coordinator
            self.docController?.presentPreview(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(owner: self)
    }

    final class Coordinator: NSObject, UIDocumentInteractionControllerDelegate { // works as delegate
        let owner: DocumentPreviewViewController
        init(owner: DocumentPreviewViewController) {
            self.owner = owner
        }
        func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
            return owner.viewController
        }

        func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
            controller.delegate = nil // done, so unlink self
            owner.isActive.wrappedValue = false // notify external about done
        }
    }
}
