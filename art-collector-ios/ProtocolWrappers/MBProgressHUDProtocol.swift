//
//  MBProgressHUDProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/19/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import MBProgressHUD

protocol MBProgressHUDProtocol {
    func show(onView: UIView, animated: Bool)
    func show(onView: UIView, animated: Bool, message: String)
    
    func hide(onView: UIView, animated: Bool)
}

struct MBProgressHUDClient: MBProgressHUDProtocol {
    // MARK: - <MBProgressHUDProtocol>
    
    func show(onView: UIView, animated: Bool) {
        MBProgressHUD.showAdded(to: onView, animated: animated)
    }
    
    func show(onView: UIView, animated: Bool, message: String) {
        let hud = MBProgressHUD.showAdded(to: onView, animated: animated)
        hud.label.text = message
    }
    
    func hide(onView: UIView, animated: Bool) {
        MBProgressHUD.hide(for: onView, animated: animated)
    }
}
