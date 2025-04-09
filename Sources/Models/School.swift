import Foundation
import CoreLocation

struct School: Codable, Identifiable {
    let id: String
    var name: String
    var address: String
    var city: String
    var postcode: String
    var coordinates: GeoPoint
    var totalStudents: Int
    var totalFlames: Int
    var isActive: Bool
    var createdAt: Date
    
    struct GeoPoint: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    var location: CLLocation {
        CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    init(id: String = UUID().uuidString,
         name: String,
         address: String,
         city: String,
         postcode: String,
         latitude: Double,
         longitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.postcode = postcode
        self.coordinates = GeoPoint(latitude: latitude, longitude: longitude)
        self.totalStudents = 0
        self.totalFlames = 0
        self.isActive = true
        self.createdAt = Date()
    }
} 