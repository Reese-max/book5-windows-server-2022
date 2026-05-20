# 簡報生成 Prompt 模板（Book 5 風格）

> 從 30 → 45 頁深色 editorial-tech 簡報的完整 prompt 範本，可直接套到其他主題。

---

## 一、總體規格

```
- 總頁數: 30 文字頁 + 15 全頁視覺 = 45
- 平台: 單一自包含 HTML + JS + book5-images/*.png
- 設備支援: 桌機 (slideshow) + 手機 (scroll-stack)
- 字級: clamp(min, vw-relative, max)
- 動畫: fade-in slide + reveal stagger + bg crossfade
```

---

## 二、視覺 Design Tokens

```css
:root {
  --bg: #07090f;            /* 主背景 */
  --bg-2: #0d1220;          /* 次背景 */
  --surface: #131a2e;       /* 卡片底 */
  --border: rgba(255,255,255,0.08);
  --text: #f4f6fb;          /* 主文字（亮）*/
  --muted: #c8d2e4;         /* 副文字（淺藍灰，readability over B&W bg）*/
  --dim: #8a94ad;           /* 邊框/dim 字 */
  --accent: #00d4ff;        /* 主強調色 (cyan) */
  --accent-2: #7c5cff;      /* 副強調色 (violet) */
  --warn: #ffb547;          /* 黃色警示 */
  --danger: #ff5577;        /* 紅色警示 */
  --good: #00e89a;          /* 綠色 OK */
  --grad-1: linear-gradient(135deg, #00d4ff, #7c5cff);
}
```

**字體**:
- Display + Body: `Noto Sans TC` (700-900)
- 數字/Latin: `Space Grotesk` (500-700)
- 程式碼 / mono: `JetBrains Mono`

**字級基準**（拉大版本）:
- h1 title: `clamp(58px, 7.2vw, 108px)`
- h2 title: `clamp(44px, 5.2vw, 76px)`
- 中央問句: `clamp(56px, 7.5vw, 112px)`
- 結尾大字: `clamp(42px, 5.2vw, 72px)`
- 卡片標題: 26px / 卡片內文: 17px
- chip h4: 23px / chip p: 16px

---

## 三、章節結構 & Part 主題色

```
Opening (slides 1-5): 開場 / 提問 / 全章地圖 / 為什麼 / 架構
Part 1 (5 slides): 安全基礎 — SID, Security Descriptor, DACL/SACL, ACL
Part 2 (7 slides): 共享資源 — Share, NTFS, vs, Effective, Case
Part 3 (4 slides): 稽核 — Why audit, Audit Policy, Local Policy, LSDOU
Part 4 (6 slides): 主機/防火牆 — Windows Sec, Defender, UAC, Cred Guard, Firewall, In/Out
Part 5 (3 slides): 憑證信任 — PKI, AD CS, DNSSEC

Part 點綴色（背景單色）:
- opening: 青藍 cyan
- part 1: 寶藍 sapphire
- part 2: 紫羅蘭 violet
- part 3: 琥珀 amber
- part 4: 毒綠 toxic green
- part 5: 緋紅 crimson
```

---

## 四、Codex 圖生成 Prompt 範本

### 4.1 共用 SEED 模板（防止 dedup）

```bash
codex exec -C "$(pwd)" -s workspace-write --skip-git-repo-check \
  "SEED-X${RANDOM}Y${RANDOM}Z${RANDOM}. <YOUR_PROMPT> 1536x1024 horizontal. Save to ./XX.png"
```

> 注意：codex 會對相似 prompt dedup 回傳同樣圖。**強制差異化**靠：
> 1. 開頭加 `SEED-X{RANDOM}Y{RANDOM}Z{RANDOM}`
> 2. 結尾加 `NOT <other style>, NOT <other style>`
> 3. 第 2 次重做時跑單張（不並行）

### 4.2 全頁視覺頁 Prompt（15 風格）

每頁配獨立風格，避免單調：

