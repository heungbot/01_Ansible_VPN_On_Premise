# 01 Ansible Playbook to On Premise Servers by using S2S VPN

## [ 프로젝트 설명 ]
프로젝트 명 : S2S VPN을 이용한 On premise Ansbile 구성

프로젝트 인원 : 1명

프로젝트 기간 : 2023.07 ~ 2023.07

프로젝트 소개 : 이 프로젝트는 일부 물리 서버를 임대하여 운영 중인 상황에서 원격 접속이 불가능한 문제를 해결하기 위한 목적으로 시작되었습니다. 이를 위해 적절한 AWS 서비스를 활용하고 Terraform을 이용하여 인프라를 구축하고 관리하는 것이 목표입니다.

## [ 클라이언트 상황 ]

* IDC 중 일부를 임대하여 사용하기에 회사와 먼 거리에 위치
* 6대의 이상의 자사 물리서버 사용중
* 격주로 패치 및 구성관리와 특정 script를 실행하며, 이벤트가 생겼을 때 마다 관리자가 idc에 방문하는 방식
* 추 후 발생할 다양한 이벤트로 인해 기존에 운영중인 AWS와 IDC를 연동하기로 결정

## [ 요구사항 ]
* 암호화된 원격 연결을 통한 네트워크 보안 확보
* 반복 작업의 지양
* 물리 서버와의 통신을 계속 연결해둘 필요 없음 on / off 방식 요망
* 다른 서비스와 격리된 환경에 셋업
* 회사 내부 관계자만 접속 가능하도록 보안조치 요망

## [ 구축 상황 ]
* 실제 On premise 서버가 존재하지 않으므로, 가상의 on_premise server 들을 AWS Cloud 내에서 다른 Region(ap-northeast-1)으로 구축

## [ 다이어 그램 ]
<img width="1339" alt="ansible_diagram_real" src="https://github.com/heungbot/01_s2sVpn_Ansible/assets/97264115/1c24c38e-cb04-4392-872d-f00e74b30a94">

### [ 핵심 서비스 ]


