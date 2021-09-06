//
//  SettingsController.swift
//  Cards
//
//  Created by SERGEY SHLYAKHIN on 15.08.2021.
//

import UIKit

class SettingsController: UIViewController {

    // MARK: - Properties
    var settingsStorage: GameStorageProtocol = GameStorage()
    
    var settingsRecords: [SettingsType: [SettingsProtocol]] = [:] {
        didSet {
            var savingArray: [SettingsProtocol] = []
            settingsRecords.forEach { _, value in
                savingArray += value
            }
            settingsStorage.saveSettings(savingArray)
        }
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44
        table.register(BackTableViewCell.self, forCellReuseIdentifier: BackTableViewCell.identifier)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "ColorCell")
        table.register(ShapeTableViewCell.self, forCellReuseIdentifier: ShapeTableViewCell.identifier)
        return table
    }()
    
    
    
    // порядок отображения секций по типам
    // индекс в массиве соответствует индексу секции в таблице
    var sectionsPosition: [SettingsType] = [.back, .shape, .color]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .lightGray

        setupViews()
        setSettings(settingsStorage.loadSettings())
    }
    
    // MARK: - Custom methods
    
    func setSettings(_ settingsCollection: [SettingsProtocol]) {
        sectionsPosition.forEach { settingType in
            settingsRecords[settingType] = []
        }
        settingsCollection.forEach { setting in
            settingsRecords[setting.type]?.append(setting)
        }
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureColorCell(_ cell: UITableViewCell, by setting: SettingsProtocol) {
        let title = setting.title
        var content = cell.defaultContentConfiguration()
        content.text = getSymbolForSelect(with: setting.status)
        content.textProperties.alignment = .center
        if title == "black" {
            content.textProperties.color = .white
        }
        cell.contentConfiguration = content
        cell.backgroundColor = getColorByText(title)
    }
}

extension SettingsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsRecords.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(describing: sectionsPosition[section]).uppercased()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let settingsType = sectionsPosition[section]
        return settingsRecords[settingsType]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sectionsPosition[indexPath.section]
        switch section {
        case .back: return 60.0
        case .shape: return 100.0
        default:
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sectionsPosition[indexPath.section]
        let currentSetting = settingsRecords[section]![indexPath.row]
        
        switch section {
        case .back:
            let cell = tableView.dequeueReusableCell(withIdentifier: BackTableViewCell.identifier, for: indexPath) as! BackTableViewCell
            cell.setting = currentSetting
            return cell
        case .shape:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShapeTableViewCell.identifier, for: indexPath) as! ShapeTableViewCell
            cell.setting = currentSetting
            return cell
        case .color:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath)
            configureColorCell(cell, by: currentSetting)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var title: String?
        let section = sectionsPosition[section]
        let settings = settingsRecords[section]!
        let used = settings.filter { $0.status }.count
        if used == 0 {
            title = "\(String(describing: section)) random from \(settings.count) value"
        } else {
            title = "\(String(describing: section)) random from \(used) value"
        }
        return title
    }
}

extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sectionsPosition[indexPath.section]
        settingsRecords[section]![indexPath.row].status.toggle()
        //tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

