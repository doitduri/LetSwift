//
//  PeerListViewModel.swift
//  LetSwift
//
//  Created by Noah on 2022/11/26.
//

import Combine
import Foundation
import MultipeerConnectivity
import NearbyInteraction

final class PeerListViewModel: ObservableObject {
    // MARK: - properties
    
    private var peerConnectionController: PeerConnectionController
    @Published var isNearbySessionEstablished: Bool = false
    @Published var distanceToPeerDevice: String = ""
    @Published var peerName: String = ""
    @Published var peers: [Peer] = []
    @Published private(set) var isSupportedNearbyInteraction: Bool = false
    @Published var isShowAlert: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(peerConnectionController: PeerConnectionController) {
        self.peerConnectionController = peerConnectionController
        self.bindToPeerConnectionController()
    }
}

private extension PeerListViewModel {
    // MARK: - private func
    
    func bindToPeerConnectionController() {
        self.peerConnectionController.$connectedPeer
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] peer in
            self?.peerName = peer?.displayName ?? ""
        }).store(in: &self.cancellables)
        
        self.peerConnectionController.$peers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peers in
                self?.peers = peers
            }.store(in: &self.cancellables)
        
        self.peerConnectionController.$isNISessionEstablished
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isNISessionEstablished in
                self?.isNearbySessionEstablished = isNISessionEstablished
            }.store(in: &self.cancellables)
        
        self.peerConnectionController.$distanceToPeerDevice
            .receive(on: DispatchQueue.main)
            .sink { [weak self] distanceToPeerDevice in
                
            }.store(in: &self.cancellables)
    }
}
