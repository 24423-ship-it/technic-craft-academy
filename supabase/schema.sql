-- Run this SQL in Supabase Dashboard > SQL Editor.
create table if not exists public.student_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  full_name text not null,
  student_id text not null,
  student_number text not null,
  classroom text not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.quiz_results (
  user_id uuid primary key references auth.users(id) on delete cascade,
  score integer not null check (score >= 0),
  total integer not null check (total > 0),
  percentage numeric(5,2) not null,
  passed boolean not null,
  answers jsonb not null default '[]'::jsonb,
  completed_at timestamptz not null default now()
);

alter table public.student_profiles enable row level security;
alter table public.quiz_results enable row level security;

drop policy if exists "Students can read own profile" on public.student_profiles;
create policy "Students can read own profile" on public.student_profiles
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Students can insert own profile" on public.student_profiles;
create policy "Students can insert own profile" on public.student_profiles
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Students can update own profile" on public.student_profiles;
create policy "Students can update own profile" on public.student_profiles
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Students can read own quiz result" on public.quiz_results;
create policy "Students can read own quiz result" on public.quiz_results
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Students can insert own quiz result" on public.quiz_results;
create policy "Students can insert own quiz result" on public.quiz_results
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Students can update own quiz result" on public.quiz_results;
create policy "Students can update own quiz result" on public.quiz_results
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
