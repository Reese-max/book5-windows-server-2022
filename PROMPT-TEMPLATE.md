# 簡報生成 Prompt 模板（Book 5 風格 · 完整版）

> 從 30 → 45 頁深色 editorial-tech 簡報的完整 prompt + 腳本庫，可直接套到其他主題。
> Book 5 實戰萃取，含「Q 版 → 氛圍照 → B&W 漫畫」三輪迭代的失敗復盤。

---

## 一、總體規格

```
- 總頁數: 30 文字頁 + 15 全頁視覺 = 45
- 平台: 單一自包含 HTML + JS + book5-images/*.png
- 設備支援: 桌機 (slideshow) + 手機 (scroll-stack)
- 字級: clamp(min, vw-relative, max)
- 動畫: fade-in slide + reveal stagger + bg crossfade
- 部署: GitHub Pages (public repo, free, CDN cached)
```

---

## 二、視覺 Design Tokens

```css
:root {
  --bg: #07090f;
  --bg-2: #0d1220;
  --surface: #131a2e;
  --border: rgba(255,255,255,0.08);
  --text: #f4f6fb;            /* 主文字 */
  --muted: #c8d2e4;           /* 副文字（漫畫 bg 上要這麼亮）*/
  --dim: #8a94ad;             /* 邊框 / dim 字 */
  --accent: #00d4ff;          /* cyan */
  --accent-2: #7c5cff;        /* violet */
  --warn: #ffb547;
  --danger: #ff5577;
  --good: #00e89a;
  --grad-1: linear-gradient(135deg, #00d4ff, #7c5cff);
}
```

**字體**：`Noto Sans TC` (700-900) + `Space Grotesk` (500-700) + `JetBrains Mono`

**字級基準**（最終放大版）:
| 元素 | 桌機 | 手機 |
|------|------|------|
| h1 title | `clamp(58px, 7.2vw, 108px)` | `clamp(36px, 9.5vw, 54px)` |
| h2 title | `clamp(44px, 5.2vw, 76px)` | `clamp(30px, 8vw, 46px)` |
| Cover h1 | clamp inherit | `clamp(48px, 13vw, 84px)` |
| 中央問句 | `clamp(56px, 7.5vw, 112px)` | `clamp(34px, 8.5vw, 48px)` |
| 結尾大字 | `clamp(42px, 5.2vw, 72px)` | `clamp(26px, 7.5vw, 38px)` |
| 卡片 h4 / 內文 | 26px / 17px | 21px / 15px |
| chip h4 / 內文 | 23px / 16px | 18px / 13px |
| 表格 | 18px | 15px |
| 視覺頁 vtitle / vbody | 50px / 18px | 28px / 15px |

---

## 三、章節結構 & Part 主題色

```
Opening (slides 1-5):    開場 / 提問 / 全章地圖 / 為什麼 / 架構
Part 1 (5 slides):       身分 — SID, Security Descriptor, DACL/SACL, ACL
Part 2 (7 slides):       共享資源 — Share, NTFS, Effective, Case
Part 3 (4 slides):       稽核 — Why audit, Audit Policy, Local Policy, LSDOU
Part 4 (6 slides):       主機/防火牆 — Defender, UAC, Cred Guard, Firewall
Part 5 (3 slides):       憑證信任 — PKI, AD CS, DNSSEC

Visual pages (15 total): V1-V15 穿插在文字頁間
```

**45 頁完整映射表**：

| New # | 類型 | 內容 / V# |
|------:|------|----------|
| 01-05 | text | Cover / Theme / Map / Why / Architecture |
| 06 | visual | V1 攻擊故事 |
| 07 | text | SID |
| 08 | visual | V2 SID 解剖 |
| 09-11 | text | Security Descriptor / DACL vs SACL / ACL |
| 12 | visual | V3 ACL 匹配 |
| 13 | text | Part 1 Summary |
| 14 | visual | V4 三句口訣 |
| 15-18 | text | Share / Share Perm / NTFS Perm / vs |
| 19 | visual | V5 Effective 交集 |
| 20-21 | text | Effective / Case |
| 22 | visual | V6 財務案例漫畫 |
| 23-27 | text | Best / Why Audit / Audit Policy / Local Policy / LSDOU |
| 28 | visual | V7 LSDOU 階梯 |
| 29-30 | text | Windows Security / Defender |
| 31 | visual | V8 Defender 雜誌 |
| 32 | text | UAC |
| 33 | visual | V9 UAC 藍圖 |
| 34 | text | Credential Guard |
| 35 | visual | V10 VBS 剖面 |
| 36 | text | Firewall |
| 37 | visual | V11 三 Profile 像素 |
| 38-39 | text | Inbound/Outbound / PKI |
| 40 | visual | V12 簽章驗章 |
| 41 | text | AD CS |
| 42 | visual | V13 信任鏈 |
| 43 | visual | V14 DNSSEC 鎖鏈 |
| 44 | text | DNSSEC 結論 |
| 45 | visual | V15 史詩結尾 |

