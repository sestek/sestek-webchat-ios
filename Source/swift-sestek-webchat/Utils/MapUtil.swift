//
//  MapUtil.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 31.10.2022.
//

import MapKit

class MapUtil {
    
    struct InstalledMapModel {
        public let mapName: String
        public let mapType: MapType
    }

    public enum MapType: String {
        case apple = "apple"
        case google = "google"
        case yandex = "yandex"
    }
    
    static let shared: MapUtil = MapUtil()
    
    func getInstalledMaps() -> [InstalledMapModel] {
        var installedMaps: [InstalledMapModel] = []
        if UIApplication.shared.canOpenURL(URL(string: "http://maps.apple.com")!) {
            installedMaps.append(InstalledMapModel(mapName: "Apple Maps", mapType: .apple))
        }
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            installedMaps.append(InstalledMapModel(mapName: "Google Maps", mapType: .google))
        }
        if UIApplication.shared.canOpenURL(URL(string: "yandexnavi://")!) {
            installedMaps.append(InstalledMapModel(mapName: "Yandex Maps", mapType: .yandex))
        }
        
        return installedMaps
    }
    
    func onMapSelected(selectedMap: InstalledMapModel, latitude: Double, longitude: Double) {
        switch selectedMap.mapType {
        case .apple:
            openDefaultMap(latitude: latitude, longitude: longitude)
        case .google:
            openGoogleMaps(latitude: latitude, longitude: longitude)
        case .yandex:
            openYandexMaps(latitude: latitude, longitude: longitude)
        }
    }
    
    func openDefaultMap(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func openGoogleMaps(latitude: Double, longitude: Double) {
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openYandexMaps(latitude: Double, longitude: Double) {
        if let url = URL(string: "yandexnavi://build_route_on_map?lat_to=" + "\(latitude)" + "&lon_to=" + "\(longitude)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
