require('dotenv').config();
const express = require('express');
const path = require('path');
const multer = require('multer');
const { createClient } = require('@supabase/supabase-js');

const app = express();
const PORT = process.env.PORT || 3000;
const BUCKET = process.env.SUPABASE_STORAGE_BUCKET || 'deal-files';

const supabaseAdmin = (process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_KEY)
  ? createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_KEY)
  : null;

app.use(express.json());

// Multer in-memory storage for file uploads
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 25 * 1024 * 1024 } });

// Serve static files from public/
app.use(express.static(path.join(__dirname, 'public')));

// API endpoint to provide Supabase config to the frontend
app.get('/api/config', (req, res) => {
  res.json({
    supabaseUrl: process.env.SUPABASE_URL,
    supabaseAnonKey: process.env.SUPABASE_ANON_KEY,
    storageBucket: BUCKET,
    storageEnabled: !!supabaseAdmin
  });
});

// Upload a file to Supabase Storage and return its public URL
app.post('/api/upload', upload.single('file'), async (req, res) => {
  if (!supabaseAdmin) return res.status(500).json({ error: 'Storage not configured (missing SUPABASE_SERVICE_KEY)' });
  if (!req.file) return res.status(400).json({ error: 'No file provided' });
  const dealId = req.body.opportunity_id || 'unassigned';
  const safeName = req.file.originalname.replace(/[^A-Za-z0-9._-]/g, '_');
  const objectPath = `${dealId}/${Date.now()}_${safeName}`;
  const { error: upErr } = await supabaseAdmin.storage.from(BUCKET).upload(objectPath, req.file.buffer, {
    contentType: req.file.mimetype, upsert: false
  });
  if (upErr) return res.status(500).json({ error: upErr.message });
  const { data: pub } = supabaseAdmin.storage.from(BUCKET).getPublicUrl(objectPath);
  res.json({
    url: pub.publicUrl,
    path: objectPath,
    name: req.file.originalname,
    size: req.file.size,
    contentType: req.file.mimetype
  });
});

// Proxy file download (useful when bucket is private)
app.get('/api/file', async (req, res) => {
  if (!supabaseAdmin) return res.status(500).json({ error: 'Storage not configured' });
  const objectPath = req.query.path;
  if (!objectPath) return res.status(400).json({ error: 'path query parameter required' });
  const { data, error } = await supabaseAdmin.storage.from(BUCKET).download(objectPath);
  if (error) return res.status(404).json({ error: error.message });
  const buf = Buffer.from(await data.arrayBuffer());
  res.setHeader('Content-Type', data.type || 'application/octet-stream');
  res.send(buf);
});

// SPA fallback — all routes serve index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Ad Sales CRM running on port ${PORT}`);
});
