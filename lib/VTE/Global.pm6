use v6.c;

use NativeCall;

use VTE::Raw::Types;

use GLib::Roles::StaticClass;

class VTE::Global {
  also does GLib::Roles::StaticClass;

  method get_user_shell {
    vte_get_user_shell();
  }

  method get_features {
    vte_get_features();
  }

  method set_test_flags (Int() $flags) {
    my VteTestFlags $f = $flags;

    vte_set_test_flags($f);
  }

}

sub vte_get_user_shell ()
  returns Str
  is export
  is native(vte)
{ * }

sub vte_get_features ()
  returns Str
  is export
  is native(vte)
{ * }

sub vte_set_test_flags (guint64 $flags)
  is export
  is native(vte)
{ * }
