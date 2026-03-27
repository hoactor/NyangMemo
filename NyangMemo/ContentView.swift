//
//  ContentView.swift
//  NyangMemo
//
//  Phase 1-1: 도트 고양이가 창 안에서 걸어다니기
//

import SwiftUI
import Combine  
// MARK: - 도트 고양이 스프라이트 (SwiftUI로 그린 픽셀아트)
struct PixelCatView: View {
    let frame: Int  // 0 = 걷기1, 1 = 걷기2
    let facingRight: Bool
    
    // 8x8 픽셀 고양이 스프라이트
    // 0 = 투명, 1 = 검정(외곽), 2 = 회색(몸), 3 = 분홍(귀/코), 4 = 흰색(눈)
    var spriteData: [[Int]] {
        if frame == 0 {
            // 걷기 프레임 1
            return [
                [0,0,1,0,0,1,0,0],
                [0,1,3,1,1,3,1,0],
                [0,1,2,2,2,2,1,0],
                [1,2,4,2,2,4,2,1],
                [1,2,2,3,2,2,2,1],
                [0,1,2,2,2,2,1,0],
                [0,0,1,0,0,1,0,0],
                [0,0,1,0,0,0,1,0],
            ]
        } else {
            // 걷기 프레임 2
            return [
                [0,0,1,0,0,1,0,0],
                [0,1,3,1,1,3,1,0],
                [0,1,2,2,2,2,1,0],
                [1,2,4,2,2,4,2,1],
                [1,2,2,3,2,2,2,1],
                [0,1,2,2,2,2,1,0],
                [0,0,1,0,0,1,0,0],
                [0,1,0,0,0,1,0,0],
            ]
        }
    }
    
    func colorFor(_ value: Int) -> Color {
        switch value {
        case 1: return .black
        case 2: return Color(red: 0.6, green: 0.6, blue: 0.6)
        case 3: return Color(red: 1.0, green: 0.5, blue: 0.6)
        case 4: return .white
        default: return .clear
        }
    }
    
    var body: some View {
        let data = spriteData
        VStack(spacing: 0) {
            ForEach(0..<data.count, id: \.self) { row in
                HStack(spacing: 0) {
                    let rowData = facingRight ? data[row] : data[row].reversed()
                    ForEach(0..<rowData.count, id: \.self) { col in
                        Rectangle()
                            .fill(colorFor(rowData[col]))
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
    }
}

// MARK: - 고양이 행동 상태
enum CatState: String {
    case walking
    case sitting
    case sleeping
}

// MARK: - 메인 뷰
struct ContentView: View {
    @State private var catX: CGFloat = 200
    @State private var catY: CGFloat = 200
    @State private var frame: Int = 0
    @State private var facingRight: Bool = true
    @State private var catState: CatState = .walking
    @State private var stateTimer: Int = 0
    
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 배경 (나중에 투명으로 바꿀 예정)
                Color(red: 0.15, green: 0.15, blue: 0.2)
                
                // 고양이
                VStack(spacing: 2) {
                    PixelCatView(frame: frame, facingRight: facingRight)
                    
                    // 상태 표시 (디버그용, 나중에 제거)
                    Text(catState.rawValue)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.white.opacity(0.5))
                }
                .position(x: catX, y: catY)
            }
            .onReceive(timer) { _ in
                updateCat(in: geo.size)
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
    
    func updateCat(in size: CGSize) {
        stateTimer += 1
        
        // 상태 전환 (랜덤)
        if catState == .walking && stateTimer > 15 {
            let rand = Int.random(in: 0...2)
            if rand == 0 { catState = .sitting; stateTimer = 0 }
            else if rand == 1 { catState = .sleeping; stateTimer = 0 }
        } else if catState == .sitting && stateTimer > 10 {
            catState = .walking; stateTimer = 0
            facingRight = Bool.random()
        } else if catState == .sleeping && stateTimer > 20 {
            catState = .walking; stateTimer = 0
            facingRight = Bool.random()
        }
        
        // 걷기 애니메이션
        if catState == .walking {
            frame = (frame + 1) % 2
            let speed: CGFloat = 8
            catX += facingRight ? speed : -speed
            
            // 벽에 닿으면 방향 전환
            if catX > size.width - 30 { facingRight = false }
            if catX < 30 { facingRight = true }
        }
    }
}

#Preview {
    ContentView()
}
