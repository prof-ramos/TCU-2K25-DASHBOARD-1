# 🚀 Quick Start: Deploy to Vercel

## ⚡ Fast Track (5 minutes)

### Option 1: Using Deployment Script (Recommended)

```bash
# Make script executable (first time only)
chmod +x deploy.sh

# Run deployment script
./deploy.sh
```

The script will:
- ✅ Validate build
- 📦 Show bundle sizes
- 🚢 Guide you through deployment

### Option 2: Manual Deployment

#### Preview Deployment (Test)
```bash
npm run build
vercel
```

#### Production Deployment
```bash
npm run build
vercel --prod
```

---

## 🔑 Environment Variables (Required)

Before deploying, set your environment variables in Vercel:

### Via CLI:
```bash
vercel env add GEMINI_API_KEY
# Paste your API key when prompted
# Select all environments: Production, Preview, Development
```

### Via Dashboard:
1. Go to https://vercel.com/dashboard
2. Select your project → **Settings** → **Environment Variables**
3. Add: `GEMINI_API_KEY` = `your_api_key_here`
4. Check all environments
5. Click **Save**

**Get API Key**: https://aistudio.google.com/app/apikey

---

## 📋 Pre-Deployment Checklist

- [ ] `npm run build` completes successfully
- [ ] Environment variables configured in Vercel Dashboard
- [ ] `.env.local` has valid `GEMINI_API_KEY` (for local testing)
- [ ] Changes committed to Git (if using Git integration)

---

## 🎯 Expected Build Output

```
✓ dist/index.html                       5.93 kB │ gzip:   1.48 kB
✓ dist/assets/utils-[hash].js          21.81 kB │ gzip:   7.24 kB
✓ dist/assets/ui-vendor-[hash].js      52.97 kB │ gzip:  17.76 kB
✓ dist/assets/react-vendor-[hash].js   60.75 kB │ gzip:  20.16 kB
✓ dist/assets/index-[hash].js         425.68 kB │ gzip: 124.17 kB
✓ built in ~1s
```

**Total**: ~561 KB (gzipped: ~170 KB) ✅

---

## ✅ Post-Deployment Validation

After deployment, test:

1. **Homepage loads** → https://your-project.vercel.app
2. **Navigation works** → Click on any matéria
3. **Progress tracking** → Check/uncheck items (should persist)
4. **AI feature** → Click "Ver Resumo" on any topic
5. **Dark mode** → Toggle theme (should persist)
6. **Mobile responsive** → Test on mobile device

---

## 🐛 Quick Troubleshooting

### Build fails?
```bash
# Clear cache and rebuild
rm -rf dist node_modules
npm install
npm run build
```

### 404 on page refresh?
✅ Already configured in `vercel.json` (SPA routing enabled)

### Environment variables not working?
1. Check Vercel Dashboard → Settings → Environment Variables
2. Redeploy after adding variables: `vercel --prod`

### API key exposed in bundle?
⚠️ This is expected for development. For production:
- Use backend proxy (recommended)
- Or migrate to Supabase Edge Functions

---

## 📊 Monitoring

### Check Deployment Status
```bash
vercel list
```

### View Logs
```bash
vercel logs [deployment-url]
```

### Rollback (if needed)
```bash
vercel rollback [deployment-id]
```

---

## 🔗 Important Links

- **Full Documentation**: [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md)
- **Vercel Dashboard**: https://vercel.com/dashboard
- **Project Repository**: https://github.com/prof-ramos/TCU-2K25-DASHBOARD
- **Get Gemini API Key**: https://aistudio.google.com/app/apikey

---

## ⚠️ Backend API Note

The Express API (`server/index.js`) is **NOT deployed** with this configuration.

**Options**:
1. **Convert to Vercel Serverless Functions** (recommended for Vercel)
2. **Deploy API separately** (Heroku, Railway, Render)
3. **Migrate to Supabase** (already configured!)

See [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md#backend-api-deployment) for details.

---

## 🎉 Success Criteria

Your deployment is successful when:
- ✅ All pages load without errors
- ✅ Progress tracking persists across refreshes
- ✅ AI summaries load (with valid API key)
- ✅ Dark mode toggles and persists
- ✅ Mobile navigation works smoothly
- ✅ Lighthouse Performance Score > 90

---

## 🆘 Need Help?

1. Check [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md) for detailed guide
2. Vercel Discord: https://discord.com/invite/vercel
3. Project Issues: https://github.com/prof-ramos/TCU-2K25-DASHBOARD/issues

---

**Ready to deploy?** Run `./deploy.sh` and follow the prompts! 🚀
