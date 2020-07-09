use v6.c;

use NativeCall;

use VTE::Raw::Types;

unit package VTE::Raw::Pty;

### /usr/include/vte-2.91/vte/vtepty.h

sub vte_pty_child_setup (VtePty $pty)
  is native(vte)
  is export
{ * }

sub vte_pty_error_quark ()
  returns GQuark
  is native(vte)
  is export
{ * }

sub vte_pty_get_fd (VtePty $pty)
  returns gint
  is native(vte)
  is export
{ * }

sub vte_pty_get_size (
  VtePty $pty,
  gint $rows is rw,
  gint $columns is rw,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_pty_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_pty_new_foreign_sync (
  gint $fd,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns VtePty
  is native(vte)
  is export
{ * }

sub vte_pty_new_sync (
  VtePtyFlags $flags,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns VtePty
  is native(vte)
  is export
{ * }

sub vte_pty_set_size (
  VtePty $pty,
  gint $rows,
  gint $columns,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_pty_set_utf8 (
  VtePty $pty,
  gboolean $utf8,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_pty_spawn_async (
  VtePty $pty,
  Str $working_directory,
  CArray[Str] $argv,
  CArray[Str] $envv,
  GSpawnFlags $spawn_flags,
  GSpawnChildSetupFunc $child_setup,
  gpointer $child_setup_data,
  GDestroyNotify $child_setup_data_destroy,
  gint $timeout,
  GCancellable $cancellable,
  GAsyncReadyCallback $callback,
  gpointer $user_data
)
  is native(vte)
  is export
{ * }

sub vte_pty_spawn_finish (
  VtePty $pty,
  GAsyncResult $result,
  GPid $child_pid,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(vte)
  is export
{ * }
