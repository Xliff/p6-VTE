use v6;

unit package App::Compat::PCRE;

=begin pcre
The following option bits can be passed only to pcre2_compile(). However,
they may affect compilation, JIT compilation, and/or interpretive execution.
The following tags indicate which:

C   alters what is compiled by pcre2_compile()
J   alters what is compiled by pcre2_jit_compile()
M   is inspected during pcre2_match() execution
D   is inspected during pcre2_dfa_match() execution
=end pcre

enum PCREFlags is export (
  PCRE2_ANCHORED      => 0x80000000,
  PCRE2_NO_UTF_CHECK  => 0x40000000,
  PCRE2_ENDANCHORED   => 0x20000000,

  PCRE2_ALLOW_EMPTY_CLASS   => 0x00000001,  # C
  PCRE2_ALT_BSUX            => 0x00000002,  # C
  PCRE2_AUTO_CALLOUT        => 0x00000004,  # C
  PCRE2_CASELESS            => 0x00000008,  # C
  PCRE2_DOLLAR_ENDONLY      => 0x00000010,  #   J M D
  PCRE2_DOTALL              => 0x00000020,  # C
  PCRE2_DUPNAMES            => 0x00000040,  # C
  PCRE2_EXTENDED            => 0x00000080,  # C
  PCRE2_FIRSTLINE           => 0x00000100,  #   J M D
  PCRE2_MATCH_UNSET_BACKREF => 0x00000200,  # C J M
  PCRE2_MULTILINE           => 0x00000400,  # C
  PCRE2_NEVER_UCP           => 0x00000800,  # C
  PCRE2_NEVER_UTF           => 0x00001000,  # C
  PCRE2_NO_AUTO_CAPTURE     => 0x00002000,  # C
  PCRE2_NO_AUTO_POSSESS     => 0x00004000,  # C
  PCRE2_NO_DOTSTAR_ANCHOR   => 0x00008000,  # C
  PCRE2_NO_START_OPTIMIZE   => 0x00010000,  #   J M D
  PCRE2_UCP                 => 0x00020000,  # C J M D
  PCRE2_UNGREEDY            => 0x00040000,  # C
  PCRE2_UTF                 => 0x00080000,  # C J M D
  PCRE2_NEVER_BACKSLASH_C   => 0x00100000,  # C
  PCRE2_ALT_CIRCUMFLEX      => 0x00200000,  #   J M D
  PCRE2_ALT_VERBNAMES       => 0x00400000,  # C
  PCRE2_USE_OFFSET_LIMIT    => 0x00800000,  #   J M D
  PCRE2_EXTENDED_MORE       => 0x01000000,  # C
  PCRE2_LITERAL             => 0x02000000,  # C
  PCRE2_MATCH_INVALID_UTF   => 0x04000000   #   J M D
);

enum PCRECompileFlags is export (
  PCRE2_JIT_COMPLETE        => 0x00000001,  # For full matching
  PCRE2_JIT_PARTIAL_SOFT    => 0x00000002,
  PCRE2_JIT_PARTIAL_HARD    => 0x00000004,
  PCRE2_JIT_INVALID_UTF     => 0x00000100
);

enum PCREExtraFlags is export (
  PCRE2_EXTRA_ALLOW_SURROGATE_ESCAPES  => 0x00000001,  # C
  PCRE2_EXTRA_BAD_ESCAPE_IS_LITERAL    => 0x00000002,  # C
  PCRE2_EXTRA_MATCH_WORD               => 0x00000004,  # C
  PCRE2_EXTRA_MATCH_LINE               => 0x00000008,  # C
  PCRE2_EXTRA_ESCAPED_CR_IS_LF         => 0x00000010,  # C
  PCRE2_EXTRA_ALT_BSUX                 => 0x00000020   # C
);
