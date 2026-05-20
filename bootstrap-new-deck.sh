#!/usr/bin/env bash
# bootstrap-new-deck.sh
#
# 一鍵從 Book 5 template 開新簡報專案。
#
# 用法:
#   ./bootstrap-new-deck.sh <repo-slug> "<topic-title>" "<topic-subtitle>"
#
# 範例:
#   ./bootstrap-new-deck.sh kubernetes-security "Kubernetes Security" "從 Pod 到叢集的縱深防禦"
#
# 做了什麼:
#   1. clone Book 5 template 到 ../<repo-slug>
#   2. 重置 git history（移除 Book 5 commits）
#   3. 清除 book5-images/ 內容 → 改名 images/，留空目錄
#   4. 改 index.html cover h1/sub 為新主題
#   5. 將所有圖片路徑 book5-images/ → images/
#   6. 在 30 個文字頁 section 插入 <!-- TODO: 內容換成新主題 --> 註記
#   7. 在 15 個視覺頁加 <!-- TODO: 重生 v*.png --> 註記
#   8. 寫一份新 README + TODO checklist
#   9. 建立新 public repo + push + 啟用 Pages（可用 --no-push 跳過）
#  10. 印出新 Pages URL

set -euo pipefail

# ---- 參數驗證 ----
REPO_SLUG="${1:-}"
TOPIC_TITLE="${2:-}"
TOPIC_SUB="${3:-}"
NO_PUSH=false
for arg in "$@"; do
  [ "$arg" = "--no-push" ] && NO_PUSH=true
done

if [ -z "$REPO_SLUG" ] || [ -z "$TOPIC_TITLE" ] || [ -z "$TOPIC_SUB" ]; then
  echo "Usage: $0 <repo-slug> \"<topic-title>\" \"<topic-subtitle>\" [--no-push]"
  echo
  echo "Example:"
  echo "  $0 kubernetes-security \"Kubernetes Security\" \"從 Pod 到叢集的縱深防禦\""
  exit 1
fi

TEMPLATE_REPO="Reese-max/book5-windows-server-2022"
PARENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$PARENT_DIR/$REPO_SLUG"

echo "==> Bootstrap '$REPO_SLUG' from $TEMPLATE_REPO"
echo "    Topic: $TOPIC_TITLE — $TOPIC_SUB"
echo "    Target: $TARGET_DIR"
echo

# ---- 1. Clone ----
if [ -d "$TARGET_DIR" ]; then
  echo "ERROR: $TARGET_DIR already exists. Remove it or choose another slug." >&2
  exit 1
fi

gh repo clone "$TEMPLATE_REPO" "$TARGET_DIR"
cd "$TARGET_DIR"

# ---- 2. 重置 git ----
echo "==> Resetting git history"
rm -rf .git
git init -b main >/dev/null

