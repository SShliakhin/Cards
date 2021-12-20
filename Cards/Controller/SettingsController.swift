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

    private var numberOfPairsOfCards = getDefaultNumberOfPairsOfCards() {
        didSet {
            numberOfPairsLabel.text = "\(numberOfPairsOfCards) Pairs of cards"
            settingsStorage.saveNumberOfPairsOfCards(numberOfPairsOfCards)
        }
    }

    lazy var numberOfPairsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "X Pairs of cards"
        return label
    }()

    lazy var stepperForPairs: UIStepper = {
        let stepper = UIStepper(frame: .zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.value = Double(settingsStorage.loadNumberOfPairsOfCards())
        stepper.minimumValue = 1
        stepper.maximumValue = 20
        stepper.stepValue = 1
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.sizeToFit()
        let newValue = UIAction(handler: { _ in
            self.numberOfPairsOfCards = Int(stepper.value)
        })
        stepper.addAction(newValue, for: .valueChanged)
        return stepper
    }()

    lazy var numberOfPairsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [numberOfPairsLabel, stepperForPairs])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
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
        numberOfPairsOfCards = settingsStorage.loadNumberOfPairsOfCards()
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
        view.addSubview(numberOfPairsStackView)
        view.addSubview(tableView)
        let constraints = [
            numberOfPairsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            numberOfPairsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            numberOfPairsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: numberOfPairsStackView.bottomAnchor, constant: 8),
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
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: BackTableViewCell.identifier,
                for: indexPath
            ) as? BackTableViewCell {
                cell.setting = currentSetting
                return cell
            }
        case .shape:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: ShapeTableViewCell.identifier,
                for: indexPath
            ) as? ShapeTableViewCell {
                cell.setting = currentSetting
                return cell
            }
        case .color:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath)
            configureColorCell(cell, by: currentSetting)
            return cell
        }
        return UITableViewCell()
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
        tableView.reloadSections([indexPath.section], with: .automatic)
        // tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