**Part 點綴色（B&W 背景單色）**：
- opening: 青藍 cyan
- part 1: 寶藍 sapphire
- part 2: 紫羅蘭 violet
- part 3: 琥珀 amber
- part 4: 毒綠 toxic green
- part 5: 緋紅 crimson

---

## 四、Codex 圖生成 Prompt 範本

### 4.1 共用包裝（防止 dedup）

```bash
codex exec -C "$(pwd)" -s workspace-write --skip-git-repo-check \
  "SEED-X${RANDOM}Y${RANDOM}Z${RANDOM}. <YOUR_PROMPT>. 1536x1024 horizontal. Save to ./XX.png"
```

> **底層原因**：codex 對相似 prompt 會 dedup 回同一張圖。防範手段：
> 1. 開頭加 `SEED-X${RANDOM}Y${RANDOM}Z${RANDOM}` 三段隨機 noise
> 2. 結尾加 `NOT <style A>, NOT <style B>, NOT <style C>` 明確排除
> 3. 第 2 次 retry 跑單張（不並行），場景描述要徹底重寫

### 4.2 全頁視覺頁 — 15 風格完整 Prompt

每頁配獨立風格，避免單調。**完整 prompt 包含 SEED + 場景 + NOT 排除**：

| # | 風格 | 完整 codex prompt（直接複製改場景即可）|
|---|------|----------------------------------------|
| V1 | 黑白漫畫 | `4-panel black and white manga comic strip in Adrian Tomine + Daniel Clowes indie style. <SCENE 4 panels>. Minimal precise ink lines, halftone shading, cinematic black and white, single RED accent on alarm only. NO photographic realism. NO pixel art.` |
| V2 | 手繪黑板 | `Hand-drawn chalkboard educational diagram on dark green slate, white chalk plus colored chalk accents (yellow, pink). <TITLE chalk lettering>. <ANNOTATIONS curly arrows>. Slight chalk dust, classroom feel.` |
| V3 | Isometric Flow | `Isometric flow chart 30-degree axonometric projection, soft pastel palette (lavender, mint, peach, cream). <STACKED CARDS with icons>. Modern flat-3D vector, soft drop shadows, dribbble-quality.` |
| V4 | 編輯海報 | `Editorial poster design, magazine spread style, tactile paper texture. <TYPOGRAPHIC LAYERS>. Bold mixed sans+serif Chinese, hand-torn paper strips, ink stamps. Cream paper + navy ink + single red accent. Wabi-sabi imperfect.` |
| V5 | 等距 3D | `Isometric 3D infographic. <TWO STACKED OBJECTS labels A and B>. Soft gradient lighting, dark navy bg + technical grid + neon accent lines. Modern flat-3D vector, ultra clean.` |
| V6 | 彩色漫畫 | `3-panel modern color comic strip with speech bubbles, Studio Trigger meets New Yorker. <PANEL 1 dialogue>. <PANEL 2 action>. <PANEL 3 result split>. Bright contemporary palette: teal, coral, mustard, cream.` |
| V7 | 手繪階梯 | `Hand-drawn isometric staircase with 4 steps on engineering graph paper. <LABELS in handwritten capitals>. <STICKFIGURE climbing>. Graphite pencil + colored pencil shading, cross-hatching, architecture sketchbook aesthetic.` |
| V8 | 雜誌 | `Editorial magazine spread infographic, Bloomberg Businessweek aesthetic. <TIMELINE 4 phases>. Custom geometric numerals, mixed sans-serif weights, abstract data viz, stark black/off-white/electric yellow.` |
| V9 | 藍圖 | `Technical blueprint drawing on deep navy paper, white CAD-style precise lines, engineering schematic. <DIAGRAM splits A and B>. Annotation arrows, dimension marks, monospaced labels. NASA technical drawing meets cyberpunk circuit.` |
| V10 | 剖面 | `Architectural cross-section cutaway diagram, museum exhibition style. <3 STACKED LAYERS top/middle/bottom>. <ISOLATED CORE in lowest layer with shield>. Detailed line work, soft watercolor wash fills.` |
| V11 | 像素藝術 | `Pixel art 16-bit retro SNES game style, triptych composition. <SCENE 1: domain office>. <SCENE 2: private home>. <SCENE 3: public cafe>. Each with character + colored shield. Limited 32-color palette per scene, dithered, CRT scanline overlay.` |
| V12 | 抽象密碼 | `Abstract macro photography. <TWO INTERLOCKING GEOMETRIC OBJECTS keys/gears>. Volumetric light beam creating <HOLOGRAPHIC SEAL center>. Brushed metal textures, dramatic chiaroscuro, dark cosmic background.` |
| V13 | 金箔 organigram | `Luxury gold foil line art on deep cream paper, royal stationery aesthetic. <TIER 1 crown emblem>. <TIER 2 connected nodes>. <TIER 3 leaf icons>. Elegant filigree connecting lines, embossed metallic feel.` |
| V14 | 水彩鎖鏈 | `Delicate watercolor illustration + ink line work. <CHAIN of golden ornate locks linking horizontally>. <Each lock with key emblem>. Misty atmospheric soft pastel background. Storybook illustration meets cryptography.` |
| V15 | 史詩結尾 | `Studio Ghibli style epic painterly illustration, golden hour cinematic light. <MASSIVE STRUCTURE glowing center>. <7 CONCENTRIC RINGS labeled>. <HERO CHARACTER at base>. Atmospheric perspective, warm rim lighting, Mononoke aesthetic.` |

