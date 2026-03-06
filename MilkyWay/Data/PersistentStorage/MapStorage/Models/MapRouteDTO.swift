//
//  MapRouteDTO.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.02.2026.
//

import Foundation
import SwiftData

struct CoordinateDTO: Codable {
    var id: String
    var latitude: Double
    var longitude: Double
    
    init(
        id: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from domain: Coordinate) {
        self.init(
            id: domain.id,
            latitude: domain.latitude,
            longitude: domain.longitude
        )
    }
}

extension CoordinateDTO {
    static func c(_ id: String, _ latitude: Double, _ longitude: Double) -> CoordinateDTO {
        CoordinateDTO(id: id, latitude: latitude, longitude: longitude)
    }
}

enum MapRouteDTOMigrationPlan: SchemaMigrationPlan {
    
//    static var schemas: [any VersionedSchema.Type] { [MapRouteDTOAppSchemaV1.self, BudgetAppSchemaV2.self] }
    static var schemas: [any VersionedSchema.Type] { [MapRouteDTOAppSchemaV1.self] }
    
    static var stages: [MigrationStage] {
//        [migrateV1toV2]
        []
    }
    
    
//    static let migrateV1toV2 = MigrationStage.custom(fromVersion: BudgetAppSchemaV1.self, toVersion: BudgetAppSchemaV2.self) { context in
//        
//        print("willMigrate migrateV1toV2")
//        
//    } didMigrate: { context in
//        
//        print("didMigrate start")
//        let budgets = try context.fetch(FetchDescriptor<BudgetAppSchemaV2.Budget>())
//        
//        for budget in budgets {
//            budget.desc = "This is description for \(budget.name)"
//        }
//        
//        try context.save()
//        print("didMigrate migrateV1toV2")
//    }
//    
}


typealias MapRouteDTO = MapRouteDTOAppSchemaV1.MapRouteDTO

enum MapRouteDTOAppSchemaV1: VersionedSchema {
    static let versionIdentifier: Schema.Version = .init(1, 0, 0)
    static var models: [any PersistentModel.Type] { [MapRouteDTOAppSchemaV1.MapRouteDTO.self] }
    
    @Model
    final class MapRouteDTO {
        @Attribute(.unique)
        var id: String
        var name: String
        var startLocation: CoordinateDTO
        var endLocation: CoordinateDTO
        var polylineCoordinates: [CoordinateDTO]
        var createdAt: Date
        
        init(
            id: String,
            name: String,
            startLocation: CoordinateDTO,
            endLocation: CoordinateDTO,
            polylineCoordinates: [CoordinateDTO],
            createdAt: Date
        ) {
            Log.debug("MapRouteDTO created with id \(id)")
            self.id = id
            self.name = name
            self.startLocation = startLocation
            self.endLocation = endLocation
            self.polylineCoordinates = polylineCoordinates
            self.createdAt = createdAt
        }
        
        convenience init(from protected: MapRoute) {
            Log.debug("MapRouteDTO created from protected with id \(protected.id)")
            self.init(
                id: protected.id,
                name: protected.name,
                startLocation: .init(from: protected.startLocation),
                endLocation: .init(from: protected.endLocation),
                polylineCoordinates: protected.polylineCoordinates.map { CoordinateDTO(from: $0) },
                createdAt: protected.createdAt
            )
        }
    }
}

