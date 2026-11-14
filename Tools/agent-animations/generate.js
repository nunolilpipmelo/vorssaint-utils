// Generates the 5 × 5 dot-matrix animations for Vorssaint's Dynamic Island.
// Run: node generate.js   → writes thinking-*.json, question.json, done.json and preview.html
// Cell values: "1" = dot on, "2" = dimmer dot, "0" = off.
const fs = require("fs");
const path = require("path");
const OUT = __dirname;
const N = 5;

const clamp = v => (v < 0 ? 0 : v > 1 ? 1 : v);
const smooth = (a, b, x) => { const t = clamp((x - a) / (b - a)); return t * t * (3 - 2 * t); };
const blank = () => Array.from({ length: N }, () => Array(N).fill(0));
const toRows = g => g.map(r => r.join(""));
const quant = v => (v >= 0.6 ? 1 : v >= 0.22 ? 2 : 0);
const brightness = c => (c === 1 ? 1 : c === 2 ? 0.5 : 0);
const set = (g, x, y, v) => { // keeps the brighter value when two things overlap
  if (x < 0 || y < 0 || x >= N || y >= N || v === 0) return;
  if (brightness(v) > brightness(g[y][x])) g[y][x] = v;
};
const fromBitmap = rows => rows.map(r => [...r].map(ch => (ch === "#" ? 1 : 0)));

// ---------- Thinking variants ----------

// Bloom: fills out from the centre, hollows to an outline, corners fade as the next begins.
function bloom() {
  const fps = 10, period = 2.0, speed = 2.7, width = 2.9, count = fps * period;
  const frames = [];
  for (let f = 0; f < count; f++) {
    const t = f / fps, g = blank();
    for (let y = 0; y < N; y++) for (let x = 0; x < N; x++) {
      const r = Math.hypot(x - 2, y - 2);
      let v = 0;
      for (let k = 0; k < 3; k++) {
        const outer = (t + k * period) * speed, inner = outer - width;
        v = Math.max(v, smooth(outer + 0.15, outer - 0.55, r) * smooth(inner - 0.55, inner + 0.15, r));
      }
      g[y][x] = quant(v);
    }
    frames.push(toRows(g));
  }
  // Still: the rounded fill (5 × 5 without corners), the most recognisable moment.
  const still = frames.findIndex(fr => fr.join("") === "0111011111111111111101110");
  return { name: "Bloom", fps, frames, still: still >= 0 ? still : pickClosest(frames, 21) };
}
function pickClosest(frames, ones) {
  let best = 0, bestD = 1e9;
  frames.forEach((fr, i) => { const c = fr.join("").split("1").length - 1; const d = Math.abs(c - ones); if (d < bestD) { bestD = d; best = i; } });
  return best;
}

// Spiral order of the cells, top-left corner inwards to the centre.
const SPIRAL = (() => {
  const order = [];
  let top = 0, left = 0, bottom = N - 1, right = N - 1;
  while (top <= bottom && left <= right) {
    for (let x = left; x <= right; x++) order.push([x, top]);
    top++;
    for (let y = top; y <= bottom; y++) order.push([right, y]);
    right--;
    if (top <= bottom) { for (let x = right; x >= left; x--) order.push([x, bottom]); bottom--; }
    if (left <= right) { for (let y = bottom; y >= top; y--) order.push([left, y]); left++; }
  }
  return order; // 25 cells
})();

// Snake: a 4-dot tail winds along the spiral into the centre; the next starts at the corner as it arrives.
function snake() {
  const fps = 12, L = SPIRAL.length, frames = [];
  const tail = [1, 1, 2, 2];
  for (let f = 0; f < L; f++) {
    const g = blank();
    tail.forEach((v, k) => { const [x, y] = SPIRAL[(f - k + L) % L]; set(g, x, y, v); });
    frames.push(toRows(g));
  }
  return { name: "Snake", fps, frames, still: 9 };
}

