//
//  DetailBookmarkDelegate.swift
//  Go Ask a Duck
//
//  Created by Michael Meyer on 8/5/17.
//  Copyright © 2017 Michael Meyer. All rights reserved.
//

import Foundation

protocol DetailBookmarkDelegate: class {
    func bookmarkPassedURL(url: String) -> Void
}
