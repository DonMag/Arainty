//
//  AraintyCode.swift
//  Arainty
//
//  Created by Don Mag on 4/14/22.
//

import UIKit
import SwiftUI

// MARK: - Main
class ProfileDetail: UIViewController {
	
	// Table view data
	private let tableDelegate = ProfileDetailInfoDelegate()
	private let tableDataSource = ProfileDetailInfoDataSource()
	private let info: UITableView = {
		let v = UITableView(frame: .zero, style: .insetGrouped)
		v.backgroundColor = .systemBackground
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	private lazy var infoHeightConstraint: NSLayoutConstraint = {
		info.heightAnchor.constraint(equalToConstant: 0.0)
	}()
	
	// Navigation bar
	private let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.contentInsetAdjustmentBehavior = .never
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		// MARK: Navigation bar
		let appearance = UINavigationBarAppearance()
		appearance.configureWithTransparentBackground()
		navigationItem.standardAppearance = appearance
		navigationItem.scrollEdgeAppearance = appearance
		
		// MARK: Views declaration
		// Container for carousel
		let stretchyView = UIView()
		stretchyView.backgroundColor = .darkGray
		stretchyView.translatesAutoresizingMaskIntoConstraints = false
		
		// Carousel
		guard let x1 = UIImage(named: "1"),
			  let x2 = UIImage(named: "2"),
			  let x3 = UIImage(named: "3")
		else {
			fatalError("Could not load images!")
		}
		let carouselController = ProfileDetailCarousel(images: [
			x1, x2, x3
		])
		addChild(carouselController)
		let carousel: UIView = carouselController.view
		carousel.translatesAutoresizingMaskIntoConstraints = false
		stretchyView.addSubview(carousel)
		carouselController.didMove(toParent: self)
		
		// Container for below-carousel views
		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.backgroundColor = .red
		
		// Texts and bio
		let bioController = UIHostingController(rootView: ProfileDetailBio(), ignoreSafeArea: true)
		addChild(bioController)
		let bio: UIView = bioController.view
		bio.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(bio)
		bioController.didMove(toParent: self)
		
		// Info table
		info.delegate = tableDelegate
		info.dataSource = tableDataSource
		//tableDelegate.viewController = self
		contentView.addSubview(info)
		
		[stretchyView, contentView].forEach { v in
			scrollView.addSubview(v)
		}
		view.addSubview(scrollView)
		
		// MARK: Constraints
		let stretchyTop = stretchyView.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor)
		stretchyTop.priority = .defaultHigh
		NSLayoutConstraint.activate([
			// Scroll view
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			//scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			// Stretchy view
			stretchyTop,
			
			stretchyView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
			stretchyView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
			stretchyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 350.0),
			
			// Carousel
			carousel.topAnchor.constraint(equalTo: stretchyView.topAnchor),
			carousel.bottomAnchor.constraint(equalTo: stretchyView.bottomAnchor),
			carousel.centerXAnchor.constraint(equalTo: stretchyView.centerXAnchor),
			carousel.widthAnchor.constraint(equalTo: stretchyView.widthAnchor),
			
			// Content view
			contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
			contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 350.0),
			contentView.topAnchor.constraint(equalTo: stretchyView.bottomAnchor),
			
			// Bio
			bio.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
			bio.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			bio.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			
			// Info table
			info.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 12.0),
			info.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			info.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			info.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			infoHeightConstraint
		])
		
	}
	
	// MARK: UIViewController
	override func updateViewConstraints() {
		super.updateViewConstraints()
		
		infoHeightConstraint.constant = info.contentSize.height // almost full size
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		infoHeightConstraint.constant = info.contentSize.height // full size
	}
}

