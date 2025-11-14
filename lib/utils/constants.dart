const supabaseUrl = 'https://gptgimsyaqkkbkspispk.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdwdGdpbXN5YXFra2Jrc3Bpc3BrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4MjU3MDMsImV4cCI6MjA3ODQwMTcwM30.OGhDgHGuTP6aChqhr47S9O7qYVPvdSK56MKYTbXIwiM';

// Map username-only auth to a pseudo-email for Supabase.
String usernameToEmail(String username) => '${username.trim()}@caredrop.dev';
