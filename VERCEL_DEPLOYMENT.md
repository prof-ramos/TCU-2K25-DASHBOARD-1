# 🚀 Vercel Deployment Guide - TCU Dashboard

## 📋 Pre-Deployment Checklist

This guide walks you through deploying your Vite + React application to Vercel with optimal configuration.

---

## 🎯 Project Configuration

### Files Created for Deployment

1. **vercel.json** - Vercel platform configuration
   - SPA routing support (rewrites all routes to index.html)
   - Security headers (XSS, Clickjacking, MIME-sniffing protection)
   - Caching strategy for static assets (1 year cache for immutable files)
   - Environment variable configuration

2. **.vercelignore** - Excluded files from deployment
   - Development dependencies
   - Documentation files
   - Docker configurations
   - Server code (if deploying separately)

3. **vite.config.ts** (optimized)
   - Code splitting configuration (React vendor, UI vendor, utils)
   - Minification with esbuild
   - Source maps for production debugging
   - Chunk size optimizations

---

## 🔧 Environment Variables Setup

### Required Environment Variables

You need to configure the following in Vercel Dashboard:

1. **GEMINI_API_KEY** (Required)
   - Get your API key from: https://aistudio.google.com/app/apikey
   - Used for AI-powered study assistance

2. **SUPABASE_URL** (Optional - if using Supabase)
   - Format: `https://[PROJECT_ID].supabase.co`
   - Currently: `https://imwohmhgzamdahfiahdk.supabase.co`

3. **SUPABASE_ANON_PUBLIC** (Optional - if using Supabase)
   - Supabase anonymous/public key
   - Safe to expose in frontend

### Setting Environment Variables in Vercel

#### Via CLI:
```bash
vercel env add GEMINI_API_KEY
# When prompted, enter your API key
# Select: Production, Preview, Development (all environments)
```

#### Via Dashboard:
1. Go to your project in Vercel Dashboard
2. Navigate to **Settings** → **Environment Variables**
3. Add each variable:
   - **Key**: `GEMINI_API_KEY`
   - **Value**: Your actual API key
   - **Environments**: Check all (Production, Preview, Development)
4. Click **Save**

---

## 🚀 Deployment Methods

### Method 1: Deploy via Vercel CLI (Recommended)

#### 1. Install Vercel CLI
```bash
npm install -g vercel
```

#### 2. Login to Vercel
```bash
vercel login
```

#### 3. Deploy to Preview (Test Deployment)
```bash
vercel
```
This creates a preview deployment at `https://[project-name]-[random].vercel.app`

#### 4. Deploy to Production
```bash
vercel --prod
```

### Method 2: Deploy via Git Integration (Automatic Deployments)

#### 1. Push to GitHub
```bash
git add .
git commit -m "feat: add Vercel deployment configuration"
git push origin main
```

#### 2. Import Project to Vercel
1. Go to https://vercel.com/new
2. Import your Git repository
3. Configure project:
   - **Framework Preset**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
   - **Install Command**: `npm install`
4. Add environment variables (see section above)
5. Click **Deploy**

#### 3. Automatic Deployments
- Every push to `main` branch → Production deployment
- Every pull request → Preview deployment
- Every push to other branches → Preview deployment

---

## 🏗️ Build Optimization Features

### Code Splitting Strategy
```typescript
// Configured in vite.config.ts
manualChunks: {
  'react-vendor': ['react', 'react-dom', 'react-router-dom'],
  'ui-vendor': ['lucide-react', '@radix-ui/*'],
  'utils': ['clsx', 'class-variance-authority', 'tailwind-merge']
}
```

**Benefits:**
- Faster initial load (parallel chunk downloads)
- Better caching (vendor code cached separately)
- Reduced bundle size per page

### Security Headers
Automatically applied to all responses:
- **X-Content-Type-Options**: `nosniff` - Prevents MIME-sniffing attacks
- **X-Frame-Options**: `DENY` - Prevents clickjacking
- **X-XSS-Protection**: `1; mode=block` - XSS attack protection
- **Referrer-Policy**: `strict-origin-when-cross-origin` - Privacy protection
- **Permissions-Policy**: Restricts access to sensitive APIs

### Caching Strategy
- **Static Assets**: 1 year cache (`max-age=31536000, immutable`)
- **HTML**: No cache (always fresh content)
- **Assets with hashed filenames**: Immutable cache-control

---

## 📊 Performance Optimization

### Build Analysis
Run this command to analyze your bundle size:

```bash
npm run build
```

Check the output for:
- Total bundle size (should be < 500KB for optimal load)
- Largest chunks (React vendor, UI vendor should be separated)
- Warning messages (resolve any chunk size warnings)

### Expected Bundle Sizes
```
dist/assets/react-vendor-[hash].js   ~140KB (gzipped: ~45KB)
dist/assets/ui-vendor-[hash].js      ~80KB (gzipped: ~25KB)
dist/assets/utils-[hash].js          ~20KB (gzipped: ~7KB)
dist/assets/index-[hash].js          ~150KB (gzipped: ~50KB)
Total: ~390KB (gzipped: ~127KB)
```

---

## 🧪 Pre-Deployment Testing

### 1. Test Build Locally
```bash
# Build the project
npm run build

# Preview production build
npm run preview
```

Visit http://localhost:4173 and test:
- ✅ All pages load correctly
- ✅ Navigation works (HashRouter)
- ✅ Progress tracking works
- ✅ AI features work (with real API key)
- ✅ Dark mode toggles correctly
- ✅ Responsive design on mobile

