//
//  ContentView.swift
//  snippet-muse
//
//  Created by Claire Xu on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    @State var circleSize: CGFloat = 0.0
    @State var opacityRecord: CGFloat = 1.0
    @State var opacityStop: CGFloat = 0.0
    @State var opacityWave1: CGFloat = 0.0
    @State var opacityWave2: CGFloat = 0.0
    @State var timerWave: Timer?
    @State var seconds = 0
    @State var minutes = 0
    @State var timeString = "00:00"
    @State var timerRecord: Timer?
    @State var recordedAudioFiles: [String] = []
    var body: some View {
        ZStack{
            //start recording
            VStack{
                Spacer()
                
                List(recordedAudioFiles, id: \.self) {file in
                    Text(file)
                }
                .frame(height:200)
                
                ZStack{
                    Circle()
                        .fill(Color.jetBlack)
                        .frame(width: 70, height:70)
                    
                    Image(systemName: "mic.fill")
                        .foregroundColor(Color.white)
                        .font(.system(size: 24))
                    
                    Text("Record a snippet")
                        .offset(y: 60)
                        .font(.system(size: 20, weight: .black))
                }
                .offset(y: -70)
                .opacity(opacityRecord)
                .onTapGesture {
                    onIncreaseCircle()
                }
            }
            .frame(height: UIScreen.main.bounds.height)
            
            ZStack{
                //circle animation
                VStack{
                    Spacer()
                    
                    Circle()
                        .fill(Color.jetBlack)
                        .frame(width: circleSize, height: circleSize)
                        .offset(y: -70)
                }
                
                if circleSize > 0.0 {
                    // main view with stop button
                    VStack{
                        Image(systemName: "mic.fill")
                            .foregroundColor(Color.white)
                            .font(.system(size: 50))
                            .padding(.top, 140)
                        Text(timeString)
                            .padding(.top, 20)
                            .foregroundColor(Color.white)
                            .font(.system(size: 60, weight: .black))
                        
                        Spacer()
                        
                        //stop button with circles
                        ZStack{
                            Circle()
                                .fill(Color.white)
                                .frame(width: 120, height: 120)
                                .opacity(opacityWave1)
                            
                            Circle()
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                                .opacity(opacityWave2)
                                
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "stop.fill")
                                .foregroundColor(Color.jetBlack)
                                .font(.system(size: 24))
                        }
                        .offset(y: -50)
                        .opacity(opacityStop)
                        .onTapGesture{
                            onDecreaseCircle()
                        }
                    }
                    .frame(height:
                            UIScreen.main.bounds.height)
                }
            }
        }
    }
    
    func onIncreaseCircle(){
        Timer.scheduledTimer(withTimeInterval: 0.1,
            repeats: true) { timer in
            
            withAnimation(.spring()){
                opacityRecord -= 0.3
                opacityStop -= 0.3
                circleSize += 250.0
                if circleSize > 1200.0 {
                    opacityRecord = 0.0
                    opacityStop = 1.0
                    timer.invalidate()
                }
            }
        }
        
        timerWave = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { timer in
            withAnimation(.spring()){
                opacityWave1 += 0.04
                opacityWave2 += 0.04
                
                if opacityWave1 >= 0.4 {
                    opacityWave1 = 0.08
                }
                
                if opacityWave2 >= 0.6 {
                    opacityWave2 = 0.08
                }
            }
        })
        
        //increment timer to render on screen
        timerRecord = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            seconds += 1
            
            if seconds == 60 {
                seconds = 0
                minutes += 1
            }
            
            let timeString = String(format: "%02d:%02d", minutes, seconds)
            self.timeString = timeString
        })
    }
    
    func onDecreaseCircle(){
        timerWave?.invalidate()
        timerRecord?.invalidate()
        seconds = 0
        minutes = 0
        Timer.scheduledTimer(withTimeInterval: 0.1,
            repeats: true) { timer in
            
            withAnimation(.spring()){
                circleSize -= 250.0
                opacityRecord += 0.3
                opacityStop += 0.3
                if circleSize <= 0.0 {
                    opacityRecord = 1.0
                    opacityStop = 0.0
                    timeString = "00:00"
                    opacityWave1 = 0.0
                    opacityWave2 = 0.0
                    timer.invalidate()
                }
            }
        }
        recordedAudioFiles.append("Recording_\(minutes)_\(seconds).mp3")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
