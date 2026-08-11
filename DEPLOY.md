# Make it live — 4 commands

## 1. Create the repo (once)
On GitHub: New repository → name `my-ai-architecture-project` → Public → **do not** initialize with README.
(Or with GitHub CLI: `gh repo create kogunlowo123/my-ai-architecture-project --public`)

## 2. Push (from the unzipped folder — git history is already committed)
```bash
cd my-ai-architecture-project
git push -u origin main
```
If prompted, authenticate with a Personal Access Token (Settings → Developer settings → Tokens, `repo` scope) or `gh auth login`.

## 3. Enable GitHub Pages
Repo → Settings → Pages → Source: **GitHub Actions**.
The included `.github/workflows/pages.yml` deploys `web/` automatically on every push to main.

## 4. Verify
- Site: https://kogunlowo123.github.io/my-ai-architecture-project/
- CI: Actions tab — `ci` runs the tested sub-project suite; `pages` publishes the site.