| # | 主題類型 | 風格描述（複製到 codex 即可）|
|---|---------|---------------------------|
| V1 | 開場故事 | 4-panel BLACK AND WHITE manga comic strip, Adrian Tomine + Daniel Clowes indie style. Cinematic ink lines, halftone shading, single RED accent only. |
| V2 | 結構解剖 | Hand-drawn CHALKBOARD educational diagram, dark green slate, white + colored chalk, curly hand-drawn arrows, classroom feel. |
| V3 | 流程匹配 | ISOMETRIC FLOWCHART, 30-degree axonometric, soft pastel (lavender/mint/peach), modern flat-3D vector. |
| V4 | 三句口訣 | Editorial POSTER design, magazine spread, tactile paper texture, bold mixed typography (sans+serif Chinese), ink stamps, cream + navy + red. |
| V5 | 交集邏輯 | ISOMETRIC 3D infographic, translucent stacked gates, soft gradient lighting, dark navy bg + neon accents. |
| V6 | 案例漫畫 | 3-panel COLOR comic strip, Studio Trigger meets New Yorker, bright contemporary palette (teal/coral/mustard). |
| V7 | 階梯順序 | HAND-DRAWN isometric staircase on engineering graph paper, technical sketchbook by architecture student, pencil + colored pencil. |
| V8 | EDR 節奏 | Editorial MAGAZINE spread infographic, Bloomberg Businessweek style, custom geometric numerals, electric yellow accent. |
| V9 | 雙 Token | Technical BLUEPRINT on deep navy paper, white CAD-style precise lines, NASA technical drawing aesthetic. |
| V10 | 隔離剖面 | Architectural CUTAWAY diagram, museum exhibition illustration, watercolor wash + line work, vertical cross-section. |
| V11 | 三場景 | PIXEL ART 16-bit retro SNES game style, triptych composition, dithered shading, CRT scanline overlay. |
| V12 | 抽象密碼 | ABSTRACT macro photography, brushed metal interlocking keys, dramatic chiaroscuro, luxury watch ad aesthetic. |
| V13 | 信任鏈 | Luxury GOLD FOIL line art on deep cream paper, royal stationery, hierarchical tree (crown → leaves), embossed feel. |
| V14 | 簽章鏈 | Delicate WATERCOLOR illustration + ink line work, golden ornate locks, soft pastel atmospheric. |
| V15 | 史詩結尾 | Studio Ghibli EPIC painterly, golden hour cinematic light, atmospheric perspective, concentric defense rings around hero structure. |

**通用句尾**（一定要加）:
```
... 1536x1024 horizontal landscape. NO text, NO characters faces (unless prompt says otherwise). Cinematic wide composition. Save to ./vXX-<name>.png
```

### 4.3 Part 背景 Prompt（B&W manga + 單色點綴）

每張背景**統一在這條公式內**換內容：

```
Generate a BLACK-AND-WHITE INK MANGA panel illustration with EXACTLY ONE color accent.

<SCENE 描述：與該 Part 內容相關的場景，含人物/物件位置>

The ONLY color is <ACCENT_COLOR> — appearing in <點綴元素描述>.
Everything else pure black, white, and gray.

Heavy ink linework, halftone screentone shading dots, indie graphic novel aesthetic
blending Adrian Tomine + Charles Burns + Frank Miller.
NO photographic realism. Cinematic wide composition.

Leave negative space <方位> for text overlay placement.

1536x1024 landscape. Save to ./bg-<name>.png
```

**6 個 Part bg 替換範本**:

```
opening   | cyan blue   | server tower + concentric defense rings + hooded silhouettes
part 1    | sapphire    | ID badges + fingerprint stamps + magnifying glass on SID
part 2    | violet      | twin gates + file vault corridor + shadow figures
part 3    | amber       | noir detective crouched over log scroll under pendant lamp
part 4    | toxic green | armored knight + hexagonal shield vs malware swarms + firewall energy
part 5    | crimson     | three-tier ceremonial throne + scrolls + wax seals
```

---

## 五、CSS 關鍵塊（複製即可）

### 5.1 Slide 容器 + 背景圖系統

```css
.slide {
  position: absolute; inset: 0;
  padding: 56px 80px;
  display: flex; flex-direction: column;
  opacity: 0; pointer-events: none;
  overflow: hidden;
  isolation: isolate;  /* 創建 stacking context */
  transition: opacity 600ms cubic-bezier(0.16, 1, 0.3, 1);
}
.slide.active { opacity: 1; pointer-events: auto; z-index: 2; }

/* 主題背景圖 */
.slidebg {
  position: absolute; inset: 0;
  width: 100%; height: 100%;
  object-fit: cover; object-position: center;
  opacity: 0;
  z-index: -2;
  pointer-events: none;
  transition: opacity 1100ms ease 200ms;
}
.slide.active .slidebg { opacity: 0.62; }  /* B&W 漫畫要 0.62 才看得到 */

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
  background:
    linear-gradient(180deg, rgba(7,9,15,0.55), transparent 30%, transparent 55%, rgba(7,9,15,0.88));
}
.slide.visual .vcap {
  position: absolute; left: 80px; bottom: 80px; z-index: 3;
  max-width: 620px;
  padding: 22px 28px;
  background: rgba(10,14,26,0.72);
  backdrop-filter: blur(18px) saturate(160%);
  border: 1px solid rgba(255,255,255,0.10);
  border-radius: 16px;
}
```

