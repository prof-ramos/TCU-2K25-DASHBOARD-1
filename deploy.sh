#!/bin/bash

# TCU Dashboard - Vercel Deployment Script
# This script automates the deployment process to Vercel

set -e  # Exit on error

echo "🚀 TCU Dashboard - Vercel Deployment"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo -e "${RED}❌ Vercel CLI is not installed${NC}"
    echo "Install it with: npm install -g vercel"
    exit 1
fi

echo -e "${GREEN}✅ Vercel CLI found${NC}"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  Warning: .env file not found${NC}"
    echo "Create one from .env.example or .env.production.example"
    echo ""
fi

# Run build to validate
echo "🏗️  Running production build..."
npm run build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful${NC}"
    echo ""
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

# Display bundle size
echo "📦 Bundle Analysis:"
ls -lh dist/assets/*.js | awk '{print "   "$9" - "$5}'
echo ""

# Ask deployment type
echo "Select deployment type:"
echo "  1) Preview deployment (test)"
echo "  2) Production deployment"
echo "  3) Cancel"
echo ""
read -p "Enter your choice [1-3]: " choice

case $choice in
    1)
        echo ""
        echo "🚢 Deploying to Preview..."
        vercel
        ;;
    2)
        echo ""
        echo "⚠️  You are about to deploy to PRODUCTION"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            echo ""
            echo "🚢 Deploying to Production..."
            vercel --prod
        else
            echo "Deployment cancelled"
            exit 0
        fi
        ;;
    3)
        echo "Deployment cancelled"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}🎉 Deployment complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Visit your deployment URL"
echo "  2. Test all features (navigation, progress tracking, AI integration)"
echo "  3. Check Core Web Vitals in Vercel Analytics"
echo "  4. Monitor for errors in Vercel dashboard"
echo ""
echo "Documentation: ./VERCEL_DEPLOYMENT.md"
