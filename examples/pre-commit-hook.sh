#!/bin/bash
# Pre-commit hook to check for unused functions
# Place this in .git/hooks/pre-commit and make it executable: chmod +x .git/hooks/pre-commit

echo "🔍 Checking for unused functions..."

# Run the analysis
OUTPUT=$(pyan-unused-functions . 2>&1)

# Check if any unused functions were found
UNUSED_COUNT=$(echo "$OUTPUT" | grep "Potentially unused functions:" | grep -oE '[0-9]+' || echo "0")

if [ "$UNUSED_COUNT" -gt 0 ]; then
    echo ""
    echo "⚠️  Warning: Found $UNUSED_COUNT potentially unused functions"
    echo ""
    echo "$OUTPUT"
    echo ""
    echo "Consider reviewing these functions before committing."
    echo "To bypass this check, use: git commit --no-verify"
    echo ""
    
    # Uncomment the line below to block commits with unused functions
    # exit 1
    
    # For now, just warn and allow commit
    exit 0
else
    echo "✅ No unused functions detected!"
    exit 0
fi
