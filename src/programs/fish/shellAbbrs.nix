{
  c = "cargo";
  cb = "cargo build";
  cbr = "cargo build --release";
  cir = "cargo insta review";
  cit = "cargo insta test";
  cl = "cargo clippy";
  cn = "cargo nextest run";
  cr = "cargo run";
  crr = "cargo run --release";
  ct = "cargo test";
  g = "git";
  ga = "git add";
  gab = "git absorb -r";
  gb = " git branch";
  gbs = "git bisect";
  gc = "git commit";
  gca = "git commit --amend";
  gcan = "git commit --amend --no-edit";
  gcl = " git clone";
  gcp = " git cherry-pick";
  gd = "git diff";
  gdc = "git diff --cached";
  gdh = "git diff HEAD";
  gf = "git fetch";
  gff = "git pull --ff-only";
  gffu = "git pull --ff-only upstream (git branch --show-current)";
  gfu = "git fetch upstream";
  gl = "git log";
  gm = "git merge";
  gp = "git push";
  gpf = "git push -f";
  gpm = "git pull";
  gpr = "git pull --rebase";
  gpu = "git push -u origin (git branch --show-current)";
  gr = "git reset";
  grb = "git rebase";
  gre = "git restore";
  gro = "git reabse --onto";
  gs = "git status";
  gs- = "git switch -";
  gsC = " git switch -C";
  gsc = " git switch -c";
  gsd = " git switch -d";
  gsp = "git stash pop";
  gst = "git stash";
  gsw = " git switch";
  gt = " git tag";
  n = "nix";
  n-s = "nix shell -I nixpkgs=. --run fish -p";
  nb = "nix build";
  nbf = "nix build -f .";
  nd = "nix develop -c fish";
  nf = "nix flake";
  nfc = "nix flake check";
  nfs = "nix flake show";
  nfu = "nix flake update";
  nfuc = "nix flake update --commit-lock-file";
  nh = "nixpkgs-hammer";
  ni = "nix-init";
  nl = " nix-locate";
  nmc = "namaka check";
  nmr = "namaka review";
  nr = "nix run";
  nra = "nixpkgs-review approve";
  nram = "nixpkgs-review approve && nixpkgs-review merge";
  nrh = "nixpkgs-review rev HEAD";
  nrm = "nixpkgs-review merge";
  nrp = " nixpkgs-review pr --sandbox";
  nrpam = "nixpkgs-review post-result && nixpkgs-review approve && nixpkgs-review merge";
  nrpr = "nixpkgs-review post-result";
  nrw = "nixpkgs-rev wip";
  nu = "nix-update";
  nuc = "nix-update --commit";
  nucb = "nix-update --commit --build";
  p = " p";
  r = " r";
  vpu = " pkgs/applications/editors/vim/plugins/update.py -t (ghtok | psub)";
  w = " w";
}
