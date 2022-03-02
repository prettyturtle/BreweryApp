# 브루어리🍺

## (PunkAPI를 이용한 맥주리스트 앱)

- UIKit(Storyboard X)
- SnapKit
- Kingfisher

### 기능🍗

- PunkAPI를 사용하여 맥주리스트를 만든다
    - `UITableView`에서 커스텀 셀을 만들어 나타낸다
    - 커스텀 셀을 만들어 맥주의 간단한 정보를 표시한다
    - 무한 스크롤 구현
- 맥주 리스트에서 셀을 선택했을 때, 상세 정보를 표시하는 ViewController를 push한다
    - 상세정보 VC는 스크롤뷰로 구성되어있다
- 즐겨찾기 기능
    - 상세정보 VC에서 별 버튼을 누르면 `UserDefaults`에 저장, 삭제 기능
    - `LikedViewController`에 `UserDefaults`에 저장된 맥주 리스트를 테이블 뷰로 표시한다
    - `LikedViewController`에서도 셀을 선택하면 상세정보 VC로 넘어가는데, `MainVC`에서 갈때와 `LikedVC`에서 갈때의 backButton의 title을 다르게 구분했다
    - `LikedViewController`에서 밀어서 삭제 기능 추가
    - `UserDefaults`에 저장할 때, 맥주 정보의 id값을 이용하여 이미 저장되어 있다면 저장하지 않도록 설정
### FetchData🧀
- URLSession
