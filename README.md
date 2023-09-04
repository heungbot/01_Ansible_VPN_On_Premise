# Ansible Playbook to On Premise Servers by using S2S VPN

***

## 📃 목차
[01. 프로젝트 설명 ](#-01-프로젝트-설명-)

[02. 클라이언트 상황 가정 ](#-02-클라이언트-상황-가정-)

[03. 요구사항 정의 ](#-03-요구사항-정의-)

[04. 다이어그램 ](#-04-다이어그램-)

[05. 구축 환경 ](#-05-구축-환경-)

[06. 핵심 서비스 소개 ](#-06-핵심-서비스-소개-)

[07. 구현 과정 ](#-07-구현-과정-)

[08. Ansible Playbook 실행 및 결과 ](#-08-ansible-playbook-실행-및-결과)

***

## [ 01 프로젝트 설명 ]
프로젝트 명 : S2S VPN을 이용한 On premise Ansbile 구성

프로젝트 인원 : 1명

프로젝트 기간 : 2023.07 ~ 2023.07

프로젝트 소개 : 이 프로젝트는 일부 물리 서버를 임대하여 운영 중인 상황에서 원격 접속이 불가능한 문제를 해결하기 위한 목적으로 시작되었습니다. 이를 위해 적절한 AWS 서비스를 활용하고 Terraform을 이용하여 인프라를 구축하고 관리하는 것이 목표입니다.

***

## [ 02 클라이언트 상황 가정 ]

* IDC 중 일부를 임대하여 사용하기에 회사와 먼 거리에 위치

* 6대의 이상의 자사 물리서버 사용중

* 격주로 패치 및 구성관리와 특정 script를 실행하며, 이벤트가 생겼을 때 마다 관리자가 idc에 방문하는 방식

* 추 후 발생할 다양한 이벤트로 인해 기존에 운영중인 AWS와 IDC를 연동하기로 결정

***

## [ 03 요구사항 정의 ]
* 암호화된 원격 연결을 통한 네트워크 보안 확보

* 반복 작업의 지양

* 물리 서버와의 통신을 계속 연결해둘 필요 없음 on / off 방식 요망

* 회사 내부 관계자만 접속 가능하도록 보안조치 요망

***

## [ 04 다이어그램 ]

<img width="1272" alt="스크린샷 2023-08-14 오후 7 36 55" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/290835fc-4edf-4e21-ad0a-6ff208ff28ec">

***

## [ 05 구축 환경 ]
* 실제 On premise 서버가 존재하지 않으므로, 가상의 IDC를 AWS Cloud 내에서 다른 Region(ap-northeast-1)으로 구축

* 실제 구현 다이어 그램
  
<img width="1361" alt="스크린샷 2023-08-14 오후 7 35 41" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/628b0d69-e055-48de-b68c-f88d343a5247">

***

## [ 06 핵심 서비스 소개 ]


### 06-1 Site To Site VPN 

<img width="627" alt="스크린샷 2023-08-14 오후 7 15 23" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/bc46560d-1a81-4ef7-9576-cac9e79748f4">

- 두 개의 network domain이 가상의 사설 네트워크 연결을 사용하여 private 통신을 가능케 하는 AWS Managed Service.
- IPSec 기반으로 데이터 암호화
- VPC에 부착할 Virtual Private Gateway 또는 Transit Gateway와 On Premise에 연결할 Customer Gateway 사이에 두개의 VPN 터널을 생성함
- 10초 동안 트래픽이 오가지 않을 경우 터널은 down됨.
- BGP Routing Protocol을 사용하여 Network 경로를 자동으로 탐색할 수 있는 Dynamic Routing과 관리자가 직접 Network 경로를 설정하는 Static Routing이 존재함.

### 06-2 Ansible Server

<img width="595" alt="스크린샷 2023-08-14 오후 7 42 06" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/bf40b526-ab36-406e-a12d-2948a7d3c9b6">

- 오픈 소스로서, 여러 개의 서버를 효율적으로 관리하기 위한 환경 구성 자동화 툴
- 자동화 대상에 연결 후, 명령을 실행하는 프로그램을 푸시하는 방식으로 작동. 이 프로그램은 SSH를 기반으로 실행되는 Ansible Module을 활용
- 자동화 task는 Playbook이라 불리는 청사진을 통해 정의됨. 이는 각 작업의 목록과 단계를 기술하며 서버의 상태를 원하는 대로 변경 및 관리 가능 
- 자동화 대상의 목록 또는 그룹을 지정한 inventory 파일을 통해 서버 식별 가능
- 동일 playbook을 몇 번이고 실행해도 같은 결과값을 얻을 수 있는 "멱등성"의 성질을 가지고 있음

***

## [ 07 구현 과정 ]

### 07-1 VGW 생성
<img width="582" alt="스크린샷 2023-08-26 오전 10 21 52" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/e479b42d-5944-452c-b570-f7ee52979c71">

-> VGW 생성 완료 후 VPC에 연결.


<img width="689" alt="스크린샷 2023-08-26 오전 11 01 24" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/065122c8-9eef-4b6c-9584-a886647b7620">


-> VPC의 라우팅 테이블에서 라우팅 전파 활성화


<img width="482" alt="스크린샷 2023-08-26 오전 10 58 14" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/75a7a39f-18d2-468a-8f59-b0ea3fa50681">



### 07-2 CGW 생성
<img width="580" alt="스크린샷 2023-08-26 오전 10 22 12" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/1dd80b8e-7b9f-4981-a571-c7545889387e">

* IP주소에는 VPN 구성을할 IDC의 Public IP를 구성

### 07-3 VPN Connection 생성
<img width="378" alt="스크린샷 2023-08-26 오전 10 22 58" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/9c28a4a5-b377-46eb-a233-e65fff876c4e">

* 위에서 생성한 VGW, CGW를 이용하여 VPN Connection 생성
* IP Prefix에는 통신하고자 하는 IDC의 Private CIDR을 입력

### 07-4 Tunnel State 확인
<img width="974" alt="스크린샷 2023-08-26 오전 10 24 16" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/58ef6846-a35e-4463-abc5-1eab20fc58d4">

* 아직 IDC측의 VPN 구성이 모두 설정되지 않았기 때문에 State가 Down으로 나옴.

### 07-5 IDC VPN Config
<img width="360" alt="스크린샷 2023-08-26 오전 10 25 49" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/04127278-77a6-4b8c-b343-638e39566f6f">

* OpenSwan 설정파일을 이용하여 IDC 측의 VPN 구성을 진행


#### 01 openswan 설치 및 서비스 활성화
```
yum install -y openswan
systemctl status ipsec && systemctl enable ipsec
```

#### 02 Network setup 
``` 
cat /etc/ipsec.conf | grep "include /etc/ipsec.d" 
include /etc/ipsec.d/*.conf
```
-> ipsec.d/*.conf 파일을 참조할 수 있도록 주석을 해제해야 함

/etc/sysctl.conf 파일을 확인 && 아래 구성을 통해 kernel이 처리하는 packet을 외부로 forwarding 시켜줘야 함

* net.ipv4.ip_forward = 1
* net.ipv4.conf.default.rp_filter = 0
* net.ipv4.conf.default.accept_source_route = 0
```
sysctl -p # 변경사항 확인
```
<img width="722" alt="set_sysctl_to_openswan" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/1cc87f75-a854-4214-bf18-172333210d9c">



#### 03 openswan VPN Configure
* 이전에 다운 받았던 openswan config 파일을 이용하여 구성
* 암호화 알고리즘의 변경으로 인해 아래 표와 같이 수정을 진행


|수정 전|수정 후|
|:---:|:---:|
|rightsubnet|VPC CIDR|
|leftsubnet|IDC CIDR|
|phase2alg=aes128-sha1;modp1024|phase2alg=aes_gcm|
|ike=aes128-sha1;modp1024|ike=aes256-sha1;modp1024|
|auth=esp|#auth=esp|


<img width="378" alt="etc_ipsec d_aws_conf" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/c039c5ef-54f8-4c5e-b210-5da6e1adb5ca">

* /etc/ipsec.d 위치에 aws.secrets 파일 생성 && .txt 파일을 참조하여 VPN connection에 필요한 secret key 저장

```
vim /etc/ipsec.d/aws.secrets
```
<img width="539" alt="etc_ipsec d_aws_secrets" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/9cb07c38-7b35-4e6b-81f7-c8020d54b520">

-> 위 처럼 구성 완료 후, ipsec 서비스 재시작
```
systemctl restart ipsec
```

### 07-6 VPN 구성 확인 및 테스트

<img width="1208" alt="tunnel_state_up" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/d30bda86-f227-447a-bfb5-ca81cd6f5951">

-> 두 개의 tunnel이 up된 상태임을 확인
```
ipsec status | grep -i total # tunnel 확인
netstat -nptul # 네트워크 구성 확인
```
<img width="745" alt="tunnel_open" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/811c51a9-3747-4c58-9060-a76e9ea814cf">

```
ping [IDC Private IP]
```

<img width="505" alt="스크린샷 2023-08-26 오전 11 07 15" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/8dd8ba39-280a-452f-9500-0cf398b54b5d">

-> Private Server 간의 Ping Test 성공


***

## [ 08 Ansible Playbook 실행 및 결과 ]

#### 01 Ansbile Vault 생성 명령어
- ansible playbook 실행에 필요한 변수들을 vault를 통해 보호

<img width="576" alt="00_ansible_vault_create" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/6350f3c0-55a3-4d58-95af-8672f9c3c798">



#### 02 Ansible Playbook syntax check
- playbook 실행 전에 구성 문법 확인

<img width="768" alt="00_ansible-playbook-syntax-check" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/12b20578-3b9b-4ccb-9867-39910277fe1f">



#### 03 Ansible Client User 생성 playbook 실행
- ansible 관련 작업을 진행할 때, 하나의 user를 사용함으로써 권한이슈 및 관리의 효율성을 챙기기 위해

<img width="817" alt="01_ansible_playbook_result" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/72359d3d-4b93-4423-aa5e-68ebb1d607e4">



#### 04 Aws cli download playbook
- IDC 대상으로 한 playbook이지만, 구현 시 AWS EC2 Instance를 IDC로 구성했기 때문에 기본적으로 aws cli가 다운로드 되어 있으므로 생략


#### 05 압축 테스트를 위한 임의의 파일 생성

<img width="717" alt="02_app_data" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/51760c1c-fa20-40b8-bcb6-f3d0bbe6f4a4">


#### 06 파일 압축 + S3 bucket Upload Playbook 실행

<img width="815" alt="02_ansible_playbook_02_result_s3_sync" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/323138ec-3b8b-4783-b300-567a1a3f188b">


<img width="618" alt="02_result_tar_gz_data" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/234dde71-b2de-4d8e-8acd-31c118b33b73">

- .tar.gz format으로 idc 서버에 압축된 것을 확인할 수 있음


#### 07 S3 bucket 확인

<img width="1334" alt="03_ansible_playbook_result_final" src="https://github.com/heungbot/01_Ansible_VPN_On_Premise/assets/97264115/9782afa2-4947-4821-b395-68c4a5a033fc">

- 압축된 파일이 s3 bucket으로 잘 가져와짐을 확인
