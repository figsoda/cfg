{ lib }:

with import ../colors.nix;

let
  inherit (builtins) concatStringsSep;
  inherit (lib) imap0 mapAttrsFlatten;

  highlights = {
    # group-name
    Comment = {
      fg = lightgray;
      attrs = "italic";
    };
    Constant.fg = blue;
    String.fg = green;
    Character.fg = green;
    Number.fg = orange;
    Boolean.fg = orange;
    Float.fg = orange;
    Identifier.fg = red;
    Function.fg = blue;
    Statement.fg = magenta;
    Conditional.fg = magenta;
    Repeat.fg = magenta;
    Label.fg = red;
    Operator.fg = magenta;
    Keyword.fg = magenta;
    Exception.fg = magenta;
    PreProc.fg = blue;
    Include.fg = magenta;
    Define.fg = magenta;
    Macro.fg = magenta;
    PreCondit.fg = yellow;
    Type.fg = yellow;
    StorageClass.fg = yellow;
    Structure.fg = yellow;
    Typedef.fg = yellow;
    Special.fg = blue;
    SpecialChar.fg = orange;
    Tag = { };
    Delimiter = { };
    SpecialComment = {
      fg = lightgray;
      attrs = "italic";
    };
    Debug = { };
    Underlined.attrs = "underline";
    Ignore = { };
    Error.fg = red;
    Todo.fg = magenta;

    # highlight-groups
    ColorColumn.bg = dimgray;
    Conceal = { };
    Cursor = {
      fg = black;
      bg = blue;
    };
    lCursor = {
      fg = black;
      bg = cyan;
    };
    CursorIM.fg = white;
    CursorColumn.bg = dimgray;
    CursorLine.bg = dimgray;
    Directory.fg = blue;
    DiffAdd.fg = green;
    DiffChange.fg = yellow;
    DiffDelete.fg = red;
    DiffText.fg = white;
    EndOfBuffer.fg = black;
    TermCursor.bg = white;
    TermCursorNC.fg = white;
    ErrorMsg.fg = red;
    WinSeparator.fg = black;
    Folded.fg = lightgray;
    FoldColumn.fg = white;
    SignColumn.fg = white;
    IncSearch = {
      fg = yellow;
      bg = lightgray;
    };
    Substitute = {
      fg = black;
      bg = yellow;
    };
    LineNr.fg = silver;
    CursorLineNr.fg = white;
    MatchParen = {
      fg = blue;
      attrs = "underline";
    };
    ModeMsg.fg = white;
    MsgArea.fg = white;
    MsgSeparator.fg = dimgray;
    MoreMsg.fg = white;
    NonText.fg = silver;
    Normal = {
      fg = white;
      bg = black;
    };
    NormalFloat = {
      fg = white;
      bg = dimgray;
    };
    NormalNC = {
      fg = white;
      bg = black;
    };
    Pmenu = {
      fg = white;
      bg = dimgray;
    };
    PmenuSel = {
      fg = black;
      bg = blue;
    };
    PmenuSbar.bg = dimgray;
    PmenuThumb.bg = lightgray;
    Question.fg = magenta;
    QuickFixLine = {
      fg = black;
      bg = yellow;
    };
    Search = {
      fg = black;
      bg = yellow;
    };
    SpecialKey.fg = silver;
    SpellBad = {
      fg = red;
      attrs = "underline";
    };
    SpellCap.fg = orange;
    SpellLocal.fg = orange;
    SpellRare.fg = orange;
    StatusLine = { };
    StatusLineNC = { };
    TabLine.fg = lightgray;
    TabLineFill = { };
    TabLineSel.fg = white;
    Title = {
      fg = blue;
      attrs = "bold";
    };
    Visual.bg = gray;
    VisualNOS.bg = gray;
    WarningMsg.fg = yellow;
    Whitespace.fg = silver;
    WildMenu = {
      fg = black;
      bg = blue;
    };

    # nvim_open_win
    FloatBorder = {
      fg = white;
      bg = dimgray;
    };

    # diagnostic
    DiagnosticError.fg = red;
    DiagnosticWarn.fg = yellow;
    DiagnosticInfo.fg = blue;
    DiagnosticHint.fg = white;
    DiagnosticUnderlineError = {
      sp = red;
      attrs = "underline";
    };
    DiagnosticUnderlineWarn = {
      sp = yellow;
      attrs = "underline";
    };
    DiagnosticUnderlineInfo = {
      sp = blue;
      attrs = "underline";
    };
    DiagnosticUnderlineHint.attrs = "underline";

    # diff
    diffRemoved.fg = red;
    diffAdded.fg = green;
    diffChanged.fg = yellow;
    diffSubname.fg = orange;
    diffLine.fg = magenta;
    diffFile.fg = yellow;
    diffOldFile.fg = red;
    diffNewFile.fg = green;
    diffIndexLine.fg = magenta;

    # gitcommit.vim
    gitCommitUnmerged.fg = green;
    gitCommitOnBranch.fg = white;
    gitCommitBranch.fg = magenta;
    gitCommitDiscardedType.fg = red;
    gitCommitSelectedType.fg = green;
    gitCommitHeader.fg = white;
    gitCommitUntrackedFile.fg = cyan;
    gitCommitDiscardedFile.fg = red;
    gitCommitSelectedFile.fg = green;
    gitCommitUnmergedFile.fg = yellow;
    gitCommitSummary.fg = white;

    # gitsigns.nvim
    GitSignsAdd.fg = green;
    GitSignsChange.fg = yellow;
    GitSignsDelete.fg = red;

    # indent-blankline.nvim
    IndentBlanklineChar.fg = gray;

    # leap.nvim
    LeapMatch = {
      fg = green;
      attrs = "bold";
    };
    LeapLabelPrimary = {
      fg = black;
      bg = blue;
      attrs = "bold";
    };
    LeapLabelSecondary = {
      fg = white;
      bg = yellow;
      attrs = "bold";
    };
    LeapLabelSelected = {
      fg = magenta;
      attrs = "bold";
    };
    LeapBackdrop = {
      fg = lightgray;
      bg = black;
      attrs = "NONE";
    };

    # noice.nvim
    NoiceFormatProgressDone = {
      fg = white;
      bg = silver;
    };
    NoiceFormatProgressTodo = {
      fg = white;
      bg = black;
    };
    NoiceLspProgressTitle.fg = white;

    # nvim-cmp
    CmpItemAbbr.fg = white;
    CmpItemAbbrDeprecated.fg = lightgray;
    CmpItemAbbrMatch.fg = blue;
    CmpItemAbbrMatchFuzzy.fg = blue;
    CmpItemKind.fg = orange;
    CmpItemMenu.fg = white;

    # nvim-notify
    NotifyERRORBorder.fg = red;
    NotifyERRORIcon.fg = red;
    NotifyERRORTitle.fg = red;
    NotifyWARNBorder.fg = yellow;
    NotifyWARNIcon.fg = yellow;
    NotifyWARNTitle.fg = yellow;
    NotifyINFOBorder.fg = blue;
    NotifyINFOIcon.fg = blue;
    NotifyINFOTitle.fg = blue;
    NotifyDEBUGBorder.fg = white;
    NotifyDEBUGIcon.fg = white;
    NotifyDEBUGTitle.fg = white;
    NotifyTRACEBorder.fg = white;
    NotifyTRACEIcon.fg = white;
    NotifyTRACETitle.fg = white;

    # nvim-tree.lua
    NvimTreeExecFile.fg = green;
    NvimTreeSpecialFile.fg = yellow;
    NvimTreeImageFile.fg = magenta;
    NvimTreeGitDirty.fg = red;
    NvimTreeGitDeleted.fg = red;
    NvimTreeWinSeparator.fg = black;

    # treesitter
    "@attribute".fg = cyan;
    "@constant.builtin".fg = orange;
    "@constant.macro".fg = orange;
    "@constructor".fg = yellow;
    "@error".fg = red;
    "@field".fg = blue;
    "@function.builtin".fg = cyan;
    "@none".fg = white;
    "@function.macro".fg = blue;
    "@namespace".fg = white;
    "@property".fg = blue;
    "@punctuation.delimiter".fg = white;
    "@punctuation.special".fg = blue;
    "@string.escape".fg = orange;
    "@string.regex".fg = orange;
    "@string.special".fg = orange;
    "@symbol".fg = cyan;
    "@tag".fg = blue;
    "@tag.attribute".fg = red;
    "@tag.delimiter".fg = blue;
    "@text.danger".fg = red;
    "@text.emphasis".attrs = "italic";
    "@text.literal".fg = green;
    "@text.note".fg = blue;
    "@text.reference".fg = red;
    "@text.strong".attrs = "bold";
    "@text.title" = {
      fg = blue;
      attrs = "bold";
    };
    "@text.uri".fg = orange;
    "@text.warning".fg = yellow;
    "@variable.builtin".fg = orange;

    # vim-nix
    nixStringDelimiter.fg = green;

    # custom
    StatusLineGitAdded = {
      fg = green;
      bg = dimgray;
    };
    StatusLineGitChanged = {
      fg = yellow;
      bg = dimgray;
    };
    StatusLineGitRemoved = {
      fg = red;
      bg = dimgray;
    };
  };
in

concatStringsSep "\n" (mapAttrsFlatten
  (group: highlight:
    let get = k: highlight.${k} or "NONE";
    in "hi ${group} guifg=${get "fg"} guibg=${get "bg"} guisp=${highlight.sp or (get "fg")} gui=${get "attrs"}")
  highlights
++ imap0 (i: color: "let terminal_color_${toString i} = '${color}'") [
  black
  red
  green
  yellow
  blue
  magenta
  cyan
  white
  silver
  lightred
  green
  orange
  blue
  magenta
  cyan
])
