-- 나의 야구 인생 · 온라인 명예의 전당
-- Supabase 대시보드 → SQL Editor → New query 에 전부 붙여넣고 Run

create table if not exists public.hof_records (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  career_id   text not null unique check (char_length(career_id) between 6 and 40),
  nick        text not null check (char_length(nick) between 1 and 12),   -- 선수 이름
  owner       text check (owner is null or char_length(owner) <= 12),     -- 플레이어 닉네임(선택)
  team        text check (team is null or char_length(team) <= 24),
  pos         text not null check (pos in ('C','1B','2B','3B','SS','LF','CF','RF','DH','SP','RP')),
  kind        text not null check (kind in ('B','P')),
  prole       text check (prole is null or prole in ('SP','CL','RP')),
  hof         boolean not null default false,
  years       int  not null default 0 check (years between 0 and 30),
  end_y       int,
  war         numeric(5,1) not null check (war between -50 and 400),          -- 1군(KBO+NPB+MLB) WAR 합
  wwar        numeric(5,1) check (wwar is null or wwar between -100 and 800),   -- 명예의 전당 점수(가중 WAR)
  kbo_war     numeric(5,1) default 0,
  mlb_war     numeric(5,1) default 0,
  npb_war     numeric(5,1) default 0,
  minor_war   numeric(5,1) default 0,
  g           int not null default 0 check (g between 0 and 4500),
  h           int not null default 0 check (h between 0 and 6000),
  hr          int not null default 0 check (hr between 0 and 1500),
  rbi         int not null default 0 check (rbi between 0 and 4000),
  sb          int not null default 0 check (sb between 0 and 2000),
  avg         numeric(4,3) not null default 0 check (avg between 0 and 0.6),
  ops         numeric(4,3) not null default 0 check (ops between 0 and 2.5),
  pa          int not null default 0 check (pa between 0 and 16000),
  w           int not null default 0 check (w between 0 and 600),
  l           int not null default 0 check (l between 0 and 600),
  sv          int not null default 0 check (sv between 0 and 900),
  hld         int not null default 0 check (hld between 0 and 900),
  k           int not null default 0 check (k between 0 and 8000),
  ip          numeric(6,1) not null default 0 check (ip between 0 and 9000),
  era         numeric(5,2) check (era is null or era between 0 and 40),
  rings       int not null default 0 check (rings between 0 and 30),
  mvps        int not null default 0 check (mvps between 0 and 60)
);

-- 예전 버전 SQL을 이미 실행했다면 아래 줄들이 새 칸을 추가해 줘요
alter table public.hof_records add column if not exists wwar numeric(5,1);
alter table public.hof_records add column if not exists kbo_war numeric(5,1) default 0;
alter table public.hof_records add column if not exists mlb_war numeric(5,1) default 0;
alter table public.hof_records add column if not exists npb_war numeric(5,1) default 0;
alter table public.hof_records add column if not exists minor_war numeric(5,1) default 0;

create index if not exists hof_war_idx on public.hof_records (war desc);
create index if not exists hof_wwar_idx on public.hof_records (wwar desc);
create index if not exists hof_kind_idx on public.hof_records (kind, pos, prole);

-- 누구나 읽기 / 새 기록 올리기만 가능 (수정·삭제는 대시보드에서 관리자만)
alter table public.hof_records enable row level security;
drop policy if exists "hof read" on public.hof_records;
drop policy if exists "hof insert" on public.hof_records;
create policy "hof read"   on public.hof_records for select to anon, authenticated using (true);
create policy "hof insert" on public.hof_records for insert to anon, authenticated with check (true);
grant select, insert on public.hof_records to anon, authenticated;
