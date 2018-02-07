//
//  IPresent.swift
//  Diagrammer
//
//  Created by Kirill Khudyakov on 07.02.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import UIKit


protocol IPresent {
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
}
