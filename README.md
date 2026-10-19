# Nijhum Portfolio

Single-file, journalism-themed portfolio (newspaper design, sliding work windows, admin editor).

## Files

- index.html : the whole site (HTML, CSS and JS in one file)

## Run it

Open index.html in a browser, or upload it to any static host (Netlify, GitHub Pages, Vercel, etc.).
Fonts load from Google Fonts, so an internet connection is needed for the typefaces.

## Edit content by hand

All default content lives in the `DEF` object near the top of the `<script>`:
photo, name, CV lists, and the `segs` array (the 4 segments, their Drive links and slide items).
Put images in the same folder and use paths like "photo.jpg" -- NOTE: the site only accepts image
URLs starting with https:, /\_blob/ or data:image, so for local files either use full https URLs
(e.g. a hosted image) or change the `U` function in index.html to allow relative paths.

## Shared admin editing on GitHub Pages

The admin editor uses Supabase Auth, Postgres, and Storage so portfolio edits and uploaded
images are shared across devices. `localStorage` is not used as the source of truth.

### One-time setup

1. Create a Supabase project.
2. In **SQL Editor**, run `supabase/schema.sql`.
3. Create your admin user under **Authentication → Users** using the email/password you want.
4. In the SQL Editor, mark only your admin account as an admin by running the statement below,
   replacing the email with the account you created. This must be `app_metadata`, never
   user-editable `user_metadata`:

   ```sql
   update auth.users
   set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"admin"}'::jsonb
   where email = 'YOUR_ADMIN_EMAIL';
   ```

   Then disable public sign-ups under **Authentication → Settings → User Signups**.

5. In **Project Settings → API**, copy the Project URL and publishable/anon key.
6. In GitHub repository **Settings → Secrets and variables → Actions → Variables**, add:
   - `SUPABASE_URL` — the Supabase project URL
   - `SUPABASE_ANON_KEY` — the public anon/publishable key (safe to expose in a browser)
7. Push to `main` or run the **Deploy static portfolio to GitHub Pages** workflow.

The deployment workflow writes `supabase-config.js` from those public repository variables.
For local testing, copy `supabase-config.example.js` to `supabase-config.js` and fill in the
same project URL and public key. That local config is ignored by Git. Never use the Supabase
service-role key in this site or in GitHub variables. Admin authorization is enforced by
Supabase row-level security.

### Access

Open `https://thegreatmahu.github.io/Nijhum-Porfolio/admin` and sign in with the Supabase
admin user's email and password. Changes save to the shared database; uploaded images are
stored in the public `portfolio-assets` bucket.

After database setup and deployment, sign in on the device that contains the old browser-only
edits and use **Import this device’s saved portfolio** once to copy that content to Supabase.
