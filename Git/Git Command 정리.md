# Git Command 이론 정리 

1. Cherry-Pick
2. Head
3. Reset, Revert
   
## Cherry-Pick
- 한 브랜치의 특정 커밋만 다른 브랜치의 최신 커밋으로 추가
#### [Merge와 Cherry-pick의 차이점]
<left><img src="https://github.com/mylee1/Theory/assets/58197075/d7ed9cf9-5e2c-4de9-b0bf-cd69648a0c87"  width="450" height="380"/></left>
<right><img src="https://github.com/mylee1/Theory/assets/58197075/a5b79851-8ca8-4c39-8586-94f4a68de4d2"  width="450" height="380"/></right>

- git command
   ```
   git cherry-pick <commit ID>
   ```

- Cherry-pick 사용법
  1. 현재 사용중인 브랜치에 커밋 푸시 및 commit ID 복사
     ```
     git add .
     git commit -m "test"
     git push
     git log -> commit ID 확인 및 복사  
     ```
  2. cherry-pick을 적용할 대상 브랜치로 checkout
     ```
     git checkout <대상브랜치>
     ```
  3. Cherry-pick command로 commit 추가
     ```
     git cherry-pick -e <commit ID>
     ```
     > -e 옵션을 사용하면 commit message 수정 가능
  4. 브랜치에 commit 내용 반영 
     ```
     git push
     ```

- Cherry-pick Conflict 해결
   - Cherry-pick 중단
     ```
     git cherry-pick --abort 
     ```
   - 충돌난 파일 수정 후 실행
     ```
     git add .
     git cherry-pick --continue
     git push 
     ```


     
## HEAD 
- HEAD는 현재 체크아웃된 브랜치의 가장 최근 커밋, 특정 브랜치의 마지막 커밋에 대한 포인터
- HEAD가 분리되는 과정   
   1. 3번의 commit을 진행한 상태의 master 브랜치   
     <left><img src="https://github.com/mylee1/Theory/assets/58197075/865bfc33-331e-4428-9cc7-e4c3d544622a"  width="450" height="350"/></left>  
        #### [HEAD는 master 브랜치의 세번째 commit에 있음]
      
   2. 새로운 highlevel 브랜치 생성  
     <left><img src="https://github.com/mylee1/Theory/assets/58197075/c2c56bcb-bd05-49b2-9a4c-44da5addfdff"  width="450" height="350"/></left>  
        #### [matser브랜치의 HEAD가 가리키던 커밋에서 생성]

   3. 새로 생성된 highlevel 브랜치로 Checkout  
     <left><img src="https://github.com/mylee1/Theory/assets/58197075/15c32ffa-7e4d-46fc-a18a-7cdf24973182"  width="450" height="350"/></left>  
        #### [HEAD가 highlevel브랜치의 가장 최신 커밋으로 이동]

   4. highlevel 브랜치의 새로운 commit 생성  
     <left><img src="https://github.com/mylee1/Theory/assets/58197075/1cd7d17c-716b-4108-b4c9-00d39acdadaf"  width="600" height="350"/></left>  
        #### [HEAD가 highlevel브랜치의 가장 최신 커밋으로 이동]

   5. master 브랜치로 Checkout  
     <left><img src="https://github.com/mylee1/Theory/assets/58197075/e16b1bf2-4814-4ecf-aa14-23de3b9f5c9b"  width="600" height="350"/></left>  
        #### [HEAD가 master 브랜치의 가장 최신 커밋으로 이동]

   6. master 브랜치의 새로운 commit 생성  
     <left><img src="https://github.com/mylee1/Theory/assets/58197075/e16b1bf2-4814-4ecf-aa14-23de3b9f5c9b"  width="600" height="350"/></left>  
        #### [코드의 흐름이 분리, `분기하다`]

   7. master 브랜치에 highlevel 브랜치 merge  
     <left><img src="https://github.com/mylee1/Theory/assets/58197075/8e1b2578-8145-425a-9c2f-05ff2536c530"  width="600" height="350"/></left>  
        #### [highlevel에서 작업한 commit이 master에 새로운 commit으로 추가, HEAD는 master 브랜치의 가장 최근 commit에 있음]




## Reset, Revert
- Reset  
   - 현재보다 이전의 특정 commit으로 되돌리는 것, HEAD까지 체크아웃된 브랜치의 특정 commit으로 이동하며 삭제된 commit의 log 또한 사라짐
   - 동작 과정  
      1. 현재 Commit 상태  
         <left><img src="https://github.com/mylee1/Theory/assets/58197075/277ad48f-24ac-447f-89e6-9399af3e5f5b"  width="800" height="250"/></left>    
      2. Commit B 까지 Commit reset (Commit log 까지 삭제)
         <left><img src="https://github.com/mylee1/Theory/assets/58197075/23bfa292-59b9-40f9-b2a0-52bcb98e3ecb"  width="700" height="250"/></left>
      - git command
         ```
         git reset --hard a0fvf8

         // commit된 파일들을 staging area로 돌려놓음 (commit 하기 전 상태, git status로 수정된 파일 확인 가능)
         git reset --soft [commit ID]
         // commit된 파일들을 working directory로 돌려놓음 (add 하기 전 상태, git status로 수정된 파일 확인 가능)
         git reset --mixed [commit ID]
         // commit된 파일들 중 tracked 파일들을 완전 삭제 (수정된 파일 확인 불가능, 단 Untracked 파일은 여전히 Untracked로 남음)
         git reset --hard [commit ID] 
         ```
- Revert
   - 현재보다 이전의 특정 commit만을 되돌리는 것, 그리고 특정 commit이 되돌려진 것은 새로운 commmit으로 생성되며 HEAD는 체크아웃된 브랜치의 가장 최근 commit을 가리킴    
   - 동작 과정  
      1. 현재 Commit 상태  
         <left><img src="https://github.com/mylee1/Theory/assets/58197075/cfa7efab-4977-428e-b5c3-e455d7af1389"  width="750" height="250"/></left>  
      2. Commit D와 C를 Revert 하여 Commit B로 되돌아감  
         <left><img src="https://github.com/mylee1/Theory/assets/58197075/5ca7dce4-d4a4-4a31-9315-1a0778730966"  width="800" height="250"/></left>  
         #### [Revert된 순서대로 D', C' Commit이 생성되고 HEAD는 가장 최근 Commit을 가리킴]  
     - git command  
        ```
        git revert 5lk4er // D 커밋 revert
        git revert 76sdeb // C 커밋 revert

        git revert [commit ID] 
        ```
