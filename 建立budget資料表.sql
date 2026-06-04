-- 預算管理頁所需的資料表
-- 到 Supabase → SQL Editor → 貼上整段 → 按 Run 執行一次即可

create table if not exists public.budget (
  brand      text    not null,
  year       int     not null,
  month      int     not null default 0,   -- 固定為 0，一年一筆
  data       jsonb,                         -- { "items": [...] }
  updated_at timestamptz default now(),
  primary key (brand, year, month)
);

-- 開啟 RLS 並允許 anon 金鑰讀寫（與現有 ad_data / notes 表一致）
alter table public.budget enable row level security;

drop policy if exists "budget anon all" on public.budget;
create policy "budget anon all" on public.budget
  for all
  to anon
  using (true)
  with check (true);

-- ⭐ 關鍵：把表的讀寫權限授予 anon / authenticated 角色
-- （只有 RLS 政策還不夠，少了 GRANT 會出現「儲存失敗」）
grant select, insert, update, delete on public.budget to anon, authenticated;
