//
//  ContentView.swift
//  tugas
//
//  Created by User12 on 2022/3/21.
//

import SwiftUI

struct ContentView: View {
    
    enum turne {
        case blue
        case yellow
        case Empty
    }
    @State private var number = Array(repeating: turne.Empty, count: 42)
    
    @AppStorage("blue") var blue = 0
    @AppStorage("yellow") var yellow = 0
    @AppStorage("draw") var draw = 0
    @State private var bluePiece = 21
    @State private var yellowPiece = 21
    @State private var turn = "user"
    @State private var finish = false
    @State private var winner = ""
    @State private var connect : [Int] = []
    @State private var pause = false
    
    var body: some View {
        NavigationView{
            GeometryReader {  geometry in
                VStack {
                    HStack{
                        
                        Text("CONNECT 4").padding(.horizontal, 50)
                            .font(.system(size: 30, weight: .heavy, design: .default))
                            .foregroundColor(Color.orange)
                        
                        
                        Spacer()
                        Button {
                            number = Array(repeating: turne.Empty, count: 42)
                            bluePiece = 21
                            yellowPiece = 21
                            turn = "user"
                            finish = false
                            winner = ""
                            connect = []
                            blue = 0
                            yellow = 0
                            draw = 0
                        }
                        
                        label: {
                            Image("reset")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20,height:30)
                                
                            
                        }
                        
                        
                        
                    }
                    
                    .padding(.bottom)
                    
                    HStack {
                        Image("one")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                            
                            .cornerRadius(150)
                        
                        VStack {
                            HStack {
                                Text("Player 1")
                                    .font(.headline)
                                Spacer()
                                Text("Player 2")
                                    .font(.headline)
                            }
                            HStack {
                                Text("")
                                Spacer()
                                Text("VS")
                                Spacer()
                                Text("")
                            }
                        }
                        Image("dua")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                            .cornerRadius(150)
                    }
                    
                    HStack
                    {
                        
                        Spacer()
                        if (turn == "user" && winner == "") {
                            Image("one")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                .cornerRadius(150)
                            Text("Player 1 ")
                                .bold()
                                .font(.largeTitle)
                        }
                        if (turn == "yellow" && winner == "") {
                            Image("dua")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                .cornerRadius(150)
                            Text("Player 2 ")
                                .bold()
                                .font(.largeTitle)
                        }
                        if (winner == "blue") {
                            Image("one")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                .cornerRadius(150)
                            Text("Player 1 Win！")
                                .bold()
                                .font(.largeTitle)
                                .foregroundColor(.red)
                        } else if (winner == "yellow") {
                            Image("dua")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                .cornerRadius(150)
                            Text("Player 2 Win!")
                                .bold()
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                        } else if (yellowPiece == 0){
                            Text("Draw")
                                .font(.largeTitle)
                        }
                        Spacer()
                    }
                    
                    
                    let col = Array(repeating: GridItem(), count:7)
                    LazyVGrid(columns: col) {
                        ForEach(number.indices) { index in
                            switch number[index] {
                            case .Empty:
                                Circle()
                                    .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        if (!finish && turn == "user" && winner != "draw") {
                                            turn = "Blue"
                                            blueTurn(index: index)
                                            bluePiece -= 1
                                            finish = PlayerWin()
                                            if (finish) {
                                                winner = "blue"
                                                blue += 1
                                                bluePiece = 21
                                            }
                                            turn = "yellow"
                                        } else if (!finish && turn == "yellow" && winner != "draw") {
                                            
                                            yellowTurn(index: index)
                                            yellowPiece -= 1
                                            finish = PlayerWin()
                                            if (finish) {
                                                winner = "yellow"
                                                yellow += 1
                                                yellowPiece = 21
                                            } else if (yellowPiece == 0) {
                                                winner = "draw"
                                                draw += 1
                                            } else {
                                                turn = "user"
                                            }
                                        }
                                    }
                            case .blue:
                                if connect.contains(index) {
                                    Image("air")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                        .cornerRadius(150)
                                } else {
                                    Image("one")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                        .cornerRadius(150)
                                }
                            case .yellow:
                                if connect.contains(index) {
                                    Image("air")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                        .cornerRadius(150)
                                } else {
                                    Image("dua")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                        .cornerRadius(150)
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                    }
                    
                    .padding(10)
                    .background(Color.gray)
                    .cornerRadius(15)
                    
                    
                    if (winner != "") {
                        HStack {
                            Spacer()
                            Button {
                                number = Array(repeating: turne.Empty, count: 42)
                                bluePiece = 21
                                yellowPiece = 21
                                turn = "user"
                                finish = false
                                winner = ""
                                connect = []
                            } label: {
                                Text("New Round")
                                    .bold()
                                    .font(.largeTitle)
                            }
                            Spacer()
                        }
                        .padding(7)
                        .background(Color(red: 209/255, green: 231/255, blue: 255/255))
                        .cornerRadius(20)
                        
                    }
                    
                    
                    
                }
                .padding()
                
                
            }
            
            .navigationBarHidden(true)
        }
    }
    
    func blueTurn(index: Int) {
        var cons = index
        while (cons+7 <= 41 && self.number[cons+7] == turne.Empty) {
            cons += 7
        }
        self.number[cons] = turne.blue
    }
    
    func yellowTurn(index: Int) {
        var cons = index
        while (cons+7 <= 41 && self.number[cons+7] == turne.Empty) {
            cons += 7
        }
        self.number[cons] = turne.yellow
    }
    
    func PlayerWin() -> Bool {
        for x in 0...2 {
            for y in 0...3 {
                if (self.number[7*x+y] != .Empty
                        && self.number[7*x+y] == self.number[7*x+y+8]
                        && self.number[7*x+y] == self.number[7*x+y+16]
                        && self.number[7*x+y] == self.number[7*x+y+24]) {
                    connect.append(7*x+y)
                    connect.append(7*x+y+8)
                    connect.append(7*x+y+16)
                    connect.append(7*x+y+24)
                    return true
                }
            }
        }
        for x in 0...2 {
            for y in 0...3 {
                if (self.number[7*x+3+y] != .Empty
                        && self.number[7*x+3+y] == self.number[7*x+3+y+6]
                        && self.number[7*x+3+y+6] == self.number[7*x+3+y+12]
                        && self.number[7*x+3+y+12] == self.number[7*x+3+y+18]) {
                    connect.append(7*x+3+y)
                    connect.append(7*x+3+y+6)
                    connect.append(7*x+3+y+12)
                    connect.append(7*x+3+y+18)
                    return true
                }
            }
        }
        for x in 0...2 {
            for y in 0...6 {
                if (self.number[7*x+y] != .Empty
                        && self.number[7*x+y] == self.number[7*x+y+7]
                        && self.number[7*x+y+7] == self.number[7*x+y+14]
                        && self.number[7*x+y+14] == self.number[7*x+y+21]) {
                    connect.append(7*x+y)
                    connect.append(7*x+y+7)
                    connect.append(7*x+y+14)
                    connect.append(7*x+y+21)
                    return true
                }
            }
        }
        for x in 0...5 {
            for y in 0...3 {
                if (self.number[7*x+y+1] != .Empty
                        && self.number[7*x+y] == self.number[7*x+y+1]
                        && self.number[7*x+y+1] == self.number[7*x+y+2]
                        && self.number[7*x+y+2] == self.number[7*x+y+3]) {
                    connect.append(7*x+y)
                    connect.append(7*x+y+1)
                    connect.append(7*x+y+2)
                    connect.append(7*x+y+3)
                    return true
                }
            }
        }
        return false
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

