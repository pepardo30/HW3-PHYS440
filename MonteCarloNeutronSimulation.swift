
import Foundation
import SwiftUI

struct NeutronSimulation {
    let wallWidth = 5.0  // Wall is 5 meters wide
    let wallHeight = 5.0  // Wall is 5 meters high
    let initialHeight = 4.0  // Neutrons hit the wall 4 meters off the floor
    let meanFreePath = 1.0  // Neutrons have a mean free path of 1 meter
    let initialEnergy = 1.0  // Neutrons start with 100% energy
    let absorptionEnergy = 0.0  // Neutron is absorbed when its energy is 0
    let neutronCount = 100_000  // Number of neutrons in the simulation
    
    // Probability distributions for energy loss
    let energyLoss10Percent = 0.9
    let energyLoss15Percent = 0.85
    
    // Function to simulate neutron's random walk
    func simulateNeutrons(energyLossFactor: Double) -> Double {
        var escapedNeutrons = 0
        
        for _ in 0..<neutronCount {
            var x = 0.0  // Neutron starts at the middle of the wall horizontally
            var y = initialHeight  // Neutron starts 4 meters from the floor
            var energy = initialEnergy
            
            while energy > absorptionEnergy {
                // Step in a random direction by a mean free path
                let angle = Double.random(in: 0..<2 * .pi)
                let stepX = meanFreePath * cos(angle)
                let stepY = meanFreePath * sin(angle)
                
                x += stepX
                y += stepY
                
                // Reduce energy after collision
                energy *= energyLossFactor
                
                // Check if neutron escapes the wall
                if x < 0 || x > wallWidth || y < 0 || y > wallHeight {
                    escapedNeutrons += 1
                    break
                }
            }
        }
        
        // Return the percentage of neutrons that escaped
        return (Double(escapedNeutrons) / Double(neutronCount)) * 100
    }
    
    // Function to run simulation with both energy loss factors
    func runSimulations() {
        let result10Percent = simulateNeutrons(energyLossFactor: energyLoss10Percent)
        let result15Percent = simulateNeutrons(energyLossFactor: energyLoss15Percent)
        
        print("Percentage of neutrons that escaped with 10% energy loss: \(result10Percent)%")
        print("Percentage of neutrons that escaped with 15% energy loss: \(result15Percent)%")
    }
}

// SwiftUI View to visualize some neutron paths
struct ContentView: View {
    let simulation = NeutronSimulation()
    @State private var neutronPaths: [[CGPoint]] = []
    
    var body: some View {
        VStack {
            Text("Monte Carlo Neutron Simulation").font(.title)
            
            // Plot neutron paths
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<neutronPaths.count, id: \.self) { pathIndex in
                        Path { path in
                            let points = neutronPaths[pathIndex]
                            if let startPoint = points.first {
                                path.move(to: CGPoint(x: startPoint.x * geometry.size.width / 5, y: startPoint.y * geometry.size.height / 5))
                                
                                for point in points.dropFirst() {
                                    path.addLine(to: CGPoint(x: point.x * geometry.size.width / 5, y: point.y * geometry.size.height / 5))
                                }
                            }
                        }
                        .stroke(Color.blue, lineWidth: 1)
                    }
                }
            }
            .frame(width: 300, height: 300)
            .border(Color.black, width: 1)
            
            Button("Simulate Neutron Paths") {
                neutronPaths = simulatePaths(count: 10)
            }
            .padding()
        }
    }
    
    // Function to simulate a few neutron paths for visualization
    func simulatePaths(count: Int) -> [[CGPoint]] {
        var paths: [[CGPoint]] = []
        
        for _ in 0..<count {
            var path: [CGPoint] = [CGPoint(x: 0, y: 4)]
            var x = 0.0
            var y = 4.0
            var energy = simulation.initialEnergy
            
            while energy > simulation.absorptionEnergy {
                let angle = Double.random(in: 0..<2 * .pi)
                let stepX = simulation.meanFreePath * cos(angle)
                let stepY = simulation.meanFreePath * sin(angle)
                
                x += stepX
                y += stepY
                
                energy *= simulation.energyLoss10Percent
                
                path.append(CGPoint(x: x, y: y))
                
                if x < 0 || x > simulation.wallWidth || y < 0 || y > simulation.wallHeight {
                    break
                }
            }
            
            paths.append(path)
        }
        
        return paths
    }
}

// Run the simulation
let simulation = NeutronSimulation()
simulation.runSimulations()

// SwiftUI preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