**通用收尾**（每張都加）：
```
... 1536x1024 horizontal landscape. NO text in image (unless prompt says so).
Cinematic wide composition. Save to ./vXX-<name>.png
```

### 4.3 Part 背景 Prompt — B&W 漫畫 + 單色點綴

統一公式：

```
SEED-X${RANDOM}Y${RANDOM}Z${RANDOM}.
Generate a BLACK-AND-WHITE INK MANGA panel illustration with EXACTLY ONE color accent.

<SCENE：包含人物、物件、空間關係>

The ONLY color is <ACCENT_COLOR> — appearing in <點綴元素列表>.
Everything else pure black, white, and gray.

Heavy ink linework, halftone screentone shading dots, indie graphic novel aesthetic
blending Adrian Tomine + Charles Burns + Frank Miller.
NO photographic realism. NO pixel art. NO 3D render.
Cinematic wide composition.

Leave negative space <方位 left/right/bottom/top> for text overlay placement.

1536x1024 landscape. Save to ./bg-<name>.png
```

**6 個 Part bg 場景對照表**：

| Part | 點綴色 | 場景描述 |
|------|--------|---------|
| opening | cyan blue | a massive server tower silhouetted at center, surrounded by faint concentric defense barrier rings, with shadowy hooded figures approaching from edges |
| part 1 | sapphire | anthropomorphic ID badges and fingerprint stamps floating in misty void, magnifying glass examining an SID string at center |
| part 2 | violet | two massive ornate gates side by side guarding a file vault corridor, with silhouettes of shadow figures passing between them carrying folders |
| part 3 | amber | a detective figure in fedora crouched over an unrolled long log scroll under a single overhead pendant lamp, surrounded by floating clock faces |
| part 4 | toxic green | an armored defender knight raising a hexagonal shield against incoming swarms of malware bug creatures, fire-wall energy field crackling behind |
| part 5 | crimson | a three-tier ceremonial dais with crowned ROOT CA on top throne, two ISSUING CA on middle tier, scrolls cascading down stone steps |

---

## 五、CSS 關鍵塊

### 5.1 Slide 容器 + 背景圖系統

```css
.slide {
  position: absolute; inset: 0;
  padding: 56px 80px;
  display: flex; flex-direction: column;
  opacity: 0; pointer-events: none;
  overflow: hidden;
  isolation: isolate;       /* 創建獨立 stacking context */
  transition: opacity 600ms cubic-bezier(0.16, 1, 0.3, 1);
}
.slide.active { opacity: 1; pointer-events: auto; z-index: 2; }

.slidebg {
  position: absolute; inset: 0;
  width: 100%; height: 100%;
  object-fit: cover; object-position: center;
  opacity: 0;
  z-index: -2;
  pointer-events: none;
  transition: opacity 1100ms ease 200ms;
}
.slide.active .slidebg { opacity: 0.62; }  /* B&W 漫畫專用 */

.slide.themed::before {
  content: '';
  position: absolute; inset: 0;
  background:
    radial-gradient(900px 600px at 78% -10%, rgba(0,212,255,0.05), transparent 60%),
    linear-gradient(180deg, rgba(7,9,15,0.28) 0%, rgba(7,9,15,0.62) 100%);
  z-index: -1;
  pointer-events: none;
}
```

