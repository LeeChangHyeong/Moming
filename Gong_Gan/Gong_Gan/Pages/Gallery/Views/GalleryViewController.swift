//
//  GalleryViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/28/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SnapKit
import RxSwift
import RxCocoa

class GalleryViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = GalleryViewModel()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        
        button.tintColor = .white
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "내 일기"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private let galleryIsEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "작성된 일기가 없습니다."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .galleryLabelColor
        
        return label
    }()
    
    private let galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        // 한 줄에 3개의 셀이 표시되도록 설정
        let cellSpacing: CGFloat = 3
        let numberOfItemsPerRow: CGFloat = 3
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - (cellSpacing * (numberOfItemsPerRow - 1) + cellSpacing * 2)) / numberOfItemsPerRow
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .galleryColor
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        collectionView.isHidden = true

        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .galleryColor
        addSubViews()
        setNaviBar()
        setConstraints()
        setupControl()
        setCollectionView()
    }
    
    private func addSubViews() {
        view.addSubview(galleryIsEmptyLabel)
        view.addSubview(galleryCollectionView)
    }
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleLabel
    }
    
    private func setConstraints() {
        galleryIsEmptyLabel.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        })
        
        galleryCollectionView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        })
    }
    
    private func setupControl() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setCollectionView() {
        viewModel.fetchGalleryData()
        
       
            
            viewModel.galleryImageNames
                .bind(to: galleryCollectionView.rx.items(cellIdentifier: GalleryCollectionViewCell.identifier, cellType: GalleryCollectionViewCell.self)) { index, element, cell in
                    self.galleryCollectionView.isHidden = false
                    cell.cellImageView.image = UIImage(named: element)
                }
                .disposed(by: disposeBag)
        
       
        }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//         let width = collectionView.frame.width
//         let height = collectionView.frame.height
//         let itemsPerRow: CGFloat = 2
//         let widthPadding = sectionInsets.left * (itemsPerRow + 1)
//         let itemsPerColumn: CGFloat = 3
//         let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
//         let cellWidth = (width - widthPadding) / itemsPerRow
//         let cellHeight = (height - heightPadding) / itemsPerColumn
//         
//         return CGSize(width: cellWidth, height: cellHeight)
//         
//     }
}
