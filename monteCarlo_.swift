import SwiftUI
import Foundation

// This class implements Monte Carlo integration.
// It stores the data points that fall inside and outside the region being integrated.
class monteCarlo: ObservableObject {
    
    // Published properties for tracking points inside and outside the integration area
    @Published var insideData = [(xPoint: Double, yPoint: Double)]()  // Points inside the area
    @Published var outsideData = [(xPoint: Double, yPoint: Double)]()  // Points outside the area
    
    var lowerBoundX: Double = 0.0
    var upperBoundX: Double = 0.0
    var lowerBoundY: Double = 0.0
    var upperBoundY: Double = 0.0
    var boundingBoxArea: Double = 0.0
    
    var rangeX: Double = 0.0
    var rangeY: Double = 0.0
    
    var randX: Double = 0.0
    var randY: Double = 0.0
    
    var totalGuesses: Double = 0.0
    var correctGuesses: Double = 0.0
    
    var integralValue: Double = 0.0
    
    func exponential(x: Double)->Double{
        ///This function calculates the exponential of x. Returns a double
        return exp(-x)
    }
    
    func calculateYBounds(){
        ///This function calculates the Y bounds using the exponential function. Takes in lower and upper x bounds to compute the same for y
        lowerBoundY = 0
        upperBoundY = exponential(x: lowerBoundX)
        
        
    }
    
    func calculateRange(){
        ///this function calculates the range in x and in y for the bounding box
        rangeX = upperBoundX - lowerBoundX
        rangeY = upperBoundY - lowerBoundY
    }
    
    func calculateBoundingBoxArea(){
        ///This function calculates the bounding box area for the integral
        self.calculateRange()
        boundingBoxArea = rangeX*rangeY
    }
    
    func randomize(){
        ///This function randomly populates a value for x and y
        randX = Double.random(in: lowerBoundX...upperBoundX)
        randY = Double.random(in: lowerBoundY...upperBoundY)
    }
    
    func boundCheck(){
        ///This function checks for a random point being within the function e^x
        self.randomize()
        
        totalGuesses = totalGuesses+1
        
        let functionValue = exponential(x: randX)
        
        if randY < functionValue {
            print("Within bounds!")
            insideData.append((xPoint: randX, yPoint: randY))
            
            correctGuesses = correctGuesses+1
        } else{
            print("Out of Bounds!")
            outsideData.append((xPoint: randX, yPoint: randY))
            
        }
    }
    
    func calculateIntegral(){
        ///This function calculates the value of the integral based on the ratio of correct to total guesses and the total bounding box area
        self.calculateBoundingBoxArea()
        integralValue = (correctGuesses/totalGuesses)*boundingBoxArea
    }
    
    func computeAll(){
        ///This function computes all of the total and correct guesses in addition to the calculation of the integral
        self.calculateYBounds()
        for _ in 0..<n {
            self.boundCheck()
        }
        self.calculateIntegral()
        
    }
    
    
    
    
    

}
