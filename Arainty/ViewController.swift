//
//  ViewController.swift
//  Arainty
//
//  Created by Don Mag on 4/14/22.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let b = UIButton(type: .system)
		b.setTitle("Push To Profile", for: [])
		b.addTarget(self, action: #selector(btnTap(_:)), for: .touchUpInside)
		b.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(b)
		b.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		b.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
	}

	@objc func btnTap(_ sender: Any?) {
		let vc = ProfileDetail()
		navigationController?.pushViewController(vc, animated: true)
	}
}

