use v6.c;

use Method::Also;

use NativeCall;

use VTE::Raw::Types;
use VTE::Raw::Pty;

use GLib::Roles::Object;

our subset VtePtyAncestry is export of Mu
  where VtePty | GObject;

class VTE::Pty {
  also does GLib::Roles::Object;

  has VtePty $!vpty is implementor;

  submethod BUILD (:$pty) {
    self.setVtePty($pty) if $pty;
  }

  method setVtePty (VtePtyAncestry $_) {
    my $to-parent;

    $!vpty = do {
      when VtePty { $_               }
      default     { cast(VtePty, $_) }
    }
    self.roleInit-Object;
  }

  method VTE::Raw::Definitions::VtePty
    is also<VtePty>
  { $!vpty }

  method new_foreign_sync (
    Int() $fd,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-foreign-sync>
  {
    my gint $f = $fd;

    clear_error;
    my $pty = vte_pty_new_foreign_sync($!vpty, $fd, $cancellable, $error);
    set_error($error);

    $pty ?? self.bless( :$pty ) !! Nil
  }

  method new_sync (
    Int() $flags,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-sync>
      {
    my VtePtyFlags $f = $flags;

    clear_error;
    my $pty = vte_pty_new_sync($!vpty, $f, $cancellable, $error);
    set_error($error);

    $pty ?? self.bless( :$pty ) !! Nil
  }

  method child_setup is also<child-setup> {
    vte_pty_child_setup($!vpty);
  }

  method error_quark (VTE::Pty:U: ) is also<error-quark> {
    vte_pty_error_quark();
  }

  method get_fd is also<get-fd> {
    vte_pty_get_fd($!vpty);
  }

  proto method get_size (|)
      is also<get-size>
  { * }

  multi method get_size is also<size> {
    my $rv = samewith($, $, :all);

    $rv ?? $rv.skip(1) !! Nil;
  }
  multi method get_size (
    $rows is rw,
    $columns is rw,
    CArray[Pointer[GError]] $error = gerror,
    :$all = False
  ) {
    my gint ($r, $c) = 0 xx 2;

    clear_error;
    my $rv = so vte_pty_get_size($!vpty, $r, $c, $error);
    set_error($error);
    ($rows, $columns) = ($r, $c);

    $all.not ?? $rv !! ($rv, $rows, $columns);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &vte_pty_get_type, $n, $t );
  }

  method set_size (Int() $rows, Int() $columns, CArray[Pointer[GError]] $error)
    is also<set-size>
  {
    my gint ($r, $c) = ($rows, $columns);

    clear_error;
    my $rv = vte_pty_set_size($!vpty, $r, $c, $error);
    set_error($error);
    $rv;
  }

  method set_utf8 (Int() $utf8, CArray[Pointer[GError]] $error = gerror)
    is also<set-utf8>
  {
    my gboolean $u = $utf8.so.Int;

    clear_error;
    my $rv = so vte_pty_set_utf8($!vpty, $u, $error);
    set_error($error);
    $rv;
  }

  proto method spawn_async (|)
      is also<spawn-async>
  { * }

  multi method spawn_async (
    @argv,
    @envv,
    Int() $spawn_flags,
    gpointer $child_setup_data               = gpointer,
    GDestroyNotify $child_setup_data_destroy = gpointer,
    Int() $timeout                           = -1,
    GCancellable() $cancellable              = GCancellable,
    &callback                                = Callable,
    gpointer $user_data                      = gpointer
  ) {
    samewith(
      Str,
      resolve-gstrv(@argv),
      resolve-gstrv(@envv),
      $spawn_flags,
      $child_setup_data,
      $timeout,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method spawn_async (
    CArray[Str] $argv,
    CArray[Str] $envv,
    Int() $spawn_flags,
    gpointer $child_setup_data               = gpointer,
    GDestroyNotify $child_setup_data_destroy = gpointer,
    Int() $timeout                           = -1,
    GCancellable() $cancellable              = GCancellable,
    &callback                                = Callable,
    gpointer $user_data                      = gpointer
  ) {
    samewith(
      Str,
      $argv,
      $envv,
      $spawn_flags,
      $child_setup_data,
      $timeout,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method spawn_async (
    Str() $working_directory,
    @argv,
    @envv,
    Int() $spawn_flags,
    gpointer $child_setup_data               = gpointer,
    GDestroyNotify $child_setup_data_destroy = gpointer,
    Int() $timeout                           = -1,
    GCancellable() $cancellable              = GCancellable,
    &callback                                = Callable,
    gpointer $user_data                      = gpointer
  ) {
    samewith(
      $working_directory,
      resolve-gstrv(@argv),
      resolve-gstrv(@envv),
      $spawn_flags,
      $child_setup_data,
      $timeout,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method spawn_async (
    Str() $working_directory,
    CArray[Str] $argv,
    CArray[Str] $envv,
    Int() $spawn_flags,
    GSpawnChildSetupFunc $child_setup,
    gpointer $child_setup_data,
    GDestroyNotify $child_setup_data_destroy,
    Int() $timeout,
    GCancellable() $cancellable,
    GAsyncReadyCallback $callback,
    gpointer $user_data = gpointer
  ) {
    my GSpawnFlags $s = $spawn_flags;
    my gint $t = $timeout;

    vte_pty_spawn_async(
      $!vpty,
      $working_directory,
      $argv,
      $envv,
      $s,
      $child_setup,
      $child_setup_data,
      $child_setup_data_destroy,
      $t,
      $cancellable,
      $callback,
      $user_data
    );
  }

  method spawn_finish (
    GAsyncResult() $result,
    Int() $child_pid,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<spawn-finish>
  {
    my GPid $cp = $child_pid;

    clear_error;
    my $rv = so vte_pty_spawn_finish($!vpty, $result, $cp, $error);
    set_error($error);
    $rv;
  }

}
