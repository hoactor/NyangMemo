# NyangMemo

픽셀아트 고양이가 창 안을 자유롭게 돌아다니는 SwiftUI 데스크탑/모바일 앱.
("냥" = 고양이 울음소리. Phase 1-1: 걷기·앉기·자기 상태)

## Stack
- Swift 5.0 + SwiftUI (UIKit/AppKit 없음)
- iOS 26.2 / macOS 26.2 / visionOS 26.2 (Xcode 26.3)
- 외부 의존성 없음 (SPM/CocoaPods 미사용)
- Bundle ID: `com.ho.UncleHoya.NyangMemo`

## Layout
- `NyangMemo/NyangMemoApp.swift` — `@main`, WindowGroup 루트
- `NyangMemo/ContentView.swift` — 메인 뷰. PixelCatView 스프라이트, Timer 기반 위치/상태 갱신
- `NyangMemo/Assets.xcassets/` — 이미지 리소스
- `NyangMemoTests/` — 단위 테스트 (스텁만 있음)
- `NyangMemoUITests/` — 런치 테스트만 있음

## Data
영속 저장소 없음. 고양이 위치·프레임·상태는 모두 `@State`로만 관리. 메모 기능을 추가하려면 SwiftData나 UserDefaults를 새로 도입해야 함.

## Build & Run
- Open: `open NyangMemo.xcodeproj`
- Run: Xcode에서 ⌘R
- Test: `xcodebuild test -project NyangMemo.xcodeproj -scheme NyangMemo -destination 'platform=iOS Simulator,name=iPhone 16'`

## Conventions
- 코멘트는 의도가 명확하지 않을 때만. 변수명이 충분하면 생략.
- 한 파일 안에 보조 View 구조체를 같이 두는 패턴 사용 중 (ContentView.swift 안의 PixelCatView 참고).
