//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by 김동환 on 2021/04/26.
//

import UIKit

class ToDoListViewController: UICollectionViewController {
    
    let todoListViewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoListViewModel.retrieveTodo()
    }
    
}


extension ToDoListViewController {
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return todoListViewModel.numberOfsections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return todoListViewModel.todayTodos.count
        } else {
            return todoListViewModel.upcommingTodos.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {return UICollectionViewCell()}
        
        var todo: Todo
        
        if indexPath.section == 0 {
            //투데이
            todo = todoListViewModel.todayTodos[indexPath.item]
            
        } else {
            //업커밍
            todo = todoListViewModel.upcommingTodos[indexPath.item]
        }
        
        cell.updateUI(todo: todo)
        
        return cell
        
    }
  
    
    
    //커스텀 헤더가 있는 경우 헤더도 설정해줘야 함
    //헤더의 수만큼 호출 됨
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            //셀을 뽑듯이 헤더도 collectionView에서 reusableSupplementaryView에서 뽑음
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else {return UICollectionReusableView()}
            
            guard let section = TodoViewModel.Section(rawValue: indexPath.section) else {return UICollectionReusableView()}
            
            header.sectionTitleLabel.text = section.sectionTitle
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
    
}


extension ToDoListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}



class TodoListCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    //여기서 적어주는대로 뷰에 표시된다. 아웃렛으로 안빼면 표시 안됨
    @IBOutlet weak var strikeThroughView: UIView!
    @IBOutlet weak var strikeThroughWidth: NSLayoutConstraint!
    
    // cell이 reuse 될 때를 대비해서 필요함
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    

    func updateUI(todo: Todo){
        self.checkButton.isSelected = todo.isDone
        self.descriptionLabel.text = todo.detail
        self.descriptionLabel.alpha = todo.isDone ? 0.2 : 1.0
        self.deleteButton.isHidden = todo.isDone ? true : false
        
    }
    
    private func showStrikeThrough(_ show: Bool){
        
        if show {
            //width정보는 뷰의 고유 정보이기 때문에 bounds에 있다
            strikeThroughWidth.constant = descriptionLabel.bounds.width
        } else {
            strikeThroughWidth.constant = 0
        }
    }
    
    func reset(){
        
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
    }
    
}


//헤더도 클래스 적용시켜줘야 표시됨
class TodoListHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