### 5.3 手機 RWD（max-width: 720px）

```css
@media (max-width: 720px) {
  .slide {
    position: relative; inset: auto;
    min-height: 100dvh;
    opacity: 1 !important;
    overflow: visible;
  }
  /* 所有 grid layout 攤平 */
  .two, .three, .four, .sp, .vs, .flow {
    grid-template-columns: 1fr !important;
    flex-direction: column !important;
  }
  /* bg 不 gate by active class */
  .slidebg { opacity: 0.62 !important; transition: none; }
  /* visual 圖也不 gate */
  .slide.visual .vimg {
    opacity: 1 !important; transform: none !important;
  }
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
    <h2 class="title reveal d1">主標題 + <span class="grad-text">漸層強調字</span></h2>
    <!-- 內容卡片或 grid -->
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

## 七、JS 核心（slide 控制 + bg 路由 + IO lazy）

```js
const slides = Array.from(document.querySelectorAll('.slide'));
const isMobile = window.matchMedia('(max-width: 720px)').matches;

// Part bg 路由
const partOf = (n) => {
  if (n <= 5) return 'opening';
  if ([7,9,10,11,13].includes(n)) return 'part1';
  // ... 其他 part 對應
  return null;
};

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

// IntersectionObserver 延遲載入
const io = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (!e.isIntersecting) return;
    const im = e.target;
    if (!im.src && im.dataset.src) im.src = im.dataset.src;
    io.unobserve(im);
  });
}, { rootMargin: '200px' });
```

---

## 八、常見坑 & 解法（從 Book 5 實戰提煉）

| 症狀 | 根因 | 解法 |
|------|------|------|
| codex 多張圖 hash 相同 | API dedup 機制 | 每張 prompt 開頭加 `SEED-X${RANDOM}Y${RANDOM}` |
| 字級在 B&W bg 上看不清 | `--muted` 太暗 (`#8a94ad`) | 提亮到 `#c8d2e4` |
| bg 看起來太淡 | `opacity: 0.28` 不夠 | 改 0.62 + overlay 變薄 |
| 視覺頁切換時下面 cover 透出 | 沒設 `isolation: isolate` 或 `.slide.visual` 沒 opaque bg | `.slide.visual { background: var(--bg) }` |
| 手機切到滾動模式 visual 圖不見 | `.vimg` opacity 還 gated by `.active` | mobile media query 強制 `opacity: 1 !important` |
| 圖片預載入導致 mobile 卡死 | 30+ 張同步載入 60MB | 改 IntersectionObserver + `rootMargin: 200px` |
| GitHub Pages 推上去看不到 | 瀏覽器 cache | `?cb=<commit-hash>` URL 或 Ctrl+Shift+R |
| 視覺頁過渡時下層內容透出 | 過渡時兩個 slide 都半透明 | `.slide.active { z-index: 2 }` 強制疊在上層 |

---

## 九、最佳實踐 SOP

### 啟動新簡報

1. **抓大綱**: 用戶提供 4000 字內容 → 列出 30 個文字頁 outline
2. **規劃視覺頁**: 從 outline 找 12-15 個「高槓桿概念」配獨立風格視覺頁
3. **生圖（並行）**: 寫 launch.sh 並行跑 15 個 codex exec，wall time ~10-15 min
4. **驗 unique**: `md5sum *.png | awk '{print $1}' | sort | uniq -d` 必須空
5. **HTML 結構**: 先寫骨架 (CSS + JS 控制) 再用 Python script 灌 45 slide
6. **本地測試**: `python -m http.server 8765` + Chrome MCP 抽 5-8 頁截圖驗
7. **推 GitHub**: `gh repo create --public --source=. --push` + 啟用 Pages
8. **CDN 等待**: monitor `gh api repos/.../pages/builds/latest` 等 `built`

### 迭代調整

- **字級不夠大**: 整體 +20% (h1: 88→108, h2: 64→76)
- **顏色太暗**: 提亮 `--muted` 從 `#8a94ad` → `#c8d2e4`
- **背景太淡**: opacity `0.28 → 0.62` + overlay 28%→62%
- **圖蓋住文字**: visual page `bottom-right`/`top-right` 變體位置調整
- **手機看不了**: 補 `@media (max-width: 720px)` 把 grid 攤平單欄 + opacity force

---

## 十、下次直接用

把這份 PROMPT-TEMPLATE.md 丟給 Claude 並說：

> 用這個模板，主題是「<新主題>」，大綱如下：
> ```
> <貼你的大綱>
> ```
> 走完整 8 步 SOP，最後給我 GitHub Pages URL。

Claude 會自動：codex 並行生圖 → HTML 組裝 → 推 GitHub → 驗證 → 給你 URL。

