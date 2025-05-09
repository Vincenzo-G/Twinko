//
//  ContentView.swift
//  SettingCamera
//
//  Created by Adrian Emmanuel Faz Mercado on 26/04/25.
//
import SwiftUI

struct TreasureHuntView: View {
    @State private var viewModel = ViewModel()
    @State private var selectedItem: String? = nil
    @State private var showSheet: Bool = false
    @State private var detectedObjectSnapshot: String = ""
    @State private var unlockedItems: Set<String> = []


    
    var body: some View {
        ZStack {
            CameraView(image: $viewModel.currentFrame)
            
            PazzescoView(selectedItem: $selectedItem, unlockedItems: unlockedItems)

            
            
            if let selected = selectedItem {
                VStack {
                    Image(selected)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 310)
                        .transition(.scale.combined(with: .opacity))
                    
                }.onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            selectedItem = nil
                        }
                    }
                }
            }


            
            VStack {
     
                Image("ScannerImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 700)
                    .shadow(color: viewModel.detectedObject != "Niente" ? .yellow : .clear, radius: 40)
            }
            
            VStack {
                
                Spacer()
                    
                    Text(viewModel.detectedObject)
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
            
                
            
            }
            .padding()
            
  
                HStack {
                    Spacer()
                    Button {
                        if viewModel.detectedObject != "Niente" {
                            detectedObjectSnapshot = viewModel.detectedObject
                            unlockedItems.insert(viewModel.detectedObject.lowercased()) // Aquí se desbloquea
                            showSheet = true
                        }
                    } label: {
                        Circle()
                            .fill(.thinMaterial)
                            .frame(width: 100)
                            .padding(25)
                    }

                }
            
        }.ignoresSafeArea()
            .sheet(isPresented: $showSheet) {
                DetectedObjectSheet(objectName: detectedObjectSnapshot)
            }
    }
}

#Preview {
    TreasureHuntView()
}


struct PazzescoView: View {
    @Binding var selectedItem: String?
    
    let unlockedItems: Set<String>
    
    let items = ["computer", "chiavi", "portafoglio", "telefono"]
    
    var body: some View {
        HStack {
            VStack(spacing: 40) {
                ForEach(items, id: \.self) { item in
                    VStack {
                        Image(item)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .grayscale(unlockedItems.contains(item) ? 0 : 1)
                    }
                    .frame(width: 120, height: 150)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.thinMaterial))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedItem = item
                        }
                    }
                }
            }
            Spacer()
            
                
        }
        .padding(20)
    }
}


struct DetectedObjectSheet: View {
    let objectName: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text(objectName)
                .font(.largeTitle)
                .bold()
            
            Image(objectName.lowercased())
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
        }
        .padding()
    }
}
