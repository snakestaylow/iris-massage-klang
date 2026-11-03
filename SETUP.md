# Iris Massage admin editing (Supabase)

The customer page is `photo-toggle.html`; the admin sign-in is `admin.html`. GitHub Pages is static, so shared edits and image uploads require the Supabase project setup below. Until configured, the customer page displays its built-in published defaults; the admin sign-in remains unavailable.

## 1. Create the Supabase project and admin user

1. Create a Supabase project you control.
2. In Authentication → Users, create one admin user with an email/password. Do not enable public sign-ups.
3. Copy that user's UUID (Auth UID). Use it in the SQL policies below.
4. In Project Settings → API, copy the Project URL and the anon/publishable key. These two values are designed for browser use; never use or publish a `service_role` key.

## 2. Apply the database/storage setup

Open the Supabase SQL Editor. In `supabase-setup.sql`, replace every `REPLACE_WITH_ADMIN_USER_UUID` with the admin Auth UID, then run the whole SQL file. It creates the initial site data, public-read settings and photos, and policies that permit writes only for that one admin UID. Public image URLs mean anyone can view uploaded photos; upload only images you have permission to publish.

## 3. Configure this website

Edit `supabase-config.js` and set:

- `url` to your Supabase Project URL
- `anonKey` to your anon/publishable key
- `adminUid` to the same Auth UID used in SQL

These are browser-visible values; database RLS and the storage policies enforce access. Never put a `service_role` key in this file.

Commit and push `supabase-config.js` along with the site to the existing GitHub Pages repository. The configuration is intentionally left with placeholders until you supply your own project details.

## 4. Use the editor

Open `/iris-massage-klang/admin.html`, sign in with the Supabase admin account, choose photos (JPG/PNG/WebP, max 8 MB), edit profile names/prices/availability or business hours and booking phone, and press **Save public changes**. Uploaded photos are stored in the public `iris-photos` bucket. Customer bookings open WhatsApp to the configured number with a prefilled inquiry; the site does not collect booking submissions.

Default business hours are 12:00 PM–12:00 AM and the booking number is 601139465648. Both can be changed in the editor.

## Security notes

- Do not turn on anonymous/public account creation.
- Only the configured Auth UID can update the site row or upload/change/delete bucket objects; the policy is enforced server-side by Supabase RLS.
- The anon/publishable API key is not a secret. The Supabase service-role key is a secret and must never be used by these static pages.
- Photos are public to website visitors. Do not upload private or unapproved photos.