// Sweep: a diagonal band moves corner to corner and back.
function sweep() {
  const fps = 10, frames = [];
  const positions = [];
  for (let p = -5; p <= 5; p++) positions.push(p);
  for (let p = 4; p >= -4; p--) positions.push(p); // 11 + 9 = 20 frames, seamless ping-pong
  for (const p of positions) {
    const g = blank();
    for (let y = 0; y < N; y++) for (let x = 0; x < N; x++) {
      const d = Math.abs((x - 2) + (y - 2) - p);
      g[y][x] = d === 0 ? 1 : d === 1 ? 2 : 0;
    }
    frames.push(toRows(g));
  }
  return { name: "Sweep", fps, frames, still: 5 };
}

// Ring paths, clockwise from the top-left.
function ring(lo, hi) {
  const cells = [];
  for (let x = lo; x <= hi; x++) cells.push([x, lo]);
  for (let y = lo + 1; y <= hi; y++) cells.push([hi, y]);
  for (let x = hi - 1; x >= lo; x--) cells.push([x, hi]);
  for (let y = hi - 1; y > lo; y--) cells.push([lo, y]);
  return cells;
}
const OUTER = ring(0, 4); // 16 cells
const INNER = ring(1, 3); // 8 cells

// Gears: a comet runs clockwise round the outer ring, a dim one turns the other way inside, centre breathes.
function gears() {
  const fps = 10, count = 16, frames = [];
  for (let f = 0; f < count; f++) {
    const g = blank();
    [1, 1, 2].forEach((v, k) => { const [x, y] = OUTER[(f - k + 16) % 16]; set(g, x, y, v); });
    const ih = (8 - Math.floor(f / 2)) % 8; // one step every 2 frames, anticlockwise
    [2, 2].forEach((v, k) => { const [x, y] = INNER[(ih + k) % 8]; set(g, x, y, v); });
    g[2][2] = f < 8 ? 1 : 2;
    frames.push(toRows(g));
  }
  return { name: "Gears", fps, frames, still: 0 };
}

// Equalizer: five solid columns rise and fall; every wave repeats exactly over the 2 s loop.
function equalizer() {
  const fps = 10, count = 20, frames = [];
  const a = [1, 2, 1, 2, 1], b = [3, 2, 3, 1, 2], pa = [0.0, 1.7, 3.4, 5.1, 0.9], pb = [2.9, 0.4, 4.4, 1.3, 3.8];
  for (let f = 0; f < count; f++) {
    const g = blank(), u = f / count;
    for (let c = 0; c < N; c++) {
      const lvl = clamp(0.5 + 0.36 * Math.sin(2 * Math.PI * a[c] * u + pa[c]) + 0.2 * Math.sin(2 * Math.PI * b[c] * u + pb[c]));
      const h = Math.max(1, Math.min(5, Math.round(1 + lvl * 4)));
      for (let k = 0; k < h; k++) g[4 - k][c] = 1;
    }
    frames.push(toRows(g));
  }
  return { name: "Equalizer", fps, frames, still: 0 };
}

// Rain: drops with a dim trail fall down each column; fast columns repeat every 1 s, slow ones every 2 s.
function rain() {
  const fps = 10, count = 20, frames = [];
  const period = [10, 20, 10, 20, 10], offset = [0, 7, 5, 14, 8];
  for (let f = 0; f < count; f++) {
    const g = blank();
    for (let c = 0; c < N; c++) {
      const step = (f + offset[c]) % period[c];
      const head = (period[c] === 10 ? step : Math.floor(step / 2)) - 2; // -2 … 7
      set(g, c, head, 1);
      set(g, c, head - 1, 2);
    }
    frames.push(toRows(g));
  }
  return { name: "Rain", fps, frames, still: 3 };
}

