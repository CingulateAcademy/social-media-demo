import UIKit


class MainTabBarController: UITabBarController{
    
    private let floatingButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        
        setupAppearance()
        setupFloatingButton()
    }
    
    
    private func setupTabs(){
        
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let notificationVC = NotificationViewController()
        let profileVC = ProfileViewController()
        
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let searchNav = UINavigationController(rootViewController:searchVC)
        let notificationNav = UINavigationController(rootViewController: notificationVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        
//        tab bar items
        
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        
        searchNav.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
    
        
        
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        notificationNav.tabBarItem = UITabBarItem(
            title: "Activity",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        
        notificationNav.tabBarItem.badgeValue = "5"
        
        
        viewControllers = [homeNav, searchNav, notificationNav, profileNav]
        
        
        
        
        
        
        
        
        
    }
    
    
    private func setupAppearance(){
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = .systemBackground
        
        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .secondaryLabel
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *){
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = .systemBlue
        
        
        
    }
    
    
    private func setupFloatingButton(){
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        
//        Twitter/X style: solid circle with + icon
        
        config.cornerStyle = .capsule
        
        config.baseBackgroundColor = .label
        config.baseForegroundColor = .systemBackground
        
        config.image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22,weight: .bold)
        )
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16,bottom:16, trailing:16)
        
        floatingButton.configuration = config
        
//        soft shadow for light and dark mode
        
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        
        floatingButton.layer.shadowOpacity = 0.28
        
        floatingButton.layer.shadowOffset = CGSize(width:0, height: 6)
        floatingButton.layer.shadowRadius = 12
        floatingButton.layer.masksToBounds = false
        
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        view.addSubview(floatingButton)
        
        
        NSLayoutConstraint.activate([
            
            floatingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            floatingButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -16),
            
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
        
    }
    
    @objc private func floatingButtonTapped(){
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        
        generator.impactOccurred()
        
        let compose = CreatePostViewController()
        
        let nav = UINavigationController(rootViewController: compose)
        
        nav.modalPresentationStyle = .pageSheet
        
        
        if let sheet = nav.sheetPresentationController{
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        present(nav, animated: true)
        
        
        
        
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        view.bringSubviewToFront(floatingButton)
    }
    
    
}
