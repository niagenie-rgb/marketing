-- 業績/銷量資料表（一年一筆，data 內含各分類×型號的 12 個月數字）
-- 到 Supabase → SQL Editor → 貼上整段 → Run 一次即可

create table if not exists public.sales (
  brand      text not null,
  year       int  not null,
  month      int  not null default 0,   -- 固定 0，一年一筆
  data       jsonb,                       -- { "rows":[ {cat,item,unit,months:[12]} ] }
  updated_at timestamptz default now(),
  primary key (brand, year, month)
);

alter table public.sales enable row level security;

drop policy if exists sales_all on public.sales;
create policy sales_all on public.sales
  for all to anon, authenticated
  using (true) with check (true);

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on public.sales to anon, authenticated;

notify pgrst, 'reload schema';
