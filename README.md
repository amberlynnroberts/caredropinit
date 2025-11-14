# CareDrop (Flutter Web + Supabase) — Full Build

This is a full Flutter web starter for CareDrop with:

- Material 3 theme and CareDrop blue/yellow palette
- Supabase integration with **placeholders** for your URL and anon key
- Username-only auth (mapped to `username@caredrop.local`)
- Real CRUD for `requests` table:
  - Browse all requests
  - Create new request
  - Claim (update status)
  - "My Dashboard" shows only your created requests
- Screens: Splash, Landing, Browse, Request Details, Create Request, My Dashboard, Login/Register, Admin Dashboard

## Setup

1. Install Flutter (stable) and enable web:

```bash
flutter channel stable
flutter upgrade
flutter config --enable-web
```

2. Install dependencies and run:

```bash
flutter pub get
flutter run -d chrome
```

3. Create a Supabase project at https://supabase.com and get:
   - Project URL
   - anon public key

4. Open `lib/utils/constants.dart` and set:

```dart
const supabaseUrl = 'YOUR_SUPABASE_URL';
const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

5. In Supabase, create a `requests` table:

```sql
create table if not exists public.requests (
  id uuid primary key default uuid_generate_v4(),
  title text,
  description text,
  category text,
  location text,
  quantity int,
  status text,
  image_url text,
  created_by text,
  created_at timestamp with time zone default now()
);
```

You can later add row level security (RLS) and policies to limit who can edit what.

## Notes

- No mock data: all lists are driven entirely by Supabase.
- If you run without valid Supabase URL/keys, calls will fail; use try/catch or set up a dev project.
- You can customize colors in `lib/theme/theme.dart`.

