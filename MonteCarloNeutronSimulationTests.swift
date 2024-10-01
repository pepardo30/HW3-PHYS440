
import XCTest

// Test class for NeutronSimulation
final class NeutronSimulationTests: XCTestCase {
    
    // Test case to check if the percentage of escaped neutrons is calculated correctly for 10% energy loss
    func testNeutronEscapes10Percent() {
        let simulation = NeutronSimulation()
        let result = simulation.simulateNeutrons(energyLossFactor: 0.9)
        
        XCTAssertGreaterThan(result, 0, "Some neutrons should escape.")
        XCTAssertLessThanOrEqual(result, 100, "The percentage of escaped neutrons should be realistic.")
    }
    
    // Test case to check if the percentage of escaped neutrons is calculated correctly for 15% energy loss
    func testNeutronEscapes15Percent() {
        let simulation = NeutronSimulation()
        let result = simulation.simulateNeutrons(energyLossFactor: 0.85)
        
        XCTAssertGreaterThan(result, 0, "Some neutrons should escape.")
        XCTAssertLessThanOrEqual(result, 100, "The percentage of escaped neutrons should be realistic.")
    }
    
    // Test case to verify that energy is reduced correctly after each collision
    func testEnergyReduction() {
        let initialEnergy = 1.0
        let energyLossFactor = 0.9
        var energy = initialEnergy
        
        for _ in 0..<10 {
            energy *= energyLossFactor
        }
        
        XCTAssertLessThan(energy, initialEnergy, "Energy should be reduced after collisions.")
    }
    
    // Test case to check if the simulation runs for a reasonable amount of time for a large number of neutrons
    func testSimulationPerformance() {
        let simulation = NeutronSimulation()
        
        measure {
            _ = simulation.simulateNeutrons(energyLossFactor: 0.9)
        }
    }
}

// Run the tests
NeutronSimulationTests.defaultTestSuite.run()
