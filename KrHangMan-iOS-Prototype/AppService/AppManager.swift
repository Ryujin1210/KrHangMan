//
//  AppManager.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2023/01/09.
//

import Foundation

protocol ServiceAble {
    
}

enum AppService: String {
    case UI, API, UserData
}
// 싱글톤 서비스 관리 객체r
class AppManager {
    private static var services: [AppService: ServiceAble] = [AppService.UI: UIService(), AppService.API: APIService(), AppService.UserData: UserDataService()]
    
    private static func useAppService(appService: AppService) -> ServiceAble?{
        
        return AppManager.services[appService]
    }
    
    static func useUIService() -> UIService {
        let service = useAppService(appService: .UI) as? UIService
        guard let service = service else {
            let initService =  UIService()
            services[.UI] = initService
            return initService        }
        
        return service
    }
    
    static func useAPIService() -> APIService {
        let service = useAppService(appService: .API) as? APIService
        guard let service = service else {
            let initService =  APIService()
            services[.API] = initService
            return initService        }
        
        return service
    }
    
    static func useUserDataService() -> UserDataService {
        let service = useAppService(appService: .UserData) as? UserDataService
        guard let service = service else {
            let initService =  UserDataService()
            services[.UserData] = initService
            return initService
        }
        
        return service
    }
}