### 2. Test with Production Environment
```bash
# Create .env.production file
echo "GEMINI_API_KEY=your_production_key" > .env.production

# Build with production env
npm run build
```

---

## 🔍 Post-Deployment Validation

### 1. Verify Deployment
After deployment, check:
- [ ] Homepage loads correctly
- [ ] All static assets load (no 404s)
- [ ] Environment variables are accessible
- [ ] HashRouter navigation works
- [ ] API integrations function correctly
- [ ] Dark mode persists across page reloads

### 2. Performance Testing

#### Lighthouse Audit
1. Open deployed site in Chrome
2. Open DevTools → Lighthouse
3. Run audit (Mobile + Desktop)
4. Target scores:
   - **Performance**: > 90
   - **Accessibility**: > 95
   - **Best Practices**: > 90
   - **SEO**: > 90

#### Core Web Vitals
Monitor at https://vercel.com/[your-project]/analytics

Target metrics:
- **LCP** (Largest Contentful Paint): < 2.5s
- **FID** (First Input Delay): < 100ms
- **CLS** (Cumulative Layout Shift): < 0.1

### 3. Error Monitoring
Check Vercel logs for any runtime errors:
```bash
vercel logs [deployment-url]
```

---

## 🐛 Troubleshooting

### Build Fails with "Module not found"
**Solution**: Ensure all dependencies are in `package.json` dependencies (not devDependencies)
```bash
npm install [missing-package] --save
```

### Environment Variables Not Working
**Solution**:
1. Verify variables are set in Vercel Dashboard
2. Redeploy after adding new variables
3. Check variable names match exactly (case-sensitive)

### 404 on Page Refresh
**Solution**: Ensure `vercel.json` has the rewrite rule:
```json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }]
}
```

### Build Exceeds Time Limit
**Solution**: Optimize dependencies
```bash
# Remove unused dependencies
npm prune

# Check for large packages
npm list --depth=0
```

### API Requests Fail
**Solution**: Check CORS configuration if using external API
- Ensure API endpoint allows Vercel domain
- Verify environment variables are set correctly

---

## 🔄 Continuous Deployment

### Automatic Deployments (Git Integration)
Once connected to Git, every commit triggers:
1. **Build**: Runs `npm run build`
2. **Tests**: Runs `npm test` (if configured)
3. **Deploy**: Deploys to preview or production
4. **Notifications**: GitHub status checks update

### Branch Deployments
- `main` → Production (your-domain.com)
- `develop` → Preview (your-project-git-develop.vercel.app)
- Feature branches → Preview (your-project-git-feature.vercel.app)

### Rollback Strategy
If deployment fails:
```bash
# List recent deployments
vercel list

# Rollback to previous deployment
vercel rollback [deployment-id]
```

---

## 📈 Monitoring & Analytics

### Vercel Analytics (Built-in)
1. Enable in Vercel Dashboard: **Analytics** tab
2. Tracks:
   - Page views
   - Top pages
   - Top referrers
   - Core Web Vitals
   - Geographic distribution

### Custom Analytics Integration
Add to `src/main.tsx` or `src/App.tsx`:
```typescript
// Google Analytics
import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';

function usePageTracking() {
  const location = useLocation();

  useEffect(() => {
    // Track page view
    if (window.gtag) {
      window.gtag('config', 'GA_MEASUREMENT_ID', {
        page_path: location.pathname + location.search,
      });
    }
  }, [location]);
}
```

---

## 🚨 Important Notes

### Backend API Deployment
⚠️ **Warning**: The Express API (`server/index.js`) is NOT deployed with this Vercel configuration.

**Options for API deployment:**

#### Option 1: Deploy API as Vercel Serverless Function
Convert Express API to Vercel serverless functions:
```javascript
// api/progress.js
export default async function handler(req, res) {
  // Your Express logic here
}
```

#### Option 2: Deploy API Separately
Deploy Express API to:
- **Heroku** (free tier)
- **Railway** (free tier)
- **Render** (free tier)
- **DigitalOcean App Platform**

Then update frontend API calls:
```typescript
// src/services/databaseService.ts
const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001';
```

Add environment variable in Vercel:
```
VITE_API_URL=https://your-api-deployment.herokuapp.com
```

#### Option 3: Migrate to Supabase (Recommended)
You already have Supabase configured! Use it for:
- ✅ Database (PostgreSQL instead of SQLite)
- ✅ Real-time subscriptions
- ✅ Authentication
- ✅ Storage
- ✅ Edge Functions

---

## 🎯 Production Readiness Checklist

Before going live:

- [ ] Environment variables configured in Vercel
- [ ] Build completes successfully
- [ ] All routes work correctly
- [ ] API integrations tested
- [ ] Error tracking configured
- [ ] Analytics enabled
- [ ] Performance metrics meet targets (Lighthouse > 90)
- [ ] Security headers validated
- [ ] Custom domain configured (optional)
- [ ] SSL certificate active (automatic with Vercel)
- [ ] Backup strategy for user data
- [ ] Monitoring alerts configured

---

## 🆘 Support Resources

- **Vercel Documentation**: https://vercel.com/docs
- **Vite Deployment**: https://vitejs.dev/guide/static-deploy.html
- **Vercel Community**: https://github.com/vercel/vercel/discussions
- **Project Issues**: https://github.com/prof-ramos/TCU-2K25-DASHBOARD/issues

---

## 🎉 Success!

Once deployed, your dashboard will be available at:
- **Production**: `https://[your-project].vercel.app`
- **Custom Domain**: `https://your-domain.com` (if configured)

Share the URL with fellow TCU exam candidates! 🚀
