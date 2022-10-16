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
    PreProc.fg = yellow;
    Include.fg = blue;
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
    Normal.fg = white;
    NormalFloat = {
      fg = white;
      bg = dimgray;
    };
    NormalNC.fg = white;
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
    Title.fg = green;
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
    DiagnosticHint.fg = blue;
    DiagnosticUnderlineError = {
      fg = red;
      attrs = "underline";
    };
    DiagnosticUnderlineWarn = {
      fg = yellow;
      attrs = "underline";
    };
    DiagnosticUnderlineInfo = {
      fg = blue;
      attrs = "underline";
    };
    DiagnosticUnderlineHint = {
      fg = blue;
      attrs = "underline";
    };

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

    # nvim-cmp
    CmpItemAbbr.fg = white;
    CmpItemAbbrDeprecated.fg = lightgray;
    CmpItemAbbrMatch.fg = blue;
    CmpItemAbbrMatchFuzzy.fg = blue;
    CmpItemKind.fg = orange;
    CmpItemMenu.fg = white;

    # nvim-code-action-menu
    CodeActionMenuMenuSelection.bg = gray;

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

    # nvim-treesitter
    TSAnnocation.fg = white;
    TSAttribute.fg = cyan;
    TSBoolean.fg = orange;
    TSCharacter.fg = white;
    TSComment = {
      fg = lightgray;
      attrs = "italic";
    };
    TSConditional.fg = magenta;
    TSConstant.fg = blue;
    TSConstBuiltin.fg = orange;
    TSConstMacro.fg = orange;
    TSConstructor.fg = yellow;
    TSError.fg = red;
    TSException.fg = magenta;
    TSField.fg = blue;
    TSFloat.fg = orange;
    TSFunction.fg = blue;
    TSFuncBuiltin.fg = cyan;
    TSFuncMacro.fg = blue;
    TSInclude.fg = magenta;
    TSKeyword.fg = magenta;
    TSKeywordFunction.fg = magenta;
    TSKeywordOperator.fg = magenta;
    TSKeywordReturn.fg = magenta;
    TSLabel.fg = red;
    TSMethod.fg = blue;
    TSNamespace.fg = white;
    TSNone.fg = white;
    TSNumber.fg = orange;
    TSOperator.fg = magenta;
    TSParameter.fg = red;
    TSParameterReference.fg = white;
    TSProperty.fg = blue;
    TSPunctDelimiter.fg = white;
    TSPunctBracket.fg = white;
    TSPunctSpecial.fg = white;
    TSRepeat.fg = magenta;
    TSString.fg = green;
    TSStringRegex.fg = orange;
    TSStringEscape.fg = orange;
    TSStringSpecial.fg = orange;
    TSSymbol.fg = cyan;
    TSTag.fg = blue;
    TSTagAttribute.fg = red;
    TSTagDelimiter.fg = blue;
    TSText.fg = white;
    TSStrong.fg = white;
    TSEmphasis.fg = white;
    TSUnderline.fg = white;
    TSStrike.fg = white;
    TSTitle.fg = green;
    TSLiteral.fg = green;
    TSURI.fg = blue;
    TSMath.fg = white;
    TSTextReference.fg = red;
    TSEnvironment.fg = white;
    TSEnvironmentName.fg = white;
    TSNote.fg = blue;
    TSWarning.fg = yellow;
    TSDanger.fg = red;
    TSType.fg = yellow;
    TSTypeBuiltin.fg = orange;
    TSVariable.fg = white;
    TSVariableBuiltin.fg = magenta;

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
    in "hi ${group} guifg=${get "fg"} guibg=${get "bg"} guisp=${get "fg"} gui=${get "attrs"}")
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
