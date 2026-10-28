-- Run this once in Supabase: SQL Editor > New query.
create table public.waitlist (
  id uuid primary key default gen_random_uuid(),
  email text not null check (length(email) <= 254 and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  role text not null check (role in ('teacher','school_leader','parent','other')),
  lang text check (lang in ('en','es')),
  consent boolean not null check (consent = true),
  created_at timestamptz not null default now()
);

-- One row per email, case-insensitive. A repeat sign-up returns HTTP 409.
create unique index waitlist_email_key on public.waitlist (lower(email));

-- Lock the table down: the public key may add rows, never read, change or delete them.
alter table public.waitlist enable row level security;

create policy "anon can insert" on public.waitlist
  for insert to anon with check (true);
