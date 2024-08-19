# <img src="https://github.com/user-attachments/assets/0ea40838-544e-4b9d-adae-758f55cfdb59" width="30 " height="30"> foodrecipe

> 다양한 레시피를 볼수 있는 요리 레시피앱

# 1. 제작 기간 & 참여 인원
>2024년 3월 18일 ~ 4월 19일 

https://docs.google.com/spreadsheets/d/1Klw1bTAdNekeQrHrI_WV_RqojBdDRfDbB1bS4VaWTvQ/edit?gid=0#gid=0

2인 프로젝트

# 2. 기획

>https://docs.google.com/presentation/d/1ypKymklILqL414_SFx0hEfemjloG039Qwfm1jsHOtk8/edit#slide=id.p

# 3. 사용 기술

>Back-end

firebase

>Front-end

flutter


# 4.프로젝트 목표

>1.git hub 사용하여 check out , merge 를 이용하여 프로젝트 작업
>2.대량화된 데이터를 json파일화 시켜서 코드 단순화시키기
>3.코드 아키텍쳐 이해 , 코드 MVVM화 준수 
>4.상태관리에 대하여 provider제대로 사용하기  


# 5. 핵심 기능
>1.다양한 카테고리별 요리 레시피와 즐겨찾기 기능 , 재료 장바구니 기능 

# 6. 핵심 트러블 슈팅

>1.로그인을 했을 시 즐겨찾기,장바구니 목록을 불러오고 페이지 이동시 화면이 깜빡거리는 문제를 FutureBuilder와 provider을 사용하여 해결

>2.즐겨찾기 목록 추가,삭제 시 화면에 즉시 랜더링이 안되는 문제를 provider를 사용하여 해결

>3.음식 즐겨찾기 했을때 즐겨찾기한 순서대로 목록이 추가되는것이 아닌 음식카테고리별로 즐겨찾기가 되는 문제를 즐겨찾기 목록에 음식이 추가된 시간을 추적하고, 그 시간을 기준으로 목록을 정렬하는 기능을 구현 


>4.팀 프로젝트에서 개발자가 동시에 작업을 진행하면서, 서로 다른 브랜치에서 코드를 수정하는 도중 기능 개발을 완료한 후 브랜치를 메인 브랜치(main)에 병합(merge)하려고 했지만, GitHub에서 충돌이 발생하여 병합이 중단 되었음 
Merge 충돌은 주로 두 명 이상의 개발자가 동일한 파일의 같은 부분을 수정했을 때 발생하는데 이 과정에서 branch와 merge에 대한 충분한 이해가 필요했는데 문제 해결 및 개선 방법으로는 Branch와 Merge의 원리 이해 먼저 Git에서의 브랜치와 병합의 원리를 정확히 이해해서 순서대로 push&merge를 하여 문제를 해결하였음

>5.코드의 MVVM 
프로젝트 초기에, 코드가 명확한 구조 없이 개발되어 UI 로직(View), 비즈니스 로직(Model), 그리고 데이터 관리가 하나의 파일이나 클래스에 혼재되어 있었음. 
이 문제를 해결하기 위해 MVVM(Model-View-ViewModel) 패턴을 도입하여 코드를 구조화했음 MVVM 패턴을 적용한 후, 코드의 구조가 명확해지고, 유지보수와 기능 추가가 용이해졌습니다. 또한, ViewModel을 통한 데이터 바인딩 덕분에 UI와 데이터 로직이 자연스럽게 분리되었음

# 6. 그 외 트러블 슈팅
>1.AppBar의 애니메이션효과를 적용시키는 부분에서 문제가 발생하여 SliverAppBar를 사용해서 문제 해결
>2.홈화면에 나오는 음식 사진의 크기가 일정하지 않아서 화면 랜더링 문제 해결
>3.검색기능 데이터 중복 문제 해결 
>4.로그인 할 때 유저의 이름을 가져오는 부분에서 카카오 이름을 제대로 가져오지못하는 문제 해결 

