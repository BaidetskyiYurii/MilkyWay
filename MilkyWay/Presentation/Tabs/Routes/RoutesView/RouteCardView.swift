//
//  RouteCardView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 03.05.2026.
//

import SwiftUI
import MapKit
import SwiftData

struct RouteCardView: View {
    let route: MapRoute
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    // MARK: - Computed Properties
    
    private var formattedDistance: String {
        let km = route.totalDistanceMeters / 1000.0
        return String(format: "%.2f km", km)
    }
    
    private var formattedDuration: String {
        let elapsed = route.endDate.timeIntervalSince(route.startDate)
        let hours = Int(elapsed) / 3600
        let minutes = Int(elapsed) / 60 % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private var formattedDate: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(route.createdAt) {
            return "Today"
        } else if calendar.isDateInYesterday(route.createdAt) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd"
            return formatter.string(from: route.createdAt)
        }
    }
    
    private var locationName: String {
        // Extract city/country from coordinates (simplified)
        // In production, you'd use CLGeocoder for reverse geocoding
        route.name
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Map Preview
            mapPreview
                .frame(height: 180)
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                // Title and Date
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(route.name)
                            .font(Fonts.Poppins.bold.swiftUIFont(size: 18))
                            .foregroundStyle(.mwText)
                            .lineLimit(1)
                        
                        Text("\(locationName) · \(formattedDistance) · \(formattedDuration)")
                            .font(Fonts.Poppins.regular.swiftUIFont(size: 12))
                            .foregroundStyle(.mwMutedText)
                    }
                    
                    Spacer()
                    
                    Text(formattedDate)
                        .font(Fonts.Poppins.medium.swiftUIFont(size: 12))
                        .foregroundStyle(.mwMutedText)
                }
                
                // Stats
                HStack(spacing: 16) {
                    StatBadge(
                        icon: "pin.fill",
                        value: "0",
                        label: "pins",
                        color: .mwCyan
                    )
                    
                    StatBadge(
                        icon: "photo.fill",
                        value: "0",
                        label: "photos",
                        color: .mwLavender
                    )
                }
            }
            .padding(16)
        }
        .background(Color.mwCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.mwBorder.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .onAppear {
            updateCameraPosition()
        }
        .onTapGesture {
            onTap()
        }
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete Route", systemImage: "trash")
            }
        }
    }
}

// MARK: - Private Views
private extension RouteCardView {
    var mapPreview: some View {
        Map(position: $cameraPosition) {
            // Draw the route polyline with gradient effect
            MapPolyline(coordinates: route.polylineCoordinates.map { $0.toLocationCoordinate() })
                .stroke(
                    .purple.opacity(0.3),
                    style: StrokeStyle(
                        lineWidth: 14,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            
            MapPolyline(coordinates: route.polylineCoordinates.map { $0.toLocationCoordinate() })
                .stroke(
                    LinearGradient(
                        colors: [.mwDeepPurple, .mwLavender, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            
            // Start marker
            Annotation("", coordinate: route.startLocation.toLocationCoordinate()) {
                Circle()
                    .fill(.green)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 2)
                    )
            }
            
            // End marker
            Annotation("", coordinate: route.endLocation.toLocationCoordinate()) {
                Circle()
                    .fill(.red)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 2)
                    )
            }
        }
        .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll))
        .mapControlVisibility(.hidden)
        .preferredColorScheme(.dark)
        .disabled(true)
        .allowsHitTesting(false)
        .overlay(
            // Gradient overlay for "MilkyWay" watermark area (top)
            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.6), location: 0),
                    .init(color: .black.opacity(0.3), location: 0.3),
                    .init(color: .clear, location: 0.6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(alignment: .topLeading) {
            // MilkyWay watermark
            HStack(spacing: 6) {
                Image(systemName: "location.north.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.mwLavender)
                
                Text("MilkyWay")
                    .font(Fonts.Poppins.semiBold.swiftUIFont(size: 12))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.mwDeepPurple, .mwLavender],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .overlay(alignment: .topTrailing) {
            // Info button
            Button {
                onTap()
            } label: {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(12)
            }
        }
    }
}

// MARK: - Helper Methods
private extension RouteCardView {
    func updateCameraPosition() {
        let coordinates = route.polylineCoordinates.map { $0.toLocationCoordinate() }
        guard let mapRect = MKMapRect.fitting(coordinates, paddingMeters: 100) else { return }
        cameraPosition = .rect(mapRect)
    }
}

// MARK: - Supporting Views
struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(color)
            
            Text(value)
                .font(Fonts.Poppins.semiBold.swiftUIFont(size: 13))
                .foregroundStyle(color)
            
            Text(label)
                .font(Fonts.Poppins.regular.swiftUIFont(size: 11))
                .foregroundStyle(.mwMutedText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    let previewContainer = MapRouteDTO.preview
    
    // Get a sample route from preview container
    let context = previewContainer.mainContext
    let routes = try? context.fetch(FetchDescriptor<MapRouteDTO>())
    
    if let firstRoute = routes?.first {
        ScrollView {
            VStack(spacing: 20) {
                RouteCardView(
                    route: MapRoute(from: firstRoute),
                    onTap: {
                        print("Route tapped")
                    },
                    onDelete: {
                        print("Delete tapped")
                    }
                )
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        .background(Color.mwBackground)
        .modelContainer(previewContainer)
    } else {
        Text("No preview data available")
            .foregroundStyle(.white)
            .background(Color.mwBackground)
    }
}
