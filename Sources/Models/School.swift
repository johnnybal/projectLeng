import Foundation
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct School: Identifiable, Codable {
    @DocumentID public var id: String?
    public let name: String
    public let address: String
    public let city: String
    public let postcode: String
    public let coordinates: GeoPoint
    public let type: SchoolType
    public let isVerified: Bool
    public let totalStudents: Int
    public let totalFlames: Int
    public let isActive: Bool
    public let createdAt: Date
    
    public enum SchoolType: String, Codable {
        case highSchool = "HIGH_SCHOOL"
        case college = "COLLEGE"
        case university = "UNIVERSITY"
    }
    
    public var location: String {
        "\(address), \(city), \(postcode)"
    }
    
    public var geoLocation: CLLocation {
        CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case city
        case postcode
        case coordinates
        case type
        case isVerified
        case totalStudents
        case totalFlames
        case isActive
        case createdAt
    }
    
    public init(id: String = UUID().uuidString,
         name: String,
         address: String,
         city: String,
         postcode: String,
         latitude: Double,
         longitude: Double,
         type: SchoolType = .highSchool,
         isVerified: Bool = false,
         totalStudents: Int = 0,
         totalFlames: Int = 0,
         isActive: Bool = true) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.postcode = postcode
        self.coordinates = GeoPoint(latitude: latitude, longitude: longitude)
        self.type = type
        self.isVerified = isVerified
        self.totalStudents = totalStudents
        self.totalFlames = totalFlames
        self.isActive = isActive
        self.createdAt = Date()
    }
} 