# ---- 3. 清空 book5-images/ ----
echo "==> Renaming book5-images/ → images/ and clearing PNG content"
if [ -d "book5-images" ]; then
  git mv book5-images images 2>/dev/null || mv book5-images images
  # 移除實際圖檔（保留目錄結構）
  find images -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" \) -delete
  rm -rf images/_old_bg images/logs images/*.sh 2>/dev/null || true
  # 留一個 placeholder
  cat > images/README.md <<'EOF'
# images/

放 v*.png（15 張視覺頁圖）和 bg-*.png（6 張章節背景圖）。

用 launch-visuals.sh + launch-bgs.sh 並行生成。
EOF
fi

# ---- 4. 改 index.html ----
echo "==> Patching index.html with new topic"

# 用環境變數傳給 Python，避免 bash heredoc 變數展開問題
export TOPIC_TITLE TOPIC_SUB
python <<'PYEOF'
import io, re, os

TITLE = os.environ['TOPIC_TITLE']
SUB = os.environ['TOPIC_SUB']

with io.open('index.html', 'r', encoding='utf-8') as f:
    html = f.read()

# A. 換 cover h1
html = re.sub(
    r'<h1 class="reveal d1">.*?</h1>',
    f'<h1 class="reveal d1">{TITLE}</h1>',
    html, count=1, flags=re.DOTALL
)

# B. 換 cover sub
html = re.sub(
    r'<div class="sub reveal d2">.*?</div>',
    f'<div class="sub reveal d2">{SUB}</div>',
    html, count=1, flags=re.DOTALL
)

# C. 改 <title>
html = re.sub(r'<title>.*?</title>', f'<title>{TITLE}</title>', html, count=1)

# D. 圖片路徑 book5-images/ → images/
html = html.replace('book5-images/', 'images/')

# E. 在每個 text section 內 .content 開頭插 TODO 註記
def stub_text(m):
    block = m.group(0)
    if 'class="slide visual"' in block:
        return block
    return block.replace('<div class="content">',
        '<div class="content">\n    <!-- TODO: 改成新主題對應內容 -->', 1)

html = re.sub(r'<section class="slide[^"]*" data-i="\d+">.*?</section>',
              stub_text, html, flags=re.DOTALL)

# F. 視覺頁 vcap 加 TODO
def stub_visual(m):
    block = m.group(0)
    return block.replace('<div class="vcap reveal d2">',
        '<div class="vcap reveal d2">\n    <!-- TODO: 重生 vXX-*.png 並改 vkey/vtitle/vbody -->', 1)

html = re.sub(r'<section class="slide visual" data-i="\d+">.*?</section>',
              stub_visual, html, flags=re.DOTALL)

with io.open('index.html', 'w', encoding='utf-8') as f:
    f.write(html)

print('OK — index.html patched')
PYEOF

# ---- 5. 寫新 README ----
echo "==> Writing new README + TODO checklist"
cat > README.md <<EOF
# $TOPIC_TITLE — 簡報

> $TOPIC_SUB

從 [Book 5 template]($TEMPLATE_REPO) bootstrap。**45 頁深色 editorial-tech 風格**。

## TODO Checklist

- [ ] **30 個文字頁**：搜尋 \`<!-- TODO: 改成新主題對應內容 -->\` 把每頁的 \`.content\` 內換成新主題
- [ ] **15 個視覺頁**：執行 \`./launch-visuals.sh\` 生圖（先改腳本內 15 個 codex prompt）
- [ ] **6 個章節背景**：執行 \`./launch-bgs.sh\` 生圖
- [ ] **partOf() 章節分配**：若新主題章節數與 Book 5 不同，改 index.html 內 partOf() JS
- [ ] **HUD pageno**：確認每頁 \`NN / 45\` 與你的總頁數對齊
- [ ] **本地測試**：\`python -m http.server 8765\` 開 localhost
- [ ] **push GitHub**：\`gh repo create --public --source=. --push\`
- [ ] **啟用 Pages**：\`gh api -X POST repos/USER/REPO/pages -f source[branch]=main -f source[path]=/\`

## 架構參考

完整模板與 prompt 庫見 [PROMPT-TEMPLATE.md](./PROMPT-TEMPLATE.md)。
EOF

# ---- 6. 初始 commit ----
echo "==> Initial commit"
git add .
git -c user.email=bootstrap@local -c user.name=bootstrap commit -q -m "feat: bootstrap $REPO_SLUG from Book 5 template

Topic: $TOPIC_TITLE
Subtitle: $TOPIC_SUB

Scaffold ready. See README.md TODO checklist."

# ---- 7. push 到 GitHub ----
if [ "$NO_PUSH" = true ]; then
  echo
  echo "✅ Bootstrap complete (local only, --no-push)."
  echo "📁 cd $TARGET_DIR"
  echo "📝 Open README.md to see TODO checklist."
  exit 0
fi

USER_LOGIN=$(gh api user --jq .login)
echo "==> Creating GitHub repo $USER_LOGIN/$REPO_SLUG"
gh repo create "$REPO_SLUG" --public --source=. --push \
  --description "$TOPIC_TITLE — $TOPIC_SUB"

# ---- 8. 啟用 Pages ----
echo "==> Enabling GitHub Pages"
gh api -X POST "repos/$USER_LOGIN/$REPO_SLUG/pages" \
  -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || {
    echo "WARN: Pages enable failed (may already be enabled or need manual config)"
}

# ---- 9. 完成 ----
echo
echo "✅ Bootstrap done!"
echo "📁 Local: $TARGET_DIR"
echo "🔗 Repo:  https://github.com/$USER_LOGIN/$REPO_SLUG"
echo "🌐 Pages: https://$USER_LOGIN.github.io/$REPO_SLUG/"
echo
echo "Next:"
echo "  1. cd $TARGET_DIR"
echo "  2. 看 README.md TODO 清單"
echo "  3. 改 index.html 內容"
echo "  4. 跑 ./launch-visuals.sh 生圖"
echo "  5. push 後等 ~1 min CDN 同步"
