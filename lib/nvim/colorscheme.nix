{ lib }:

with import ../colors.nix;

let
  inherit (builtins) concatStringsSep;
  inherit (lib) imap0 mapAttrsFlatten;

  highlights = {
    # group-name
    Comment = {
      fg = dimwhite;
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
      fg = dimwhite;
      attrs = "italic";
    };
    Debug = { };
    Underlined.attrs = "underline";
    Ignore = { };
    Error.fg = red;
    Todo.fg = magenta;

    # highlight-groups
    ColorColumn.bg = darkgray;
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
    CursorColumn.bg = darkgray;
    CursorLine.bg = darkgray;
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
    Folded.fg = dimwhite;
    FoldColumn.fg = white;
    SignColumn.fg = white;
    IncSearch = {
      fg = yellow;
      bg = dimwhite;
    };
    Substitute = {
      fg = black;
      bg = yellow;
    };
    LineNr.fg = lightgray;
    CursorLineNr.fg = white;
    MatchParen = {
      fg = blue;
      attrs = "underline";
    };
    ModeMsg.fg = white;
    MsgArea.fg = white;
    MsgSeparator.fg = darkgray;
    MoreMsg.fg = white;
    NonText.fg = lightgray;
    Normal.fg = white;
    NormalFloat = {
      fg = white;
      bg = darkgray;
    };
    NormalNC.fg = white;
    Pmenu = {
      fg = white;
      bg = darkgray;
    };
    PmenuSel = {
      fg = black;
      bg = blue;
    };
    PmenuSbar.bg = darkgray;
    PmenuThumb.bg = dimwhite;
    Question.fg = magenta;
    QuickFixLine = {
      fg = black;
      bg = yellow;
    };
    Search = {
      fg = black;
      bg = yellow;
    };
    SpecialKey.fg = lightgray;
    SpellBad = {
      fg = red;
      attrs = "underline";
    };
    SpellCap.fg = orange;
    SpellLocal.fg = orange;
    SpellRare.fg = orange;
    StatusLine = { };
    StatusLineNC = { };
    TabLine.fg = dimwhite;
    TabLineFill = { };
    TabLineSel.fg = white;
    Title.fg = green;
    Visual.bg = gray;
    VisualNOS.bg = gray;
    WarningMsg.fg = yellow;
    Whitespace.fg = lightgray;
    WildMenu = {
      fg = black;
      bg = blue;
    };

    # nvim_open_win
    FloatBorder = {
      fg = white;
      bg = darkgray;
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

    # lightspeed.nvim
    LightspeedLabel = {
      fg = black;
      bg = blue;
      attrs = "bold";
    };
    LightspeedLabelOverlapped = {
      fg = black;
      bg = cyan;
      attrs = "bold";
    };
    LightspeedDistant = {
      fg = white;
      bg = yellow;
      attrs = "bold";
    };
    LightspeedDistantOverlapped = {
      fg = white;
      bg = orange;
      attrs = "bold";
    };
    LightspeedShortcut = {
      fg = black;
      bg = blue;
      attrs = "bold";
    };
    LightspeedShortcutOverlapped = {
      fg = black;
      bg = cyan;
      attrs = "bold";
    };
    LightspeedMaskedChar = {
      fg = green;
      attrs = "bold";
    };
    LightspeedGrayWash.fg = dimwhite;
    LightspeedUnlabeledMatch = {
      fg = magenta;
      attrs = "bold";
    };
    LightspeedOneCharMatch = {
      fg = black;
      bg = blue;
      attrs = "bold";
    };
    LightspeedUniqueChar = {
      fg = magenta;
      attrs = "bold";
    };
    LightspeedPendingOpArea = {
      fg = white;
      bg = red;
      attrs = "bold";
    };
    LightspeedPendingChangeOpArea = {
      fg = red;
      attrs = "bold";
    };

    # nvim-cmp
    CmpItemAbbr.fg = white;
    CmpItemAbbrDeprecated.fg = dimwhite;
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

    # nvim-treesitter
    TSAnnocation.fg = white;
    TSAttribute.fg = cyan;
    TSBoolean.fg = orange;
    TSCharacter.fg = white;
    TSComment = {
      fg = dimwhite;
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
      bg = darkgray;
    };
    StatusLineGitChanged = {
      fg = yellow;
      bg = darkgray;
    };
    StatusLineGitRemoved = {
      fg = red;
      bg = darkgray;
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
  lightgray
  darkred
  green
  orange
  blue
  magenta
  cyan
])
