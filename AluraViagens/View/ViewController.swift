//
//  ViewController.swift
//  AluraViagens
//
//  Created by Ricardo dos Santos Amaral on 20/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var viagensTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configurarTableView()
        
        view.backgroundColor = UIColor(red: 30/255, green: 59/255, blue: 118/255, alpha: 1)
    }
    
    func configurarTableView() {
        viagensTableView.register(UINib(nibName: "ViagemTableViewCell", bundle: nil), forCellReuseIdentifier: "ViagemTableViewCell")
        viagensTableView.register(UINib(nibName: "OfertaTableViewCell", bundle: nil), forCellReuseIdentifier: "OfertaTableViewCell")
        viagensTableView.dataSource = self
        viagensTableView.delegate = self
        viagensTableView.sectionHeaderTopPadding = 0
    }
    
    func irParaDetalhes(_ viagem: Viagem?) {
        if let viagem = viagem {
            let detalheController = DetalheViewController.instanciar(viagem)
            navigationController?.pushViewController(detalheController, animated: true)            
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sessaoDeViagens?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessaoDeViagens?[section].numeroDeLinhas ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = sessaoDeViagens?[indexPath.section]
        
        switch viewModel?.tipo {
        case .destaques:
            guard let celulaViagem = tableView.dequeueReusableCell(withIdentifier: "ViagemTableViewCell") as? ViagemTableViewCell else {
                fatalError("Error to create ViagemTableViewCell")
            }
            
            celulaViagem.configurarCelula(viewModel?.viagens[indexPath.row])
            return celulaViagem
            
        case .ofertas:
            guard let celulaOferta = tableView.dequeueReusableCell(withIdentifier: "OfertaTableViewCell") as? OfertaTableViewCell else {
                fatalError("Error to create OfertaTableViewCell")
            }
            celulaOferta.delegate = self
            celulaOferta.configurarCelula(viewModel?.viagens)
            return celulaOferta
            
        default:
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewModel = sessaoDeViagens?[indexPath.section]
        
        switch viewModel?.tipo {
        case .destaques, .internacionais:
            let viagemSelecionada = viewModel?.viagens[indexPath.row]
            irParaDetalhes(viagemSelecionada)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = Bundle.main.loadNibNamed("HomeTableViewHeader", owner: self, options: nil)?.first as? HomeTableViewHeader
            headerView?.configurarView()
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .phone ? 400 : 475
    }
}

extension ViewController: OfertaTableViewCellDelegate {
    func didSelectView(_ viagem: Viagem?) {
        irParaDetalhes(viagem)
    }
}
