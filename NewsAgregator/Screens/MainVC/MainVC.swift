//
//  MainVC.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBar: UITabBar!
    @IBOutlet weak var loadBtn: UIButton!
    
    private var sections: [Cells] = []
    var currentSegment = 0
    var newsData: [News] = []
    var userNewsData: [News] = []
    var nextPage: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "News agregator"
        
        tableView.dataSource = self
        tableView.delegate = self
        btnBar.delegate = self
        
        tableView.register(EmptyTVCell.nib, forCellReuseIdentifier: EmptyTVCell.name)
        tableView.register(NewsTVCell.nib, forCellReuseIdentifier: NewsTVCell.name)
        
        btnBar.selectedItem = btnBar.items![0] as UITabBarItem
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        
        loadBtn.layer.cornerRadius = 16
        loadBtn.isHidden = true
        
        loadBtn.addTarget(self, action: #selector(loadMore), for: .touchUpInside)
        
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRequest(loadMode: false)
    }
    
    func setupData() {

        sections = []
        newsData = []
        userNewsData = []
        userNewsData = UDefHelper.shared.loadNews()
        getRequest(loadMode: false)
        sections.append(.news)
        tableView.reloadData()
    }
    
    func getRequest(loadMode: Bool) {
        var newsURL: URL
        if loadMode {
            newsURL = URL(string: "https://newsdata.io/api/1/news?apikey=pub_380264e70f5a008a3735fee8e5944219dce18&country=au,us&page=\(nextPage)")!
        } else {
            newsURL = URL(string: "https://newsdata.io/api/1/news?apikey=pub_380264e70f5a008a3735fee8e5944219dce18&country=au,us")!
        }
        NetworkManager.shared.request(url: newsURL, method: "GET", parameters: nil) { result, page  in
            switch result {
            case .success(let data):
                if loadMode {
                    self.newsData = data
                } else {
                    data.forEach { news in
                        self.newsData.append(news)
                    }
                    self.nextPage = page
                }
                self.nextPage = page
                self.findFavoriteMark()
                print(self.newsData)
                DispatchQueue.main.asyncAfter(deadline: .now() ) {
                    self.tableView.reloadData()
                    self.loadMoreStat()
                }
            case .failure(let error):
                print("GET Request Failed. Error: \(error)")
            }
        }
    }
    
    func loadMoreStat() {
        if currentSegment == 0, !newsData.isEmpty {
            let height = tableView.frame.size.height
            let contentYOffset = tableView.contentOffset.y
            let distanceFromBottom = tableView.contentSize.height - contentYOffset
            
            if distanceFromBottom < height {
                loadBtn.isHidden = false
            } else {
                loadBtn.isHidden = true
            }
        } else {
            loadBtn.isHidden = true
        }
    }
    
    func findFavoriteMark() {
        for (i,_) in newsData.enumerated() {
            for (j,_) in userNewsData.enumerated() {
                if newsData[i].article_id == userNewsData[j].article_id {
                    newsData[i].favorite = true
                }
            }
        }
    }
    
    @objc func loadMore() {
        getRequest(loadMode: true)
        tableView.reloadData()
    }
}

private extension MainVC {
    
    private enum Cells: Int, CaseIterable, Codable {
        case news
        case empty
    }
}

extension MainVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .news:
            if currentSegment == 0 {
                return newsData.count > 0 ? newsData.count : 1
            } else {
                return userNewsData.count > 0 ? userNewsData.count : 1
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .empty:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVCell.name, for: indexPath) as? EmptyTVCell else { return UITableViewCell() }
            
            return cell
        case .news:
            switch currentSegment {
            case 0:
                if newsData.isEmpty {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVCell.name, for: indexPath) as? EmptyTVCell else { return UITableViewCell() }
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTVCell.name, for: indexPath) as? NewsTVCell else { return UITableViewCell() }
                    let cellData = newsData[indexPath.row]
                    cell.set(name: cellData.title, autor: cellData.creator, date: cellData.pubDate, text: cellData.description, imgUrl: cellData.image_url)
                    return cell
                }
            case 1:
                if userNewsData.isEmpty {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVCell.name, for: indexPath) as? EmptyTVCell else { return UITableViewCell() }
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTVCell.name, for: indexPath) as? NewsTVCell else { return UITableViewCell() }
                    let cellData = userNewsData[indexPath.row]
                    cell.set(name: cellData.title, autor: cellData.creator, date: cellData.pubDate, text: cellData.description, imgUrl: cellData.image_url)
                    return cell
                }
            default:
                return UITableViewCell()
            }
        }
    }
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sections[indexPath.section] == .news {
            if currentSegment == 0 {
                if !newsData.isEmpty {
                    let vc = CurrentNewsVC()
                    vc.news = newsData[indexPath.row]
                    vc.callback = { [weak self] in
                        guard let self = self else { return }
                        self.setupData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if !userNewsData.isEmpty {
                    let vc = CurrentNewsVC()
                    vc.news = userNewsData[indexPath.row]
                    vc.callback = { [weak self] in
                        guard let self = self else { return }
                        self.setupData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch currentSegment {
        case 1:
            if !userNewsData.isEmpty {
                let delete = UIContextualAction(style: .normal, title: "") { [self] action, view, completionHandler in
                    print("delete")

                    UDefHelper.shared.delete(new: self.userNewsData[indexPath.row])
                    self.setupData()
                    completionHandler(true)
                }

                delete.image = UIImage(named: "Trash")
                delete.backgroundColor = UIColor(named: "bgVC")


                let swipe = UISwipeActionsConfiguration(actions: [delete])
                return swipe
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreStat()
    }
}

extension MainVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if currentSegment != item.tag {
            currentSegment = item.tag
            let sectionIndexToUpdate = 0
            tableView.performBatchUpdates({
                UIView.animate(withDuration: 1) {
                    if self.currentSegment == 0 {
                        self.tableView.reloadSections(IndexSet(integer: sectionIndexToUpdate), with: .right)
                    }
                    if self.currentSegment == 1 {
                        self.tableView.reloadSections(IndexSet(integer: sectionIndexToUpdate), with: .left)
                    }
                }
            }, completion: nil)
        }
    }
}