### 5.2 視覺頁 Full-Bleed Layout

```css
.slide.visual { padding: 0; overflow: hidden; background: var(--bg); }
.slide.visual .vimg {
  position: absolute; inset: 0;
  width: 100%; height: 100%;
  object-fit: cover;
  z-index: 0;
  opacity: 0;
  transform: scale(1.04);
  transition: opacity 900ms ease, transform 1400ms ease;
}
.slide.visual.active .vimg { opacity: 1; transform: scale(1); }

.slide.visual .vshade {
  position: absolute; inset: 0; z-index: 1;
  background: linear-gradient(180deg, rgba(7,9,15,0.55), transparent 30%, transparent 55%, rgba(7,9,15,0.88));
}
.slide.visual .vcap {
  position: absolute; left: 80px; bottom: 80px; z-index: 3;
  max-width: 620px; padding: 22px 28px;
  background: rgba(10,14,26,0.72);
  backdrop-filter: blur(18px) saturate(160%);
  border: 1px solid rgba(255,255,255,0.10);
  border-radius: 16px;
}
```

### 5.3 手機 RWD（@media max-width: 720px）

```css
@media (max-width: 720px) {
  .slide {
    position: relative; inset: auto;
    min-height: 100dvh;
    opacity: 1 !important;
    overflow: visible;
  }
  /* grid 攤平單欄 */
  .two, .three, .four, .four.row4, .sp {
    grid-template-columns: 1fr !important;
    gap: 12px;
  }
  .flow { flex-direction: column; }
  .vs { grid-template-columns: 1fr; }

  /* bg 不 gate by active class */
  .slidebg { opacity: 0.62 !important; transition: none; }

  /* visual page 圖也要強制顯示 */
  .slide.visual .vimg {
    opacity: 1 !important; transform: none !important;
  }
  .chip::after { width: 100% !important; }
}
```

---

## 六、HTML 結構模板

### 6.1 文字頁

```html
<section class="slide" data-i="N">
  <div class="strip reveal">
    <div class="left"><span class="dot"></span><span>part XX · 標題</span></div>
    <div class="pageno">NN / TOTAL</div>
  </div>
  <div class="content">
    <div class="eyebrow reveal">SECTION TAG</div>
    <h2 class="title reveal d1">主標題 + <span class="grad-text">漸層字</span></h2>
    <!-- 卡片 / grid / table 等 -->
  </div>
</section>
```

### 6.2 視覺頁

```html
<section class="slide visual" data-i="N">
  <img class="vimg" src="book5-images/vXX-name.png" alt="" loading="lazy" decoding="async" />
  <div class="vshade"></div>
  <div class="strip reveal">
    <div class="left"><span class="dot"></span><span>visual · 標籤</span></div>
    <div class="pageno">NN / TOTAL</div>
  </div>
  <div class="vcap reveal d2">
    <div class="vkey">V##</div>
    <h3 class="vtitle">視覺頁標題</h3>
    <p class="vbody">一行說明文字。</p>
  </div>
</section>
```

---

## 七、JS 核心

```js
const slides = Array.from(document.querySelectorAll('.slide'));
const isMobile = window.matchMedia('(max-width: 720px)').matches;

// Part bg 路由
const partOf = (n) => {
  if (n <= 5) return 'opening';
  if ([7,9,10,11,13].includes(n)) return 'part1';
  if ([15,16,17,18,20,21,23].includes(n)) return 'part2';
  if ([24,25,26,27].includes(n)) return 'part3';
  if ([29,30,32,34,36,38].includes(n)) return 'part4';
  if ([39,41,44].includes(n)) return 'part5';
  return null;
};

// 注入 bg
slides.forEach(s => {
  if (s.classList.contains('visual')) return;
  const part = partOf(parseInt(s.dataset.i, 10));
  if (!part) return;
  s.classList.add('themed');
  const bg = document.createElement('img');
  bg.className = 'slidebg';
  bg.src = `book5-images/bg-${part}.png`;
  bg.loading = 'lazy';
  bg.alt = '';
  s.insertBefore(bg, s.firstChild);
});

// IntersectionObserver lazy load
const io = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (!e.isIntersecting) return;
    const im = e.target;
    if (!im.src && im.dataset.src) im.src = im.dataset.src;
    io.unobserve(im);
  });
}, { rootMargin: '200px' });

// 桌機 keyboard + click navigation
if (!isMobile) {
  document.addEventListener('keydown', (e) => {
    if (['ArrowRight','PageDown',' '].includes(e.key)) { go(i + 1); }
    else if (['ArrowLeft','PageUp'].includes(e.key)) { go(i - 1); }
    else if (e.key === 'Home') go(0);
    else if (e.key === 'End') go(total - 1);
  });
}

function go(n) {
  i = Math.max(0, Math.min(total - 1, n));
  slides.forEach((s, idx) => s.classList.toggle('active', idx === i));
  // update progress + pageno
}
```

