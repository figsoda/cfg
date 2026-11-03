{ pkgs }:

{
  "codex/config.toml".source = pkgs.writers.writeTOML "codex.toml" {
    sandbox_mode = "danger-full-access";
  };
}
