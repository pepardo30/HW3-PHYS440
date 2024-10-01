import SwiftUI

// This SwiftUI view is used for Monte Carlo integration.
// It allows users to input parameters like number of points, and lower and upper bounds for integration.
struct ContentView: View {
    // State variables to store user input and results for the Monte Carlo integration
    @State  var nString: String = ""
    @State  var lowerBoundString: String = ""
    @State  var upperBoundString: String = ""
    @State  var integralValueMonteCarlo: Double = 0.0  // Stores the computed integral value
    @State var insideData = [(xPoint: Double, yPoint: Double)]()  // Points that fall inside the area being integrated
    @ObservedObject var montecarlo = monteCarlo()
    
    var body: some View {
        
        
        HStack{
            
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Monte Carlo Integration for e^x")
                
                HStack {
                    Text("Number of Samples:")
                    TextField("Enter a value for n", text: $nString)
                }
                HStack {
                    Text("Lower X Bound:")
                    TextField("Enter a value for the lower x bound", text: $lowerBoundString)
                }
                HStack {
                    Text("Upper X Bound:")
                    TextField("Enter a value for the upper x bound", text: $upperBoundString)
                }
                
                Button("Compute!", action: {self.calculate()})
                
                HStack {Text("Integral Value:")
                    Text("\(self.integralValueMonteCarlo, specifier: "%.7f")")
                }
                
            }
            .padding()
            
            //DrawingField
            
            
            drawingView(redLayer:$montecarlo.insideData, blueLayer: $montecarlo.outsideData)
                .padding()
                .aspectRatio(1, contentMode: .fit)
            // Stop the window shrinking to zero.
            Spacer()
        }
    }
    
    func calculate(){
        
       
        montecarlo.n = Int(nString)!
        montecarlo.lowerBoundX = Double(lowerBoundString)!
        montecarlo.upperBoundX = Double(upperBoundString)!
        
        montecarlo.computeAll()
        integralValueMonteCarlo = montecarlo.integralValue
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