---

## 八、可複製腳本庫（這次踩坑後固化的工具鏈）

### 8.1 並行生 N 張視覺頁

```bash
#!/bin/bash
# launch-visuals.sh - 並行 15 個 codex exec
cd /your/project/book5-images
mkdir -p logs

gen() {
  local idx="$1"; local prompt="$2"
  echo "[$(date +%H:%M:%S) START $idx]" >> logs/visuals.log
  codex exec -C "$(pwd)" -s workspace-write --skip-git-repo-check \
    "SEED-X${RANDOM}Y${RANDOM}Z${RANDOM}. $prompt 1536x1024 horizontal. Save to ./${idx}.png" \
    >"logs/${idx}.log" 2>&1
  echo "[$(date +%H:%M:%S) DONE  $idx]" >> logs/visuals.log
}

gen v01-name "<完整 prompt>" &
gen v02-name "<完整 prompt>" &
# ... 15 行 ...
gen v15-name "<完整 prompt>" &

wait
echo "[$(date +%H:%M:%S) ALL DONE]" >> logs/visuals.log
```

**啟動**：`bash launch-visuals.sh &` （背景跑 ~10-15 min）

### 8.2 並行生 6 張 Part 背景

```bash
#!/bin/bash
# launch-bgs.sh - 並行 6 個 B&W 漫畫背景
cd /your/project/book5-images

gen() {
  local idx="$1"; local prompt="$2"
  codex exec -C "$(pwd)" -s workspace-write --skip-git-repo-check \
    "SEED-X${RANDOM}Y${RANDOM}Z${RANDOM}. Generate a BLACK-AND-WHITE INK MANGA panel illustration with EXACTLY ONE color accent. $prompt Heavy ink linework, halftone screentone, indie graphic novel aesthetic (Adrian Tomine + Charles Burns). NO photographic realism. NO pixel art. NO 3D. 1536x1024 landscape. Save to ./${idx}.png" \
    >"logs/${idx}.log" 2>&1
}

gen bg-opening "<scene 1>. The ONLY color is cyan blue — appearing in <accents>. Leave negative space left." &
gen bg-part1 "<scene 2>. The ONLY color is sapphire blue — ..." &
# ... 6 行 ...

wait
```

### 8.3 md5 dedup 驗證（codex 必踩坑）

```bash
cd /your/project/book5-images

# 列所有 hash
md5sum *.png | awk '{print $2, substr($1,1,8)}'

# 找重複（這行**必須**為空）
md5sum *.png | awk '{print $1}' | sort | uniq -d

# 找哪些檔案是 dup pair
md5sum *.png | sort | awk 'p==$1{print prev"\n"$0} {p=$1; prev=$0}'
```

### 8.4 重做 dup（一次只跑一張，加 NOT 排除 + 強差異化場景）

```bash
rm dup1.png dup2.png

# 序列跑（不並行），完全不同的場景描述
codex exec -C "$(pwd)" -s workspace-write --skip-git-repo-check \
  "SEED-X${RANDOM}Y${RANDOM}Z${RANDOM}. <完全不同的場景重寫>. NOT <被誤跑的風格>. NOT photographic. 1536x1024. Save to ./dup1.png"

# 等第一張完成，再跑第二張
codex exec ... "SEED-X${RANDOM}... <另一個完全不同的場景>. NOT <...>"
```

### 8.5 Python 重構：30 文字頁 → 45 頁（插 15 視覺頁 + 重編號）

