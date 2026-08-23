#!/usr/bin/env bash
# analyze-repo.sh — 收集当前仓库的关键信息，供 project-showcase skill 生成网站
# 用法: bash analyze-repo.sh [repo_path]   默认当前目录
set -euo pipefail

REPO="${1:-.}"
cd "$REPO"

section() { printf '\n\033[1;36m=== %s ===\033[0m\n' "$1"; }

section "基本信息"
name=$(basename "$(pwd)")
git_origin=$(git config --get remote.origin.url 2>/dev/null || echo "无")
echo "项目名: $name"
echo "Git remote: $git_origin"

# 描述：优先 GitHub API，其次各配置文件
desc=""
if [[ "$git_origin" == *github.com* ]]; then
  slug=$(echo "$git_origin" | sed -E 's#.*github.com[:/]##; s/\.git$//')
  api_desc=$(curl -sf "https://api.github.com/repos/$slug" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin).get('description') or '')" 2>/dev/null || true)
  [[ -n "$api_desc" ]] && desc="$api_desc"
fi
[[ -z "$desc" && -f package.json ]] && desc=$(python3 -c "import json; print(json.load(open('package.json')).get('description',''))" 2>/dev/null || true)
[[ -z "$desc" && -f pyproject.toml ]] && desc=$(grep -m1 '^description' pyproject.toml 2>/dev/null | cut -d'"' -f2 || true)
echo "描述: ${desc:-（未找到，需从 README 提取）}"

section "语言构成"
if command -v git >/dev/null && git rev-parse --git-dir >/dev/null 2>&1; then
  git ls-files | awk -F. 'NF>1 {print $NF}' | sort | uniq -c | sort -rn | head -8 | \
    awk '{printf "  .%-8s %s 个文件\n", $2, $1}'
else
  echo "  （非 git 仓库，跳过）"
fi

section "项目类型探测"
for f in package.json pyproject.toml setup.py Cargo.toml go.mod pom.xml build.gradle Gemfile requirements.txt Makefile Dockerfile; do
  [[ -f "$f" ]] && echo "  发现: $f"
done

section "包管理器 / 脚本（package.json）"
if [[ -f package.json ]]; then
  python3 -c "
import json
d = json.load(open('package.json'))
print('  name:', d.get('name'))
print('  version:', d.get('version'))
print('  bin:', d.get('bin'))
scripts = d.get('scripts', {})
for k in ['dev','build','test','start']:
    if k in scripts: print(f'  script {k}:', scripts[k])
deps = {**d.get('dependencies',{}), **d.get('devDependencies',{})}
print('  依赖数:', len(deps))
"
  for lock in pnpm-lock.yaml yarn.lock package-lock.json bun.lockb; do
    [[ -f "$lock" ]] && echo "  锁文件: $lock"
  done
else
  echo "  （无 package.json）"
fi

section "README 摘要"
if [[ -f README.md ]]; then
  echo "  总行数: $(wc -l < README.md)"
  echo "  --- 前 60 行 ---"
  head -60 README.md | sed 's/^/  | /'
else
  for alt in readme.md Readme.md README.rst README; do
    [[ -f "$alt" ]] && echo "  找到: $alt（内容需手动读取）" && break
  done
  [[ -z "${alt:-}" ]] && echo "  ⚠️ 未找到 README"
fi

section "截图 / 资源目录"
for d in assets docs/images images screenshots .github/assets public static; do
  if [[ -d "$d" ]]; then
    count=$(find "$d" -maxdepth 2 \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.svg' \) 2>/dev/null | wc -l | tr -d ' ')
    [[ "$count" -gt 0 ]] && echo "  $d/ — $count 张图片:" && find "$d" -maxdepth 2 \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.gif' -o -iname '*.webp' \) 2>/dev/null | head -10 | sed 's/^/    /'
  fi
done
ls *.png *.gif *.jpg 2>/dev/null | head -5 | sed 's/^/  根目录: /' || true

section "License / 版本"
for l in LICENSE LICENSE.md LICENSE.txt; do
  [[ -f "$l" ]] && echo "  License: $(head -3 "$l" | grep -oiE 'MIT|Apache|GPL|BSD|MPL|UNLICENSE' | head -1)（$l）" && break
done
[[ -f CHANGELOG.md ]] && echo "  CHANGELOG 最新版本: $(grep -m1 -oE '[0-9]+\.[0-9]+[0-9a-z.]*' CHANGELOG.md || echo '未知')"

section "完成"
echo "以上信息仅供初筛，生成网站前请完整阅读 README。"
