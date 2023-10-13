//
//  FavouriteImagesController.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import UIKit

final class FavouriteImagesViewController: UIViewController {

    var presenter: FavouriteImagesPresenter

    private var tableView: UITableView?
    private let textIfEmpty = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewWillAppear()
        tableView?.reloadData()
    }

    init(presenter: FavouriteImagesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI

extension FavouriteImagesViewController {
    private func setupUI() {
        tableView = UITableView(frame: self.view.bounds)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        tableView?.register(FavouriteImagesTableViewCell.self, forCellReuseIdentifier: FavouriteImagesTableViewCell.identifier)
        self.view.addSubview(tableView ?? UITableView())

        textIfEmpty.translatesAutoresizingMaskIntoConstraints = false
        textIfEmpty.font = .systemFont(ofSize: 32)
        textIfEmpty.text = "Add photo to favourites"
        textIfEmpty.isHidden = true
        self.view.addSubview(textIfEmpty)

        NSLayoutConstraint.activate([
            textIfEmpty.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textIfEmpty.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: Setup TableView

extension FavouriteImagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.imageData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: FavouriteImagesTableViewCell.identifier
        ) as? FavouriteImagesTableViewCell,
           let image = presenter.imageData[safe: indexPath.row] {
            cell.configure(image: image)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let image = presenter.imageData[safe: indexPath.row] else { return }
        let vc = ImageDetailsAssembly.assembleImageDetailsModule(image: image, fromFavouritePhoto: true, delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Delegate

extension FavouriteImagesViewController: ImageDetailsViewControllerDelegate {
    func passImageData(image: Image) {
        presenter.passImageData(image: image)
    }
    
    func deleteImageData(image: Image) {
        presenter.deleteImageData(image: image)
    }
}

// MARK: ViewInput

extension FavouriteImagesViewController: FavouriteImagesViewInput {
    func reloadData() {
        self.tableView?.reloadData()
    }

    func showAlert(isEmpty: Bool) {
        if isEmpty {
            let alertController = alertMessage(
                title: "No image",
                description: "Please, add image to favourites",
                buttonDefaultTitle: "OK",
                handlerDestructive: { _ in },
                handlerDefault: { _ in }
            )
            present(alertController, animated: true)

            tableView?.isHidden = true
            textIfEmpty.isHidden = false
        } else {
            tableView?.isHidden = false
            textIfEmpty.isHidden = true
        }
    }
}
