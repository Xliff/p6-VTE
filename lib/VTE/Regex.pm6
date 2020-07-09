use v6.c;

use VTE::Raw::Types;
use VTE::Raw::Regex;

# BOXED

class VTE::Regex {
  has VteRegex $!vt;

  method new_for_match (
    Str() $pattern,
    Int() $pattern_length,
    Int() $flags,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gssize $p = $pattern_length;
    my guint32 $f = $flags;

    clear_error;
    my $regex = vte_regex_new_for_match($pattern, $p, $f, $error);
    set_error($error);

    $regex ?? self.bless( :$regex ) !! Nil;
  }

  method new_for_search (
    Str $pattern,
    Int() $pattern_length,
    Int() $flags,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gssize $p = $pattern_length;
    my guint32 $f = $flags;

    clear_error;
    my $regex = vte_regex_new_for_search($pattern, $p, $f, $error);
    set_error($error);

    $regex ?? self.bless( :$regex ) !! Nil;
  }

  method jit (Int() $flags, CArray[Pointer[GError]] $error = gerror) {
    my guint32 $f = $flags;

    clear_error;
    my $rv = so vte_regex_jit($!vr, $flags, $error);
    set_error($error);
    $rv;
  }

  method ref {
    vte_regex_ref($!vr);
    self;
  }

  method substitute (
    Str() $subject,
    Str() $replacement,
    Int() $flags,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my guint32 $f = $flags;

    clear_error;
    my $rv = vte_regex_substitute($!vr, $subject, $replacement, $f, $error);
    set_error($error);
    $rv;
  }

  method unref {
    vte_regex_unref($!vr);
  }

  # CLASS METHODS
  method error_quark (VTE::Regex:U: ) {
    vte_regex_error_quark();
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &vte_regex_get_type, $n, $t );
  }

}
