use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use VTE::Raw::Definitions;

use GLib::Roles::StaticClass;

sub cursor_blink_mode_get_type is export {
  state ($n, $t);

  unstable_get_type(
    $?ROUTINE.name.subst('_get_type', ''),
    &vte_cursor_blink_mode_get_type,
    $n,
    $t
  );
}

sub cursor_shape_get_type is export {
  state ($n, $t);

  unstable_get_type(
    $?ROUTINE.name.subst('_get_type', ''),
    &vte_cursor_shape_get_type,
    $n,
    $t
  );
}

sub erase_binding_get_type is export {
  state ($n, $t);

  unstable_get_type(
    $?ROUTINE.name.subst('_get_type', ''),
    &vte_erase_binding_get_type,
    $n,
    $t
  );
}

sub format_get_type is export {
  state ($n, $t);

  unstable_get_type(
    $?ROUTINE.name.subst('_get_type', ''),
    &vte_format_get_type,
    $n,
    $t
  );
}

sub pty_error_get_type is export {
  state ($n, $t);

  unstable_get_type(
    $?ROUTINE.name.subst('_get_type', ''),
    &vte_pty_error_get_type,
    $n,
    $t
  );
}

sub pty_flags_get_type is export {
  state ($n, $t);

  unstable_get_type(
    $?ROUTINE.name.subst('_get_type', ''),
    &vte_pty_flags_get_type,
    $n,
    $t
  );
}

sub regex_error_get_type is export {
  state ($n, $t);

  unstable_get_type(
    $?ROUTINE.name.subst('_get_type', ''),
    &vte_regex_error_get_type,
    $n,
    $t
  );
}

sub text_blink_mode_get_type is export {
  state ($n, $t);

  unstable_get_type(
    $?ROUTINE.name.subst('_get_type', ''),
    &vte_text_blink_mode_get_type,
    $n,
    $t
  );
}

sub write_flags_get_type is export {
  state ($n, $t);

  unstable_get_type(
    $?ROUTINE.name.subst('_get_type', ''),
    &vte_write_flags_get_type,
    $n,
    $t
  );
}


### /usr/include/vte-2.91/vte/vtetypebuiltins.h

sub vte_cursor_blink_mode_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_cursor_shape_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_erase_binding_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_format_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_pty_error_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_pty_flags_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_regex_error_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_text_blink_mode_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_write_flags_get_type ()
  returns GType
  is native(vte)
  is export
{ * }
