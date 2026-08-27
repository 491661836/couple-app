-- ============================================================
-- 情侣双人APP - Supabase 建表脚本
-- 使用方法：打开 Supabase 项目 → SQL Editor → 新建查询
-- 把下面全部内容粘贴进去，点 Run 执行
-- ============================================================

-- 1. 配置表：存纪念日、双人密码等
create table if not exists public.config (
  key text primary key,
  value text not null
);

-- 2. 留言板
create table if not exists public.messages (
  id bigint generated always as identity primary key,
  sender text not null,        -- 发送者标识：A 或 B
  content text not null,
  created_at timestamptz default now()
);

-- 3. 心愿清单
create table if not exists public.wishes (
  id bigint generated always as identity primary key,
  content text not null,
  done boolean default false,
  created_at timestamptz default now()
);

-- 4. 在线状态
create table if not exists public.presence (
  user_id text primary key,    -- A 或 B
  is_online boolean default false,
  last_seen timestamptz default now()
);

-- 5. 设备快照（退出时上报）
create table if not exists public.snapshots (
  id bigint generated always as identity primary key,
  user_id text not null,       -- A 或 B
  battery integer,             -- 电量百分比 0-100
  charging boolean,            -- 是否在充电
  network text,                -- 网络类型 wifi/cellular/4g/5g 等
  lat double precision,        -- 纬度
  lng double precision,        -- 经度
  app_uptime integer,          -- 本次APP运行时长（秒）
  created_at timestamptz default now()
);

-- ============================================================
-- 初始化默认数据
-- ============================================================

-- 默认纪念日（2025-01-01，可在APP里修改）
insert into public.config (key, value)
values ('anniversary', '2025-01-01')
on conflict (key) do nothing;

-- 默认双人密码（SHA-256 of "love123"）
-- 上线后请务必在APP里修改密码！
insert into public.config (key, value)
values ('password', 'love123')
on conflict (key) do nothing;

-- 初始化两个用户的在线状态
insert into public.presence (user_id, is_online)
values ('A', false), ('B', false)
on conflict (user_id) do nothing;

-- ============================================================
-- 开启 RLS（行级安全）并设置策略
-- 因为是双人小工具，我们允许 anon 角色读写所有业务表
-- 密码安全靠 obscurity，两人使用足够
-- ============================================================

alter table public.config enable row level security;
alter table public.messages enable row level security;
alter table public.wishes enable row level security;
alter table public.presence enable row level security;
alter table public.snapshots enable row level security;

-- 允许匿名角色读写所有表（双人小工具简化方案）
create policy "allow all on config" on public.config
  for all to anon using (true) with check (true);

create policy "allow all on messages" on public.messages
  for all to anon using (true) with check (true);

create policy "allow all on wishes" on public.wishes
  for all to anon using (true) with check (true);

create policy "allow all on presence" on public.presence
  for all to anon using (true) with check (true);

create policy "allow all on snapshots" on public.snapshots
  for all to anon using (true) with check (true);

-- ============================================================
-- 执行完毕！接下来去前端代码里填入你的 Supabase URL 和 anon key
-- ============================================================