// MARK: - Carousel
class ProfileDetailCarousel: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	private var images = [UIViewController]()
	private var imagesContents = [UIImage]()
	
	init(images: [UIImage]) {
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
		imagesContents = images
		for image in images {
			let controller = UIViewController()
			let imageView = UIImageView(image: image)
			imageView.contentMode = .scaleAspectFill
			imageView.clipsToBounds = true
			controller.view = imageView
			self.images.append(controller)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegate = self
		dataSource = self
		
		setViewControllers([images[0]], direction: .forward, animated: true)
	}
	
	// MARK: - UIPageViewControllerDataSource
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = images.firstIndex(of: viewController) else { return nil }
		let previousIndex = viewControllerIndex - 1
		guard previousIndex >= 0 else { return images.last }
		guard images.count > previousIndex else { return nil }
		return images[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = images.firstIndex(of: viewController) else { return nil }
		let nextIndex = viewControllerIndex + 1
		guard nextIndex < images.count else { return images.first }
		guard images.count > nextIndex else { return nil }
		return images[nextIndex]
	}
	
	// Page dots
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return images.count
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return 0 // it works like that soooo
	}
}

// MARK: - Details table' UITableViewDelegate
class ProfileDetailInfoDelegate: NSObject, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - Details table' UITableViewDataSource
class ProfileDetailInfoDataSource: NSObject, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return 2
		case 2:
			return 3
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
		if cell == nil {
			cell = UITableViewCell(style: .value1, reuseIdentifier: "cellId")
		}
		cell!.backgroundColor = .secondarySystemFill
		cell!.selectionStyle = .none
		var configuration = cell!.defaultContentConfiguration()
		configuration.text = "Title"
		configuration.secondaryText = "Value"
		if indexPath.section == 0 {
			configuration.secondaryTextProperties.color = .systemGreen
		}
		cell!.contentConfiguration = configuration
		return cell!
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Header 1"
		case 1:
			return "Header 2"
		case 2:
			return "Header 3"
		default:
			return nil
		}
	}
}

extension UIHostingController {
	convenience public init(rootView: Content, ignoreSafeArea: Bool) {
		self.init(rootView: rootView)
		
		if ignoreSafeArea {
			disableSafeArea()
		}
	}
	
	func disableSafeArea() {
		guard let viewClass = object_getClass(view) else { return }
		
		let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
		if let viewSubclass = NSClassFromString(viewSubclassName) {
			object_setClass(view, viewSubclass)
		}
		else {
			guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
			guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }
			
			if let method = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)) {
				let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in
					return .zero
				}
				class_addMethod(viewSubclass, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
			}
			
			objc_registerClassPair(viewSubclass)
			object_setClass(view, viewSubclass)
		}
	}
}

struct ProfileDetailBio: View {
	var body: some View {
		VStack {
			VStack(alignment: .center, spacing: 0) {
				HStack(spacing: 5) {
					Image(systemName: "gear")
						.foregroundColor(.primary)
						.scaleEffect(0.9)
					Text("Lorem ipsum")
						.bold()
				}
				Text("Lorem ipsum")
					.lineLimit(1)
					.fixedSize()
				HStack {
					Text("Label")
				}
				.foregroundColor(.secondary)
			}
			.frame(maxWidth: .infinity)
			VStack(alignment: .leading) {
				if #available(iOS 15.0, *) {
					let colors: [Color] = [
						.red, .blue, .green, .orange, .purple, .black
					]
					ForEach(0..<colors.count) { i in
						Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque nec odio ut elit congue imperdiet non eget nulla. Donec mollis pellentesque nisi, quis suscipit quam suscipit nec.\nFusce faucibus magna id molestie malesuada. Nunc eget vehicula ligula.")
							.fixedSize(horizontal: false, vertical: true)
							.textSelection(.enabled)
							.foregroundColor(colors[i])
						Spacer()
					}
				} else {
					Text("iOS 14 text")
						.fixedSize(horizontal: false, vertical: true)
				}
			}
			.padding()
		}
	}
}

#if DEBUG
struct ProfileDetailBio_Previews: PreviewProvider {
	static var previews: some View {
		ProfileDetailBio()
	}
}
#endif
