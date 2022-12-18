# pytorch-hub-docker


1. Dockerhub 이용
##### linux/ARM64 (ex: Mac M1, M2)
```
docker pull cpprhtn/hub-kr

docker run -i -t -p 50001:50001/tcp --name hub-kr cpprhtn/hub-kr
```

##### linux/AMD64 (ex: Window)
```
docker pull cpprhtn/hub-kr:window

docker run -i -t -p 50001:50001/tcp --name hub-kr cpprhtn/hub-kr
```

2. 해당 레포의 Dockerfile 이용 (ARM/AMD 공용)
```
docker build -t <name>:<version> .

ex): docker build -t cpprhtn/hub-kr:latest .

docker run -i -t -p 50001:50001/tcp --name hub-kr cpprhtn/hub-kr
```
--- 
### 안내사항
- 50001:50001/tcp로 run 하는걸 권장드립니다. (포트 충돌 방지)
- 아직 테스트 단계라서 제 개인 레포를 클론해와서 빌드하게 되므로, [PyTorchKorea/hub-kr](https://github.com/PyTorchKorea/hub-kr) 의 최신 업데이트 내용이 반영되어있지 않을 수 있습니다.
- 돌아만 가는데 초점을 맞춘(?) 짜파게티 코드입니다. 더 좋은 코드가 있다면 PR 부탁드립니다.
- 이슈는 언제든 환영입니다.

컨테이너의 로그에서 아래와 같은 로그가 뜬다면 빌드가 성공된것입니다.
```
...
생략
...
Auto-regeneration: enabled for '/hub-kr/_preview'
Server address: http://0.0.0.0:50001/
Server running... press ctrl-c to stop.
```

빌드 확인은 localhost:50001 혹은 0.0.0.0:50001로 접속해보시면 됩니다.
감사합니다.

### TODO
- [ ] 로컬 볼륨에 hub의 *.md 연동
- [ ] window 버전 Dockerfile 제작

