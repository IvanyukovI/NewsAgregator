//
//  CurrentNewsVC.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import UIKit

class CurrentNewsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sections = CellsMode.allCases
    var nextBtn: UIBarButtonItem?
    var callback: (()->Void)?
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "Current news"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let customButtonWithImage = UIButton(type: .custom)
        let image = UIImage(named: "heartOff")
        customButtonWithImage.setImage(image, for: .normal)
        customButtonWithImage.setTitleColor(UIColor(named: "btn"), for: .normal)
        customButtonWithImage.addTarget(self, action: #selector(toFavourite), for: .touchUpInside)
        let customNavBarButton = UIBarButtonItem(customView: customButtonWithImage)
        navigationItem.rightBarButtonItems = [customNavBarButton]
        navigationController?.navigationBar.tintColor = UIColor(named: "btn")
        
        btnStat()
    
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        
        tableView.register(MainInfoTVCell.nib, forCellReuseIdentifier: MainInfoTVCell.name)
        tableView.register(DescriptionTVCell.nib, forCellReuseIdentifier: DescriptionTVCell.name)
        tableView.register(LinkTVCell.nib, forCellReuseIdentifier: LinkTVCell.name)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.reloadData()
    }
    
    func btnStat() {
        guard let data = news else { return }
        let customButtonWithImage = UIButton(type: .custom)
        var image = UIImage()
        
        if data.favorite {
            image = UIImage(named: "heartOn") ?? UIImage()
        } else {
            image = UIImage(named: "heartOff") ?? UIImage()
        }
        customButtonWithImage.setImage(image, for: .normal)
        customButtonWithImage.addTarget(self, action: #selector(toFavourite), for: .touchUpInside)
        let customNavBarButton = UIBarButtonItem(customView: customButtonWithImage)
        navigationItem.rightBarButtonItems = [customNavBarButton]
    }
    
    @objc func toFavourite() {
        guard let data = news else { return }
        if data.favorite {
            news?.favorite = false
            UDefHelper.shared.delete(new: data)
        } else {
            news?.favorite = true
            UDefHelper.shared.add(new: news ?? News(article_id: "", title: "", link: "", description: "", pubDate: "", image_url: "", creator: []))
        }
        callback?()
        btnStat()
    }
    
    @objc func toLink() {
        if let url = URL(string: news?.link ?? "") {
            UIApplication.shared.open(url)
        }
    }
}

private extension CurrentNewsVC {
    private enum CellsMode: Int, CaseIterable {
        
        case main
        case descr
        case link
    }
}

extension CurrentNewsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sections[indexPath.section] {
        case .main:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainInfoTVCell.name, for: indexPath) as? MainInfoTVCell else { return UITableViewCell() }
            cell.set(autor: news?.creator ?? [], date: news?.pubDate ?? "", img: news?.image_url ?? "")
            return cell
        case .descr:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTVCell.name, for: indexPath) as? DescriptionTVCell else { return UITableViewCell() }
            cell.set(descr: news?.description ?? "")
            return cell
        case .link:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LinkTVCell.name, for: indexPath) as? LinkTVCell else { return UITableViewCell() }
            cell.linkBtn.removeTarget(nil, action: nil, for: .allEvents)
            cell.linkBtn.addTarget(self, action: #selector(toLink), for: .touchUpInside)
            return cell
        }
    }
}

extension CurrentNewsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 1
    }
}
