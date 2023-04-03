{
  enable = true;
  interactiveOnly = false;
  settings = {
    cmd_duration.min_time = 1000;
    command_timeout = 1000;
    directory = {
      fish_style_pwd_dir_length = 1;
      read_only = " ";
      truncate_to_repo = false;
    };
    format = ''
      $username$directory$git_branch$git_commit$git_state$git_status$nix_shell$cmd_duration
      $jobs$battery$status$character
    '';
    nix_shell.symbol = " ";
  };
}