// Twinkle: each dot glows once per loop at its own moment (dim, on, on, dim).
function twinkle() {
  const fps = 10, count = 20, frames = [];
  const hash = (x, y) => { const s = Math.sin(x * 12.9898 + y * 78.233) * 43758.5453; return s - Math.floor(s); };
  const shape = [2, 1, 1, 2];
  for (let f = 0; f < count; f++) {
    const g = blank();
    for (let y = 0; y < N; y++) for (let x = 0; x < N; x++) {
      const h = hash(x + 7, y + 3);
      if (h < 0.35) continue;                    // about a third of the dots stay dark, so it never fills up
      const start = Math.floor(hash(y + 11, x + 5) * count);
      const k = (f - start + count) % count;
      if (k < shape.length) g[y][x] = shape[k];
    }
    frames.push(toRows(g));
  }
  return { name: "Twinkle", fps, frames, still: pickClosest(frames, 4) };
}

// ---------- Question and Done ----------

const QUESTION = fromBitmap([
  ".###.",
  "....#",
  "..##.",
  ".....",
  "..#..",
]);
// Question: a steady "?" whose dot softly dims and returns, a slower rhythm than any thinking variant.
function question() {
  const fps = 10, frames = [];
  for (let f = 0; f < 16; f++) {
    const g = QUESTION.map(r => r.slice());
    if (f >= 10) g[4][2] = 2;
    frames.push(toRows(g));
  }
  return { name: "Question", fps, frames, still: 0 };
}

// Done: the tick draws itself dot by dot from the short stroke up the long one, then holds.
function done() {
  const fps = 12, frames = [];
  const order = [[0, 3], [1, 4], [2, 3], [3, 2], [4, 1]];
  frames.push(toRows(blank()));
  for (let i = 0; i < order.length; i++) {
    const g = blank();
    for (let j = 0; j <= i; j++) g[order[j][1]][order[j][0]] = j === i ? 2 : 1; // newest dot fades in
    frames.push(toRows(g));
  }
  const full = blank();
  order.forEach(([x, y]) => (full[y][x] = 1));
  for (let i = 0; i < 4; i++) frames.push(toRows(full));
  return { name: "Done", fps, frames, still: frames.length - 1 };
}

// ---------- Write files ----------

const thinking = [bloom(), snake(), sweep(), gears(), equalizer(), rain(), twinkle()];
const files = [];
for (const a of thinking) files.push({ file: `thinking-${a.name.toLowerCase()}.json`, data: { name: a.name, state: "thinking", grid: [N, N], fps: a.fps, loop: true, frames: a.frames, still: a.still } });
const q = question();
files.push({ file: "question.json", data: { name: q.name, state: "question", grid: [N, N], fps: q.fps, loop: true, frames: q.frames, still: q.still } });
const d = done();
files.push({ file: "done.json", data: { name: d.name, state: "done", grid: [N, N], fps: d.fps, loop: false, frames: d.frames, still: d.still } });

// Compact JSON: one frame per line so the files stay readable.
function pretty(o) {
  const frames = o.frames.map(fr => "    " + JSON.stringify(fr)).join(",\n");
  return `{\n  "name": ${JSON.stringify(o.name)},\n  "state": ${JSON.stringify(o.state)},\n  "grid": [${o.grid.join(", ")}],\n  "fps": ${o.fps},\n  "loop": ${o.loop},\n  "frames": [\n${frames}\n  ],\n  "still": ${o.still}\n}\n`;
}
for (const f of files) fs.writeFileSync(path.join(OUT, f.file), pretty(f.data));

// Preview: inject the exact JSON into the template.
const tpl = fs.readFileSync(path.join(OUT, "preview.template.html"), "utf8");
fs.writeFileSync(path.join(OUT, "preview.html"), tpl.replace("/*ANIMATIONS*/[]", JSON.stringify(files.map(f => ({ file: f.file, ...f.data })))));

console.log(files.map(f => `${f.file}: ${f.data.frames.length} frames @ ${f.data.fps} fps = ${(f.data.frames.length / f.data.fps).toFixed(2)} s, still ${f.data.still}`).join("\n"));
