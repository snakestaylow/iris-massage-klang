// These are public client settings. Keep database security in Supabase RLS policies.
// Replace both values with your Supabase Project URL and anon/publishable key.
window.SUPABASE_CONFIG = {
  url: "YOUR_SUPABASE_PROJECT_URL",
  anonKey: "YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY",
  adminUid: "REPLACE_WITH_ADMIN_USER_UUID"
};
window.SUPABASE_READY = window.SUPABASE_CONFIG.url.startsWith("https://") &&
  !window.SUPABASE_CONFIG.url.includes("YOUR_") &&
  !window.SUPABASE_CONFIG.anonKey.includes("YOUR_");