```python
# restructure-deck.py
import io, re

PATH = 'book5-windows-server-security.html'

with io.open(PATH, 'r', encoding='utf-8') as f:
    html = f.read()

# 找全部 30 個 section
sect_re = re.compile(r'(<section class="slide(?:\s+[^"]*)?" data-i="(\d+)">.*?</section>)', re.DOTALL)
matches = list(sect_re.finditer(html))
assert len(matches) == 30
old_blocks = {int(m.group(2)): m.group(1) for m in matches}

# 視覺頁定義：new_pos -> (vkey, filename, eyebrow, title, caption)
visuals = {
    6:  ('V1', 'v01-name.png', 'visual · 標籤', '視覺頁標題', '一行說明'),
    8:  ('V2', 'v02-name.png', '...', '...', '...'),
    # ... 15 行 ...
    45: ('V15','v15-finale.png', 'visual · 結尾', '...', '...'),
}

# 新位置 → 舊位置映射（跳過視覺頁的位置）
new_to_old = {}
old_idx = 1
for new_idx in range(1, 46):
    if new_idx in visuals:
        continue
    new_to_old[new_idx] = old_idx
    old_idx += 1

def render_text(new_i, old_i):
    block = old_blocks[old_i]
    block = re.sub(r'data-i="\d+"', f'data-i="{new_i}"', block, count=1)
    pad = f'{new_i:02d}'
    block = re.sub(r'(\d{2}) / 30', f'{pad} / 45', block)
    return block

def render_visual(new_i, spec):
    vkey, fname, eyebrow, title, caption = spec
    pad = f'{new_i:02d}'
    return f'''<section class="slide visual" data-i="{new_i}">
  <img class="vimg" src="book5-images/{fname}" loading="lazy" alt="" />
  <div class="vshade"></div>
  <div class="strip reveal">
    <div class="left"><span class="dot"></span><span>{eyebrow}</span></div>
    <div class="pageno">{pad} / 45</div>
  </div>
  <div class="vcap reveal d2">
    <div class="vkey">{vkey}</div>
    <h3 class="vtitle">{title}</h3>
    <p class="vbody">{caption}</p>
  </div>
</section>'''

new_blocks = []
for new_i in range(1, 46):
    if new_i in visuals:
        new_blocks.append(render_visual(new_i, visuals[new_i]))
    else:
        new_blocks.append(render_text(new_i, new_to_old[new_i]))

new_deck_inner = '\n\n'.join(new_blocks)

# 替換 <div class="deck"> 內部
deck_re = re.compile(r'(<div class="deck" id="deck">)(.*?)(\n</div>\n\n<!-- HUD)', re.DOTALL)
m = deck_re.search(html)
html = html[:m.start(2)] + '\n\n' + new_deck_inner + '\n' + html[m.end(2):]

# HUD total 更新
html = html.replace('<span id="tot">30</span>', '<span id="tot">45</span>')

with io.open(PATH, 'w', encoding='utf-8') as f:
    f.write(html)
print(f'OK — built 45 slides')
```

### 8.6 GitHub Pages 從零部署

```bash
cd /your/project/book5-deck
git init -b main
git add .
git -c user.email=you@local -c user.name=you commit -q -m "feat: initial deck"

# 建 public repo 同時 push
gh repo create your-repo-name --public --source=. --push \
  --description "..."

# 啟用 Pages（注意：endpoint 不要前置 slash）
gh api -X POST repos/USER/REPO/pages \
  -f "source[branch]=main" -f "source[path]=/"
```

### 8.7 等 Pages build 完成 + 驗證

```bash
# Monitor pattern：等到 status = built 為止
until s=$(gh api repos/USER/REPO/pages/builds/latest 2>/dev/null \
  | python -c "import sys,json;d=json.load(sys.stdin);print(d.get('status'),(d.get('commit') or '')[:7])"); \
  echo "$s" | grep -qE 'built|errored'; do
  echo "$s @ $(date +%H:%M:%S)"
  sleep 12
done
echo "FINAL $s"

# 驗 HTTP + 抓 image
curl -sI "https://USER.github.io/REPO/?cb=$(date +%s)" | head -1
curl -sI "https://USER.github.io/REPO/book5-images/bg-opening.png?cb=$(date +%s)" | head -1
```

### 8.8 線上 vs local 內容對齊驗證

