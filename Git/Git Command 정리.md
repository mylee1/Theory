# Git Command 이론 정리 

1. Cherry-Pick
2. Head
3. Revert
   
## Cherry-Pick
- 한 브랜치의 특정 커밋을 다른 브랜치의 최신 커밋으로 추가
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
    > -e 옵션을 사용하면 commit message 수정 가능
     ```
     git cherry-pick -e <commit ID>
     ```
  5. 브랜치에 commit 내용 반영 
     ```
     git push
     ```

- Cherry-pick
     
      
