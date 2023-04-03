{ super }:

{
  enable = true;
  configure = super.nvim;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  withNodeJs = false;
  withPython3 = false;
  withRuby = false;
}