```bash
# 算線上實際 hash
for n in opening part1 part2 part3 part4 part5; do
  hash=$(curl -s "https://USER.github.io/REPO/book5-images/bg-${n}.png?cb=$(date +%s%N)" | md5sum | awk '{print substr($1,1,8)}')
  echo "bg-$n live: $hash"
done

# 與 local 對比
md5sum book5-images/bg-*.png | awk '{print $2, substr($1,1,8)}'
```

---

## 九、常見坑 & 解法

| 症狀 | 根因 | 解法 |
|------|------|------|
| codex 多張圖 hash 相同 | API dedup | `SEED-X${RANDOM}Y${RANDOM}Z${RANDOM}` + `NOT <style>` |
| codex retry 又同樣 dup | 並行跑相似 prompt | 改序列 + 完全不同的場景描述 |
| 灰文字看不清 | `--muted: #8a94ad` 太暗 | 提亮到 `#c8d2e4` |
| bg 看起來太淡 | `opacity: 0.28` | 改 `0.62` + overlay 變薄到 28% |
| 視覺頁切換時下面 cover 透出 | 沒設 stacking context | `.slide { isolation: isolate }` + `.slide.active { z-index: 2 }` + `.slide.visual { background: var(--bg) }` |
| 手機切到滾動模式 visual 圖不見 | `.vimg` 還 gated by `.active` | mobile media query `.vimg { opacity: 1 !important }` |
| 圖片預載入 mobile 卡死 | 30+ 張同步載入 60MB | IntersectionObserver + `rootMargin: 200px` |
| GitHub Pages 看不到新 | 瀏覽器 cache | `?cb=<commit-hash>` 或 Ctrl+Shift+R |
| `gh api` endpoint 報錯 | shell 把 `/repos/...` 改路徑 | 命令省略前置 slash：`gh api repos/...` |
| navigate 工具吃不下 file:// | 強制加 `https://` | 啟本機 `python -m http.server 8765` |
| 視覺頁字級在 dark bg 上糊 | vcap 沒設 backdrop-filter | `backdrop-filter: blur(18px) saturate(160%)` |
| 標題在背景圖上對比不夠 | bare 文字直接在 bg 上 | 用 `.card` / `.vcap` 包，或加 `text-shadow` |

---

## 十、漫畫背景 Deep Dive（這次最有效的視覺武器）

### 10.1 為什麼 B&W 漫畫公式有效（5 個關鍵字句）

| 關鍵字 | 作用 |
|--------|------|
| `EXACTLY ONE color accent` | 強制 codex 走 duotone、不要亂塗彩色 |
| `Heavy ink linework + halftone screentone` | 明確指定 manga 印刷風格、排除水彩油畫 |
| `Adrian Tomine + Charles Burns + Frank Miller` | 三位漫畫家當參考，codex 知道你要的版本 |
| `NO photographic realism, NO pixel art` | 排除攝影風與像素藝術（容易誤跑）|
| `Leave negative space <方位>` | 預留文字 overlay 區域 |

### 10.2 跨領域套用範例（換主題不換結構）

公式不變，**只換場景與點綴色**：

**金融簡報 — 投資組合風險**
```
場景: dollar coins + stock chart graphs floating around magnifying glass
       examining portfolio document at center
點綴色: emerald green
```

**醫療簡報 — 病歷追蹤**
```
場景: anthropomorphic medical chart pages floating with stethoscope
       wrapping around magnifying glass examining patient ID
點綴色: medical red
```

**電商簡報 — 訂單流程**
```
場景: cardboard packages floating with arrow trails connecting through
       sorting hub at center, clipboard tracking each item
點綴色: highlighter orange
```

**法律簡報 — 條款審閱**
```
場景: parchment scrolls scattered around antique stamp pressing on
       contract document, gavel resting beside
點綴色: regal gold
```

### 10.3 漫畫專用 CSS（與一般氛圍照不同）

- `opacity: 0.62`（**不是** 氛圍照的 0.28）── 漫畫 ink 對比強，要夠濃才看得出漫畫感
- 上薄下濃漸層（28%→62%）── 上半留漫畫風華麗、下半暗一點讓內文卡片清晰
- **不要** `mix-blend-mode: screen` ── 對 B&W 圖會把白色吃掉

---

## 十一、失敗版本復盤（事後 RCA）

### 11.1 第一輪：Q 版可愛角落小圖 ❌

**做法**：30 張 1254×1254 Q 版可愛角色（小機器人、騎士、貓偵探）放在每頁角落 140-220px。

**為什麼失敗**：
- 視覺裝飾性 >> 資訊性，跟簡報主題（伺服器安全）的調性對沖
- 28% opacity 看起來像浮水印，又太大蓋到文字
- 「萌」風格對教學內容稀釋專業感

