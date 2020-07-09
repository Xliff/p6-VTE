use v6.c;

use NativeCall;

use VTE::Raw::Types;

unit package VTE::Raw::Regex;

### /usr/include/vte-2.91/vte/vteregex.h

sub vte_regex_error_quark ()
  returns GQuark
  is native(vte)
  is export
{ * }

sub vte_regex_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_regex_jit (
  VteRegex $regex,
  guint32 $flags,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_regex_new_for_match (
  Str $pattern,
  gssize $pattern_length,
  guint32 $flags,
  CArray[Pointer[GError]] $error
)
  returns VteRegex
  is native(vte)
  is export
{ * }

sub vte_regex_new_for_search (
  Str $pattern,
  gssize $pattern_length,
  guint32 $flags,
  CArray[Pointer[GError]] $error
)
  returns VteRegex
  is native(vte)
  is export
{ * }

sub vte_regex_ref (VteRegex $regex)
  returns VteRegex
  is native(vte)
  is export
{ * }

sub vte_regex_substitute (
  VteRegex $regex,
  Str $subject,
  Str $replacement,
  guint32 $flags,
  CArray[Pointer[GError]] $error
)
  returns Str
  is native(vte)
  is export
{ * }

sub vte_regex_unref (VteRegex $regex)
  returns VteRegex
  is native(vte)
  is export
{ * }
