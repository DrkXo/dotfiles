# 🛠️Dotfiles

---

## 📦 Initial Setup (First-Time Clone)

Clone the bare repository into a hidden `.dotfiles` directory:

```bash
git clone --bare https://github.com/USERNAME/dotfiles.git $HOME/.dotfiles
```

Set up an alias to simplify Git commands:

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Add this alias to your shell config for permanence:

```bash
echo "alias dotfiles='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.zshrc
source ~/.zshrc
```

Try to check out the dotfiles:

```bash
dotfiles checkout
```

If you get errors (conflicts with existing files), back them up and retry:

```bash
mkdir -p .dotfiles-backup
dotfiles checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} .dotfiles-backup/
dotfiles checkout
```

Hide untracked files:

```bash
dotfiles config --local status.showUntrackedFiles no
```

---

## 💾 Starting from Scratch

If you want to initialize your dotfiles on a fresh machine:

```bash
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo "alias dotfiles='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.zshrc
echo ".dotfiles" >> ~/.gitignore
source ~/.zshrc
```

Configure Git identity:

```bash
git config --global user.name "USERNAME"
git config --global user.email "USEREMAIL"
```

Add and commit files:

```bash
dotfiles add .bashrc .zshrc .zshenv
dotfiles commit -m "Add initial dotfiles"
```

Rename the branch to `main`:

```bash
dotfiles branch -M main
```

Add the GitHub remote:

```bash
dotfiles remote add origin https://github.com/USERNAME/dotfiles.git
```

Push to GitHub:

```bash
dotfiles push -u origin main
```

---

## 🩵 Removing a File or Folder from Tracking

Untrack it (but keep it on disk):

```bash
dotfiles rm --cached -r path/to/folder
```

Prevent it from being re-added:

```bash
echo "path/to/folder" >> ~/.gitignore
```

Commit the change:

```bash
dotfiles commit -m "Stop tracking path/to/folder"
dotfiles push
```

---

## 🧐 Useful Commands

| Action                               | Command                                                |
| ------------------------------------ | ------------------------------------------------------ |
| Check status                         | `dotfiles status`                                      |
| Add files                            | `dotfiles add .bashrc .zshrc`                          |
| Commit                               | `dotfiles commit -m "Your message"`                    |
| Push to GitHub                       | `dotfiles push`                                        |
| Restore accidentally deleted files   | `dotfiles restore --source=HEAD --staged --worktree .` |
| Change branch to `main`              | `dotfiles branch -M main`                              |
| Disable Git pager (fix `less` error) | `git config --global core.pager cat`                   |

---

## 💻 Open in VS Code with Git Support

```bash
code ~ --git-dir=$HOME/.dotfiles --work-tree=$HOME
```

Or create an alias:

```bash
alias dotcode='code ~ --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

---

## ⚠️ Safety Notes

* Always back up `$HOME` before a first-time `checkout`
* Keep secrets (tokens, SSH keys) out of versioning
* Use `.gitignore` to exclude personal or machine-specific files