extension MapRouteDTO {
    @MainActor
    static let preview: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: MapRouteDTO.self,
                configurations: config
            )

            let context = container.mainContext

            let route1 = MapRouteDTO(
                id: "DA026D5E-83CD-4744-8329-66F8FE692B96",
                name: "New Route 1",
                startLocation: .init(
                    id: "EDE69746-5FB6-46F9-A8FB-E4DA0FEF48CA",
                    latitude: 37.33087803,
                    longitude: -122.0305999
                ),
                endLocation: .init(
                    id: "967CB665-0A22-4004-A743-97E78710E80A",
                    latitude: 37.33020696,
                    longitude: -122.02657718
                ),
                polylineCoordinates: [
                    .c("FAB65CA7-28B0-4A9A-9EBD-E385D95420D7", 37.33087803, -122.0305999),
                    .c("4A026799-2E0E-42F0-8069-0DD374D85705", 37.33072336, -122.0305179),
                    .c("15B70229-563E-4422-9B08-6423D1E8501C", 37.33067186, -122.03002927),
                    .c("BE4BBB75-5CCF-4D5C-8E00-0AA9F0FE0422", 37.33069273, -122.02971484),
                    .c("BF8E4912-97E1-4669-8674-94ED681924AD", 37.3306951, -122.02938314),
                    .c("FFE850BE-755C-4EC7-A9DC-9E63EF5EC119", 37.33056973, -122.0288791),
                    .c("F53AADE1-9A31-48B9-BE29-1053F35E5073", 37.33035778, -122.02841155),
                    .c("AB072C26-2C7A-4122-AFA1-F8A5FC39CFA6", 37.33028179, -122.02799851),
                    .c("E4FBC4EE-BC13-4495-AE04-1A6E069AF89C", 37.33025023, -122.02738579),
                    .c("1C43C3AC-5271-47FF-AEE2-368276191CA3", 37.33023169, -122.02690797),
                    .c("22E67302-8001-4CF6-9B05-EA3670D96214", 37.33020696, -122.02657718)
                ],
                createdAt: ISO8601DateFormatter().date(from: "2026-03-06T14:00:22Z") ?? Date()
            )

            let route2 = MapRouteDTO(
                id: "BCD78702-A78D-418B-B223-C59993D9F1F2",
                name: "New Route 2 ",
                startLocation: .init(
                    id: "296ED3AB-0539-4667-BB93-6B6CCF6AB0FB",
                    latitude: 37.33020111,
                    longitude: -122.02457648
                ),
                endLocation: .init(
                    id: "12DA06DA-F943-496E-A1D2-B2F42EAD57FC",
                    latitude: 37.32940293,
                    longitude: -122.01980518
                ),
                polylineCoordinates: [
                    .c("3CF8EDD5-A87D-4057-809C-6259B5193304", 37.33020111, -122.02457648),
                    .c("855B9B78-E0CB-4F59-B190-C2A1E5892DF1", 37.33019742, -122.02406581),
                    .c("553532A3-9732-4D86-B10F-319F819A3C33", 37.33022435, -122.02354413),
                    .c("C819C65B-37E1-4366-9645-61D19974C8D0", 37.33019527, -122.02294631),
                    .c("EE753A11-19F9-4F68-B9A9-14C10C3D292C", 37.33011274, -122.02226048),
                    .c("D0473B7B-3E6B-4F12-A62D-D211E0BD8275", 37.33007961, -122.0214535),
                    .c("106ADF50-8879-4136-BB12-844C4892BF52", 37.33005805, -122.02100589),
                    .c("D6CE0BFC-6955-4AB4-851D-3AEE2AD8E03B", 37.3299556, -122.02057212),
                    .c("477C7D37-D28B-4108-AFBA-72D5C3FBBFEB", 37.32983646, -122.02014032),
                    .c("873F3B0A-658E-4FA8-AA09-D57E34EB2CD6", 37.3295584, -122.01983681),
                    .c("063F6F77-EDF0-4D9F-BCE8-7DF7FCC1C9D7", 37.32940293, -122.01980518)
                ],
                createdAt: ISO8601DateFormatter().date(from: "2026-03-06T14:03:06Z") ?? Date()
            )

            let route3 = MapRouteDTO(
                id: "10838F11-834C-4C89-839A-AB184A1BF8D8",
                name: "New Route 3",
                startLocation: .init(
                    id: "899FE796-0944-4021-9CB0-16C9044ADF00",
                    latitude: 37.3272494,
                    longitude: -122.01971639
                ),
                endLocation: .init(
                    id: "3443AEA6-4A89-4D5E-B9E9-F8CF76DCA16C",
                    latitude: 37.32466722,
                    longitude: -122.02006159
                ),
                polylineCoordinates: [
                    .c("B126E49B-BA96-4F34-A2B3-BA6D2CCC0DAC", 37.3272494, -122.01971639),
                    .c("5113B1FD-513E-49AE-82EB-43961F626292", 37.32663325, -122.01974468),
                    .c("BE0A131D-3A1D-41B3-BEB2-6D8C9954C3AA", 37.32593689, -122.01973017),
                    .c("CA659612-2804-4DC0-8836-A92B98479F90", 37.32529792, -122.01974245),
                    .c("2EBDD2BC-AAF4-42B2-84CC-753E49D4DE2D", 37.32465842, -122.01972327),
                    .c("36898CBA-9462-47C3-9D25-287D0C04B8BD", 37.32461572, -122.01981276),
                    .c("914A64D0-068E-4398-A95E-F4C45139550A", 37.32463235, -122.01997872),
                    .c("0476425C-EA9B-44F3-BD5E-60B3A0818B18", 37.32466722, -122.02006159)
                ],
                createdAt: ISO8601DateFormatter().date(from: "2026-03-06T14:05:38Z") ?? Date()
            )

            context.insert(route1)
            context.insert(route2)
            context.insert(route3)

            try context.save()
            return container
        } catch {
            fatalError("Preview container failed: \(error)")
        }
    }()
}
