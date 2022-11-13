//
//  GuestBookListViewModel.swift
//  LetSwift
//
//  Created by Dongju on 2022/11/11.
//

import Foundation
import RxSwift
import RxRelay

class GuestBookListViewModel: ObservableObject {
    var titleString: String = ""
    @Published var welcome: Welcome?

    
    struct Action {
        var guestBookList = PublishRelay<Void>()
    }
    
    struct State {
        var receiveData = PublishRelay<Void>()
    }
    var action = Action()
    var state = State()
    var disposeBag = DisposeBag()
    
    init(){
        titleString = """
            \("Let' play".convertString(text: "Let"))
            \("at Swift Playgrounds".convertString(text: "Swift"))
        """
        binding()
    }
    
    func binding(){
        self.action.guestBookList
            .flatMap{
                NetworkService.shared.request(.healthCheck, expectingReturnType: Welcome.self)
            }.subscribe(onNext: { [weak self] result in
                guard let self = self else { return  }
                switch result {
                case .success(let response):
                    print("\(response)")
                    self.welcome = response
                    SharedPreference.shared.welcome = response
//                    self.state.receiveData.accept(())
                case .failure(let response):
                    //Local storage data use
                    print(response.localizedDescription)
                    self.welcome = SharedPreference.shared.welcome
                }
            }).disposed(by: self.disposeBag)
    }
}

extension GuestBookListViewModel {
    
}
