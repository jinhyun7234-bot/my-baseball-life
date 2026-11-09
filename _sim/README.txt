명예의 전당 교체 준비 (v590 시뮬 600명)
1) Supabase 대시보드 SQL 편집기에서 delete_old_sim.sql 실행 → 예전 시뮬 600명 삭제
2) simhof_v590.json 을 사이트에 임시 업로드 → 사이트 페이지에서 hofSend로 600건 업로드 → 서버 조회로 600건·extra 확인 → 임시 파일 삭제 후 재배포
3) 나중에 지울 땐 sim_ids_new.txt 의 career_id 사용
