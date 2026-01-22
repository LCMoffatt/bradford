---
title: "Student Workflow Instructions (Fork + Pull Request)"
---

These instructions describe how to contribute changes to the `bradford` repository. You’ll work in **your fork** and submit a **Pull Request (PR)** for review.

## 0) Prerequisites

- A GitHub account
- `git` installed (<https://git-scm.com/install/>)
- VS Code (<https://code.visualstudio.com/download>)
- Redhat XML extension (<https://marketplace.visualstudio.com/items?itemName=redhat.vscode-xml>)

## 1) Fork the repository on GitHub

1. Go to the main repository page <https://github.com/sjhuskey/bradford>.
2. Click **Fork** (top-right).
3. Choose your account as the destination.

This creates:  
`https://github.com/<your-username>/<repo-name>`

## 2) Clone *your fork* to your computer

In a terminal:

1. `git clone https://github.com/<your-username>/<repo-name>.git`
2. `cd <repo-name>`

## 3) Add the instructor repo as `upstream`

This lets you pull in updates from the original repository later.

In a terminal:

1. `git remote add upstream https://github.com/<instructor-username-or-org>/<repo-name>.git`
2. `git remote -v`

You should see both:
- `origin` → your fork
- `upstream` → instructor repo

---

## 4) Create a new branch for your work

**Do not work directly on `main`.** Create a branch for each chunk of work.

`git checkout -b <short-branch-name>`

Example branch names:
- `typo-fixes`
- `update-bibliography`
- `add-notes-on-ch3`

---

## 5) Edit files, then commit your changes

1. Edit the relevant file(s).
2. Check what changed:
    - `git status`
    - `git diff`
3. Stage and commit:
    - `git add path/to/file`
    - `git commit -m "Describe your change clearly"`

Good commit messages:
- "Fix typos in section on <name of person>"

---

## 6) Push your branch to your fork

`git push -u origin <short-branch-name>`

---

## 7) Open a Pull Request (PR)

1. Go to your fork on GitHub:  
   `https://github.com/<your-username>/<repo-name>`
2. You should see a banner offering to open a PR for your recently pushed branch.
3. Click **Compare & pull request**.
4. Confirm the PR is:
   - **Base repository:** instructor repo
   - **Base branch:** `main`
   - **Head repository:** your fork
   - **Compare branch:** your branch

In the PR description, include:
- What you changed
- Why you changed it
- Anything you’re unsure about / want feedback on

Then click **Create pull request**.

---

## 8) Responding to review comments (updating your PR)

If the instructor requests changes, you **do not** open a new PR.  
You just commit more changes to the **same branch** and push again:

- \# make edits
- `git add path/to/file`
- `git commit -m "Address review feedback"`
- `git push`

The existing PR will update automatically.

---

## 9) Keeping your fork up to date (sync with `upstream`)

If the instructor updates the main repo while you’re working, sync your fork:

- `git checkout main`
- `git fetch upstream`
- `git merge upstream/main`
- `git push origin main`

Then update your working branch with the latest `main` if needed:

- `git checkout <short-branch-name>`
- `git merge main`
- `git push`

Tip: If you run into merge conflicts and aren’t sure what to do, stop and ask for help.

---

## 10) Clean up after the PR is merged (recommended)

After your PR is merged, you can delete the branch locally and on GitHub.

Delete on GitHub:
- GitHub usually shows a **Delete branch** button on the merged PR page.

Delete locally:

- `git checkout main`
- `git branch -d <short-branch-name>`

If Git refuses because the branch isn’t fully merged locally, use:

- `git branch -D <short-branch-name>`

---

## Quick Checklist

- [ ] Forked the repo
- [ ] Cloned *my fork*
- [ ] Added `upstream`
- [ ] Created a new branch
- [ ] Committed changes with a clear message
- [ ] Pushed branch to my fork
- [ ] Opened a PR into instructor `main`
- [ ] Updated PR with additional commits if requested
