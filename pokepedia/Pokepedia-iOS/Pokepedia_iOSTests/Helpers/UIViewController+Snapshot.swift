//
//  UIImage+Creation.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Vasiliy Klyotskin on 6/19/23.
//

import UIKit

extension UIViewController {
	func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
		return SnapshotWindow(configuration: configuration, root: self).snapshot()
	}
}

struct SnapshotConfiguration {
	let size: CGSize
	let safeAreaInsets: UIEdgeInsets
	let layoutMargins: UIEdgeInsets
	let traitCollection: UITraitCollection
	
    static func `default`(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium, height: CGFloat = 844) -> SnapshotConfiguration {
		return SnapshotConfiguration(
			size: CGSize(width: 390, height: height),
			safeAreaInsets: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
			layoutMargins: UIEdgeInsets(top: 55, left: 8, bottom: 42, right: 8),
			traitCollection: traitCollection(for: contentSize, style: style)
        )
	}
    
    private static func traitCollection(for contentSize: UIContentSizeCategory, style: UIUserInterfaceStyle) -> UITraitCollection {
        return UITraitCollection(mutations: { builder in
            builder.forceTouchCapability = .unavailable
            builder.layoutDirection = .leftToRight
            builder.preferredContentSizeCategory = contentSize
            builder.userInterfaceIdiom = .phone
            builder.horizontalSizeClass = .compact
            builder.verticalSizeClass = .regular
            builder.displayScale = 3
            builder.accessibilityContrast = .normal
            builder.displayGamut = .P3
            builder.userInterfaceStyle = style
        })
    }
}

private final class SnapshotWindow: UIWindow {
	private var configuration: SnapshotConfiguration = .default(style: .light)
	
	convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
		self.init(frame: CGRect(origin: .zero, size: configuration.size))
		self.configuration = configuration
		self.layoutMargins = configuration.layoutMargins
		self.rootViewController = root
		self.isHidden = false
		root.view.layoutMargins = configuration.layoutMargins
	}
	
	override var safeAreaInsets: UIEdgeInsets {
		return configuration.safeAreaInsets
	}
	
	override var traitCollection: UITraitCollection {
        configuration.traitCollection
	}
	
	func snapshot() -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
		return renderer.image { action in
			layer.render(in: action.cgContext)
		}
	}
}
