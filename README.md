# 나의 야구 인생 — 웹사이트 배포 가이드

이 폴더 그대로 무료 호스팅에 올리면 바로 게임 사이트가 됩니다.
온라인 명예의 전당(통산 순위)을 쓰려면 Supabase 무료 프로젝트 하나만 만들면 돼요.

## 폴더 구성

| 파일 | 하는 일 |
|---|---|
| `index.html` | 게임 전체 |
| `config.js` | 명예의 전당 서버 주소·키 (직접 채워 넣기) |
| `manifest.webmanifest`, `sw.js`, `icons/` | 폰 홈 화면 설치(PWA)·오프라인 실행 |
| `supabase.sql` | 명예의 전당 테이블 만드는 SQL |

## 1. 명예의 전당 서버 만들기 (Supabase, 무료)

1. https://supabase.com 가입 → **New project** (지역은 Northeast Asia (Seoul) 추천)
2. 왼쪽 메뉴 **SQL Editor** → New query → `supabase.sql` 내용 전부 붙여넣고 **Run**
3. **Project Settings → API** 에서 두 값을 복사
   - Project URL (예: `https://abcdefgh.supabase.co`)
   - `anon` `public` 키
4. `config.js` 를 열어 `YOUR_SUPABASE_URL`, `YOUR_SUPABASE_ANON_KEY` 자리에 붙여넣기

> anon 키는 웹사이트에 공개돼도 되는 키예요. 테이블 권한을 "읽기 + 새 기록 올리기"만 열어뒀어요.
> `service_role` 키는 절대 넣지 마세요.

config.js 를 안 채우면 게임은 정상 동작하고 명예의 전당 버튼만 숨겨집니다.

## 2. 사이트 올리기 (셋 중 하나)

**Cloudflare Pages (추천, 무료·빠름)**
1. https://pages.cloudflare.com → Create → **Upload assets**
2. 이 폴더를 통째로 끌어다 놓기 → Deploy
3. `프로젝트이름.pages.dev` 주소가 생겨요

**Netlify Drop**: https://app.netlify.com/drop 에 폴더 끌어다 놓기

**GitHub Pages**: 저장소에 파일 올리고 Settings → Pages → Branch: main

## 3. 업데이트할 때

`index.html` 만 새 파일로 바꿔서 다시 올리면 돼요. (`config.js` 는 그대로 두기)
사이트 주소(도메인)는 바꾸지 마세요 — 플레이어 저장 데이터가 주소별로 브라우저에 저장돼서, 주소가 바뀌면 기존 저장이 안 보여요.

## 4. 명예의 전당 관리

- Supabase → **Table Editor → hof_records** 에서 이상한 기록(욕설 닉네임, 말이 안 되는 기록)을 지울 수 있어요.
- 게임 계산이 플레이어 기기에서 돌아가는 구조라, 마음먹고 조작한 기록을 100% 막을 수는 없어요. 값 범위 제한만 걸어뒀고, 눈에 띄는 건 대시보드에서 지우면 됩니다.

## 명예의 전당 규칙 (게임 안)

- 은퇴 화면에서 **기록 올리기** → 한 커리어당 한 번
- **명예의 전당 점수** = KBO WAR ×1.0 + MLB WAR ×2.0 + NPB WAR ×1.3 + 마이너 WAR (AAA ×0.5, AA 이하 ×0.3) · 퓨처스(2군) 제외
- **명예의 전당**: 포지션별(포수~지명타자 9자리) 점수 1위 + 투수 선발 1위 · 마무리 1위 · 불펜 1위
- **통산 순위**: 야수(명예의 전당 점수·1군 WAR·홈런·안타·타점·도루·타율), 투수(명예의 전당 점수·1군 WAR·승·세이브·홀드·탈삼진·평균자책점) 각 TOP 50