**抽手**：3 輪縮小（280px → 200px → 140px）後完全砍掉。

**教訓**：**裝飾性人物不該當每頁背景**。除非整套設計就是 children's book 風格，否則放開頭/結尾單頁即可。

### 11.2 第二輪：彩色氛圍照背景 ❌

**做法**：每 Part 一張寫實風氛圍照（紫色檔案走廊、琥珀機房、藍色格網）。

**為什麼失敗**：
- 攝影風太「重」，跟編輯設計風的版型有 disconnect
- 28% opacity 下細節糊掉，但提到 50% 又跟標題搶版面
- 6 張之間風格不夠統一（光線氛圍各異）

**抽手**：用 B&W 漫畫 + 單色點綴整套換掉。

**教訓**：**全章節背景需要極致風格統一**。寫實攝影難統一光線色溫，**插畫類**（漫畫 / 手繪 / 等距）更好控。

### 11.3 第三輪：B&W 漫畫 + 單色點綴 ✅

**為什麼成功**：
- 統一語言：所有 Part 都是 ink + halftone + 單色，6 張像「同一本漫畫」
- 對比強：黑白 ink 給 0.62 opacity 仍清晰
- 內容相關：場景描述對應該 Part 主題（badges / gates / detective / knight / throne）
- 點綴色當 Part 識別：cyan / sapphire / violet / amber / green / crimson 一眼分章節

---

## 十二、最佳實踐 SOP

### 啟動新簡報

1. **抓大綱**：用戶提供內容 → 列出 30 個文字頁 outline
2. **規劃視覺頁**：從 outline 找 12-15 個「高槓桿概念」配獨立風格視覺頁（§4.2）
3. **生圖（並行）**：寫 `launch-visuals.sh`（§8.1）並行跑 codex exec，~10-15 min
4. **驗 unique**：`md5sum *.png | awk '{print $1}' | sort | uniq -d` 必須空（§8.3）
5. **重做 dups**：序列跑 + 強差異化（§8.4）
6. **HTML 骨架**：寫 CSS + JS（§5, §7）+ 30 文字頁初版
7. **Python 重構**：跑 `restructure-deck.py`（§8.5）把 30 → 45 頁
8. **生 Part 背景**：跑 `launch-bgs.sh`（§8.2）6 張 B&W 漫畫
9. **本地測試**：`python -m http.server 8765` + Chrome 抽 5-8 頁截圖驗
10. **推 GitHub**：`gh repo create --public --source=. --push` + 啟用 Pages（§8.6）
11. **CDN 等待**：Monitor `built` 狀態 + 驗 HTTP + image hash（§8.7-8.8）

### 迭代調整速查

- **字級不夠大**：整體 +20%（h1: 88→108, h2: 64→76, 卡片內文 15→17）
- **顏色太暗**：`--muted` `#8a94ad` → `#c8d2e4`
- **背景太淡**：`opacity: 0.28 → 0.62` + overlay 上薄下濃 28%→62%
- **圖蓋住文字**：visual page 加 `vshade` + 縮小到 corner badge（top-right / bottom-left）
- **手機看不了**：補 `@media (max-width: 720px)` 把 grid 攤平單欄
- **手機 visual 不見**：mobile media query `.vimg { opacity: 1 !important }`

---

## 十三、下次直接用

把這份 PROMPT-TEMPLATE.md 丟給 Claude 並說：

```
用 https://github.com/Reese-max/book5-windows-server-2022/blob/main/PROMPT-TEMPLATE.md
這個模板，主題是「<新主題>」，大綱如下：

<貼你的大綱>

走完整 11 步 SOP，最後給我 GitHub Pages URL。
```

Claude 會自動：
1. 拆 30 文字頁 outline
2. 規劃 15 個視覺頁（套 §4.2 風格表）
3. 並行 codex 生圖 + md5 驗 unique（必要時重做 dup）
4. Python `restructure-deck.py` 灌 HTML
5. 並行生 6 張 B&W 漫畫背景
6. push GitHub + 啟用 Pages
7. 等 CDN propagation
8. 給你公開 URL

---

> 因為信任所以簡單：這份模板已從 Book 5 實戰（三輪失敗 → 一輪成功）固化完成。
> 下次跨主題直接複製 §4 prompt + §8 腳本，不用再踩 codex dedup / opacity / cache / mobile 等坑。
