use v6.c;

use NativeCall;
use Method::Also;

use VTE::Raw::Types;
use VTE::Raw::Terminal;

use GTK::Widget;
use GDK::RGBA;
use VTE::Pty;
use VTE::Regex;

use GLib::Roles::TypedBuffer;
use GTK::Roles::Scrollable;

our subset VteTerminalAncestry is export of Mu
  where VteTerminal | GtkScrollable | GtkWidgetAncestry;

class VTE::Terminal is GTK::Widget {
  also does GTK::Roles::Scrollable;

  has VteTerminal $!vt is implementor;

  submethod BUILD (:$terminal) {
    self.setVteTerminal($terminal) if $terminal;
  }

  method setVteTerminal (VteTerminalAncestry $_) {
    my $to-parent;

    $!vt = do {
      when VteTerminal {
        $to-parent = cast(GtkWidget, $_);
        $_;
      }

      when GtkScrollable {
        $to-parent = cast(GtkWidget, $_);
        $!s = $_;
        cast(VteTerminal, $_);
      }

      default {
        $to-parent = $_;
        cast(VteTerminal, $_);
      }
    }
    self.setWidget($to-parent);
    self.roleInit-GtkScrollable;
  }

  method VTE::Raw::Definitions::VteTerminal
    is also<VteTerminal>
  { $!vt }

  method new {
    my $terminal = vte_terminal_new();

    $terminal ?? self.bless( :$terminal ) !! Nil;
  }

  method allow-hyperlink is rw {
    Proxy.new:
      FETCH => -> $           { self.get_allow_hyperlink    },
      STORE => -> $, Int() \b { self.set_allow_hyperlink(b) };
  }

  method audible-bell is rw {
    Proxy.new:
      FETCH => -> $           { self.get_audible_bell    },
      STORE => -> $, Int() \b { self.set_audible_bell(b) };
  }

  method cjk-ambiguous-width is rw {
    Proxy.new:
      FETCH => -> $           { self.get_cjk_ambiguous_width    },
      STORE => -> $, Int() \i { self.set-cjk-ambiguous-width(i) };
  }

  method cursor-blink-mode is rw {
    Proxy.new:
      FETCH => -> $           { self.get_cursor_blink_mode    },
      STORE => -> $, Int() \i { self.set_cursor_blink_mode(i) };
  }

  method cursor-shape is rw {
    Proxy.new:
      FETCH => -> $           { self.get_cursor_shape    },
      STORE => -> $, Int() \i { self.set_cursor_shape(i) };
  }

  method encoding is rw {
    Proxy.new:
      FETCH => -> $           { self.get_encoding    },
      STORE => -> $, Str() \e { self.set_encoding(e) };
  }

  method font-scale is rw {
    Proxy.new:
      FETCH => -> $           { self.get_font_scale    },
      STORE => -> $, Num() \n { self.set-font-scale(n) };
  }

  method mouse-autohide is rw {
    Proxy.new:
      FETCH => -> $           { self.mouse_autohide    },
      STORE => -> $, Int() \i { self.mouse_autohide(i) };
  }

  method rewrap-on-resize is rw {
    Proxy.new:
      FETCH => -> $           { self.rewrap_on_resize    },
      STORE => -> $, Int() \i { self.rewrap_on_resize(i) };
  }

  method scroll-on-output is rw {
    Proxy.new:
      FETCH => -> $           { self.scroll_on_output    },
      STORE => -> $, Int() \i { self.scroll_on_output(i) };
  }

  method scroll-on-keystroke is rw {
    Proxy.new:
      FETCH => -> $           { self.scroll_on_keystroke    },
      STORE => -> $, Int() \i { self.scroll_on_keystroke(i) };
  }

  method scrollback-lines is rw {
    Proxy.new:
      FETCH => -> $           { self.scrollback_lines    },
      STORE => -> $, Int() \i { self.scrollback_lines(i) };
  }

  method word-char-exceptions is rw is also<word_char_exceptions> {
    Proxy.new:
      FETCH => -> $           { self.get_word_char_exceptions     },
      STORE => -> $, Str() \e { self.set_word_char_exceptions(e)  };
  }

  method copy_clipboard_format (Int() $format) is also<copy-clipboard-format> {
    my VteFormat $f = $format;

    vte_terminal_copy_clipboard_format($!vt, $f);
  }

  method copy_primary is also<copy-primary> {
    vte_terminal_copy_primary($!vt);
  }

  proto method event_check_regex_simple (|)
      is also<event-check-regex-simple>
  { * }

  multi method event_check_regex_simple (
    GdkEvent() $event,
    @regexes,
    Int() $match_flags,
  ) {
    my $matches = CArray[Str].new;
    $matches[0] = Str;

    my $rv = samewith(
      $event,
      ArrayToCArray(VteRegex, @regexes),
      @regexes.elems,
      $match_flags,
      $matches
    );

    $rv ?? CStringArrayToArray($matches) !! Nil;
  }
  multi method event_check_regex_simple (
    GdkEvent() $event,
    CArray[VteRegex] $regexes,
    Int() $n_regexes,
    Int() $match_flags,
    CArray[Str] $matches
  ) {
    my gsize $n = $n_regexes;
    my guint32 $m = $match_flags;

    so vte_terminal_event_check_regex_simple(
      $!vt,
      $event,
      $regexes,
      $n,
      $m,
      $matches
    );
  }

  method feed (Str() $data, Int() $length) {
    my gssize $l = $length;

    vte_terminal_feed($!vt, $data, $l);
  }

  method feed_child (Str() $text, Int() $length) is also<feed-child> {
    my gssize $l = $length;

    vte_terminal_feed_child($!vt, $text, $length);
  }

  method get_allow_hyperlink is also<get-allow-hyperlink> {
    so vte_terminal_get_allow_hyperlink($!vt);
  }

  method get_audible_bell is also<get-audible-bell> {
    so vte_terminal_get_audible_bell($!vt);
  }

  method get_bold_is_bright is also<get-bold-is-bright> {
    so vte_terminal_get_bold_is_bright($!vt);
  }

  method get_cell_height_scale is also<get-cell-height-scale> {
    vte_terminal_get_cell_height_scale($!vt);
  }

  method get_cell_width_scale is also<get-cell-width-scale> {
    vte_terminal_get_cell_width_scale($!vt);
  }

  method get_char_height is also<get-char-height> {
    vte_terminal_get_char_height($!vt);
  }

  method get_char_width is also<get-char-width> {
    vte_terminal_get_char_width($!vt);
  }

  method get_cjk_ambiguous_width is also<get-cjk-ambiguous-width> {
    vte_terminal_get_cjk_ambiguous_width($!vt);
  }

  method get_color_background_for_draw (GdkRGBA $color)
    is also<get-color-background-for-draw>
  {
    vte_terminal_get_color_background_for_draw($!vt, $color);
  }

  method get_column_count is also<get-column-count> {
    vte_terminal_get_column_count($!vt);
  }

  method get_current_directory_uri is also<get-current-directory-uri> {
    vte_terminal_get_current_directory_uri($!vt);
  }

  method get_current_file_uri is also<get-current-file-uri> {
    vte_terminal_get_current_file_uri($!vt);
  }

  method get_cursor_blink_mode is also<get-cursor-blink-mode> {
    VteCursorBlinkModeEnum( vte_terminal_get_cursor_blink_mode($!vt) )
  }

  proto method get_cursor_position (|)
      is also<get-cursor-position>
  { * }

  multi method get_cursor_position ( :rev(:$reversed) = False ) {
    samewith($, $, :$reversed);
  }
  multi method get_cursor_position (
    $column          is rw,
    $row             is rw,
    :rev(:$reversed) = False
  ) {
    my glong ($r, $c) = 0 xx 2;

    vte_terminal_get_cursor_position($!vt, $c, $r);

    my @ret = ($row, $column) = ($r, $c);
    @ret .= reverse if $reversed;
    @ret;
  }

  method get_cursor_shape is also<get-cursor-shape> {
    vte_terminal_get_cursor_shape($!vt);
  }

  method get_enable_bidi is also<get-enable-bidi> {
    vte_terminal_get_enable_bidi($!vt);
  }

  method get_enable_shaping is also<get-enable-shaping> {
    vte_terminal_get_enable_shaping($!vt);
  }

  method get_font is also<get-font> {
    vte_terminal_get_font($!vt);
  }

  method get_font_scale is also<get-font-scale> {
    vte_terminal_get_font_scale($!vt);
  }

  method get_has_selection is also<get-has-selection> {
    vte_terminal_get_has_selection($!vt);
  }

  method get_input_enabled is also<get-input-enabled> {
    vte_terminal_get_input_enabled($!vt);
  }

  method get_mouse_autohide is also<get-mouse-autohide> {
    vte_terminal_get_mouse_autohide($!vt);
  }

  method get_pty (:$raw = False) is also<get-pty> {
    my $p = vte_terminal_get_pty($!vt);

    $p ??
      ( $raw ?? $p !! VTE::Pty.new($p) )
      !!
      Nil;
  }

  method get_row_count
    is also<
      get-row-count
      row_count
      row-count
      rows
      r-elems
    >
  {
    vte_terminal_get_row_count($!vt);
  }

  method get_scroll_on_keystroke is also<get-scroll-on-keystroke> {
    vte_terminal_get_scroll_on_keystroke($!vt);
  }

  method get_scroll_on_output is also<get-scroll-on-output> {
    vte_terminal_get_scroll_on_output($!vt);
  }

  method get_scrollback_lines is also<get-scrollback-lines> {
    vte_terminal_get_scrollback_lines($!vt);
  }

  # cw: IF, given as I suspect, get_size is actually resolution in pixels,
  #     this method should return the number of text rows and columns!
  # method get_rc is also<get-rc> {
  #
  #   self.get_size( :rev );
  # }

  method get_size ( :rev(:$reversed) = False )
    is also<
      get-size
      size
      get_resolution
      get-resolution
    >
  {
    my @resolution = (self.get_column_count, self.get_row_count);

    $reversed ?? @resolution !! @resolution.reverse;
  }

  method get_text (
    &is_selected,
    gpointer $user_data,
    GArray() $attributes
  )
    is also<get-text>
  {
    vte_terminal_get_text($!vt, &is_selected, $user_data, $attributes);
  }

  method get_text_blink_mode is also<get-text-blink-mode> {
    VteTextBlinkMode( vte_terminal_get_text_blink_mode($!vt) );
  }

  proto method get_text_range (|)
      is also<get-text-range>
  { * }

  multi method get_text_range (
    Int() $start_row,
    Int() $start_col,
    Int() $end_row,
    Int() $end_col,
    GArray() $attributes,
    &is_selected,
    gpointer $user_data = gpointer,
  ) {
    samewith(
      $start_row,
      $start_col,
      $end_row,
      $end_col,
      &is_selected,
      $user_data,
      $attributes
    );
  }
  multi method get_text_range (
    Int() $start_row,
    Int() $start_col,
    Int() $end_row,
    Int() $end_col,
    &is_selected,
    gpointer $user_data,
    GArray() $attributes
  ) {
    my glong ($sr, $sc, $er, $ec) =
      ($start_row, $start_col, $end_row, $end_col);
    vte_terminal_get_text_range(
      $!vt,
      $start_row,
      $start_col,
      $end_row,
      $end_col,
      &is_selected,
      $user_data,
      $attributes
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &vte_terminal_get_type, $n, $t );
  }

  method get_window_title
    is also<
      get-window-title
      winow_title
      window-title
      title
    >
  {
    vte_terminal_get_window_title($!vt);
  }

  method get_word_char_exceptions is also<get-word-char-exceptions> {
    vte_terminal_get_word_char_exceptions($!vt);
  }

  method hyperlink_check_event (GdkEvent() $event)
    is also<hyperlink-check-event>
  {
    vte_terminal_hyperlink_check_event($!vt, $event);
  }

  method match_add_regex (VteRegex() $regex, Int() $flags)
    is also<match-add-regex>
  {
    my guint32 $f = $flags;

    vte_terminal_match_add_regex($!vt, $regex, $f);
  }

  proto method match_check_event (|)
      is also<match-check-event>
  { * }

  multi method match_check_event (GdkEvent() $event) {
    samewith($, :all);
  }
  multi method match_check_event (GdkEvent() $event, $tag is rw, :$all = False) {
    my gint $t = $tag;

    my $match = vte_terminal_match_check_event($!vt, $event, $t);
    ($tag = $t);
    $all.not ?? $match !! ($match, $tag);
  }

  method match_remove (Int() $tag) is also<match-remove> {
    my gint $t = $tag;
    vte_terminal_match_remove($!vt, $t);
  }

  method match_remove_all is also<match-remove-all> {
    vte_terminal_match_remove_all($!vt);
  }

  method match_set_cursor_name (Int() $tag, Str() $cursor_name)
    is also<match-set-cursor-name>
  {
    my gint $t = $tag;

    vte_terminal_match_set_cursor_name($!vt, $t, $cursor_name);
  }

  method paste_clipboard is also<paste-clipboard> {
    vte_terminal_paste_clipboard($!vt);
  }

  method paste_primary is also<paste-primary> {
    vte_terminal_paste_primary($!vt);
  }

  method pty_new_sync (
    Int() $flags,
    GCancellable() $cancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<pty-new-sync>
  {
    my VtePtyFlags $f = $flags;

    clear_error;
    my $p = vte_terminal_pty_new_sync($!vt, $f, $cancellable, $error);
    set_error($error);

    $p ??
      ( $raw ?? $p !! VTE::Pty.new($p) )
      !!
      Nil;
  }

  method reset (Int() $clear_tabstops, Int() $clear_history) {
    my gboolean ($ct, $ch) = ($clear_tabstops, $clear_history).map( *.Int.so );

    vte_terminal_reset($!vt, $ct, $ch);
  }

  method search_find_next is also<search-find-next> {
    so vte_terminal_search_find_next($!vt);
  }

  method search_find_previous is also<search-find-previous> {
    so vte_terminal_search_find_previous($!vt);
  }

  method search_get_regex (:$raw = False) is also<search-get-regex> {
    my $r = vte_terminal_search_get_regex($!vt);

    $r ??
      ( $raw ?? $r !! VTE::Regex.new($r) )
      !!
      Nil;
  }

  method search_get_wrap_around is also<search-get-wrap-around> {
    so vte_terminal_search_get_wrap_around($!vt);
  }

  method search_set_regex (VteRegex() $regex, Int() $flags)
    is also<search-set-regex>
  {
    my guint32 $f = $flags;

    vte_terminal_search_set_regex($!vt, $regex, $f);
  }

  method search_set_wrap_around (Int() $wrap_around)
    is also<search-set-wrap-around>
  {
    my gboolean $w = $wrap_around.so.Int;

    vte_terminal_search_set_wrap_around($!vt, $w);
  }

  method select_all is also<select-all> {
    vte_terminal_select_all($!vt);
  }

  method set_allow_hyperlink (Int() $allow_hyperlink)
    is also<set-allow-hyperlink>
  {
    my gboolean $a = $allow_hyperlink.so.Int;

    vte_terminal_set_allow_hyperlink($!vt, $allow_hyperlink);
  }

  method set_audible_bell (Int() $is_audible)
    is also<set-audible-bell>
  {
    my gboolean $i = $is_audible.so.Int;

    vte_terminal_set_audible_bell($!vt, $i);
  }

  method set_backspace_binding (Int() $binding)
    is also<set-backspace-binding>
  {
    my VteEraseBinding $b = $binding;

    vte_terminal_set_backspace_binding($!vt, $b);
  }

  method set_bold_is_bright (Int() $bold_is_bright)
    is also<set-bold-is-bright>
  {
    my gboolean $b = $bold_is_bright.so.Int;

    vte_terminal_set_bold_is_bright($!vt, $b);
  }

  method set_cell_height_scale (Num() $scale) is also<set-cell-height-scale> {
    my gdouble $s = $scale;

    vte_terminal_set_cell_height_scale($!vt, $s);
  }

  method set_cell_width_scale (Num() $scale) is also<set-cell-width-scale> {
    my gdouble $s = $scale;

    vte_terminal_set_cell_width_scale($!vt, $s);
  }

  method set_cjk_ambiguous_width (Int() $width)
    is also<set-cjk-ambiguous-width>
  {
    my gint $w = $width;

    vte_terminal_set_cjk_ambiguous_width($!vt, $w);
  }

  method set_clear_background (Int() $setting) is also<set-clear-background> {
    my gboolean $s = $setting;

    vte_terminal_set_clear_background($!vt, $setting);
  }

  method set_color_background (GdkRGBA $background)
    is also<set-color-background>
  {
    vte_terminal_set_color_background($!vt, $background);
  }

  method set_color_bold (GdkRGBA $bold) is also<set-color-bold> {
    vte_terminal_set_color_bold($!vt, $bold);
  }

  method set_cursor_colors (
    GdkRGBA $foreground,
    GdkRGBA $background
  ) {
    self.set_color_cursor($background);
    self.set_color_cursor_foreground($foreground);
  }

  method set_highlight_colors (
    GdkRGBA $foreground,
    GdkRGBA $background
  ) {
    self.set_color_highlight($background);
    self.set_color_highlight_foreground($foreground);
  }

  method set_color_cursor (GdkRGBA $cursor_background)
    is also<set-color-cursor>
  {
    vte_terminal_set_color_cursor($!vt, $cursor_background);
  }

  method set_color_cursor_foreground (GdkRGBA $cursor_foreground)
    is also<set-color-cursor-foreground>
  {
    vte_terminal_set_color_cursor_foreground($!vt, $cursor_foreground);
  }

  method set_color_foreground (GdkRGBA $foreground)
    is also<set-color-foreground>
  {
    vte_terminal_set_color_foreground($!vt, $foreground);
  }

  method set_color_highlight (GdkRGBA $highlight_background)
    is also<set-color-highlight>
  {
    vte_terminal_set_color_highlight($!vt, $highlight_background);
  }

  method set_color_highlight_foreground (GdkRGBA $highlight_foreground)
    is also<set-color-highlight-foreground>
  {
    vte_terminal_set_color_highlight_foreground($!vt, $highlight_foreground);
  }

  proto method set_colors (|)
      is also<set-colors>
  { * }

  multi method set_colors (
    GdkRGBA $foreground,
    GdkRGBA $background
  ) {
    samewith($foreground, $background, Pointer, 0);
  }
  multi method set_colors (
    GdkRGBA $foreground,
    GdkRGBA $background,
    @palette
  ) {
    samewith(
      $foreground,
      $background,
      GLib::Roles::TypedBuffer[GdkRGBA].new(@palette).p,
      @palette.elems
    );
  }
  multi method set_colors (
    GdkRGBA $foreground,
    GdkRGBA $background,
    Pointer $palette,
    Int() $palette_size
  ) {
    my gsize $p = $palette_size;

    vte_terminal_set_colors($!vt, $foreground, $background, $palette, $p);
  }

  method set_cursor_blink_mode (Int() $mode) is also<set-cursor-blink-mode> {
    my VteCursorBlinkMode $m = $mode;

    vte_terminal_set_cursor_blink_mode($!vt, $m);
  }

  method set_cursor_shape (Int() $shape) is also<set-cursor-shape> {
    my VteCursorShape $s = $shape;

    vte_terminal_set_cursor_shape($!vt, $s);
  }

  method set_default_colors is also<set-default-colors> {
    vte_terminal_set_default_colors($!vt);
  }

  method set_delete_binding (Int() $binding) is also<set-delete-binding> {
    my VteEraseBinding $b = $binding;

    vte_terminal_set_delete_binding($!vt, $b);
  }

  method set_enable_bidi (Int() $enable_bidi) is also<set-enable-bidi> {
    my gboolean $e = $enable_bidi.so.Int;

    vte_terminal_set_enable_bidi($!vt, $e);
  }

  method set_enable_shaping (Int() $enable_shaping)
    is also<set-enable-shaping>
  {
    my gboolean $e = $enable_shaping.so.Int;

    vte_terminal_set_enable_shaping($!vt, $enable_shaping);
  }

  method set_font (PangoFontDescription() $font_desc) is also<set-font> {
    vte_terminal_set_font($!vt, $font_desc);
  }

  method set_font_scale (Num() $scale) is also<set-font-scale> {
    my gdouble $s = $scale;

    vte_terminal_set_font_scale($!vt, $s);
  }

  method set_input_enabled (gboolean $enabled) is also<set-input-enabled> {
    my gboolean $e = $enabled.so.Int;

    vte_terminal_set_input_enabled($!vt, $e);
  }

  method set_mouse_autohide (gboolean $setting) is also<set-mouse-autohide> {
    my gboolean $s = $setting.so.Int;

    vte_terminal_set_mouse_autohide($!vt, $s);
  }

  method set_pty (VtePty() $pty) is also<set-pty> {
    vte_terminal_set_pty($!vt, $pty);
  }

  method set_scroll_on_keystroke (Int() $scroll)
    is also<set-scroll-on-keystroke>
  {
    my gboolean $s = $scroll.so.Int;

    vte_terminal_set_scroll_on_keystroke($!vt, $s);
  }

  method set_scroll_on_output (Int() $scroll) is also<set-scroll-on-output> {
    my gboolean $s = $scroll.so.Int;

    vte_terminal_set_scroll_on_output($!vt, $s);
  }

  method set_scrollback_lines (Int() $lines) is also<set-scrollback-lines> {
    my glong $l = $lines;

    vte_terminal_set_scrollback_lines($!vt, $l);
  }

  method set_size (Int() $columns, Int() $rows, :rev(:$reversed))
    is also<set-size>
  {
    my glong ($r, $c) = $reversed ?? ($rows, $columns) !! ($columns, $rows);

    vte_terminal_set_size($!vt, $c, $r);
  }

  method set_text_blink_mode (Int() $text_blink_mode)
    is also<set-text-blink-mode>
  {
    my VteTextBlinkMode $t = $text_blink_mode.so.Int;

    vte_terminal_set_text_blink_mode($!vt, $t);
  }

  method set_word_char_exceptions (Str() $exceptions)
    is also<set-word-char-exceptions>
  {
    vte_terminal_set_word_char_exceptions($!vt, $exceptions);
  }

  proto method spawn_sync (|)
    is also<spawn-sync>
    is DEPRECATED
  { * }

  multi method spawn_sync (
    Str() $working_directory,
    @argv,
    @envv,
    &child_setup (Pointer)         = Callable,
    Pointer $child_setup_data      = Pointer,
    GCancellable $cancellable      = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  ) {
    samewith(
      $working_directory,
      resolve-gstrv(@argv),
      resolve-gstrv(@envv),
      G_SPAWN_DEFAULT,
      VTE_PTY_DEFAULT,
      $,
      $cancellable,
      $error
    );
  }
  multi method spawn_sync (
    Str() $working_directory,
    @argv,
    @envv,
    Int() $spawn_flags             = G_SPAWN_DEFAULT,
    Int() $pty_flags               = VTE_PTY_DEFAULT,
    &child_setup (Pointer)         = Callable,
    Pointer $child_setup_data      = Pointer,
    GCancellable $cancellable      = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my $rv = samewith(
      $pty_flags,
      $working_directory,
      resolve-gstrv(@argv),
      resolve-gstrv(@envv),
      $spawn_flags,
      &child_setup,
      $,
      $cancellable,
      $error
    );

    $rv[0] ?? $rv.skip(1) !! Nil;
  }

  multi method spawn_sync (
    Int() $pty_flags,
    Str() $working_directory,
    CArray[Str] $argv,
    CArray[Str] $envv,
    Int() $spawn_flags,
    &child_setup (Pointer),
    Pointer $child_setup_data,
    $child_pid is rw,
    GCancellable $cancellable      = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all = False
  ) {
    my VtePtyFlags $pf = $pty_flags;
    my GSpawnFlags $sf = $spawn_flags;
    my GPid $cpid = 0;

    clear_error;
    my $rv = so vte_terminal_spawn_sync(
      $pf,
      $working_directory,
      $argv,
      $envv,
      $sf,
      &child_setup,
      $cpid,
      $cancellable,
      $error
    );
    set_error($error);
    $child_pid = $cpid;
    $all.not ?? $rv !! ($rv, $child_pid);
  }

  proto method spawn_async (|)
      is also<spawn-async>
  { * }

  multi method spawn_async (
    Int() $pty_flags,
    Str() $working_directory,
    @argv,
    @envv,
    Int() $timeout,
    &callback                                = Callable,
    gpointer $user_data                      = gpointer,
    &child_setup                             = Callable,
    gpointer $child_setup_data               = Pointer,
    GDestroyNotify $child_setup_data_destroy = Pointer,
    GCancellable() $cancellable              = GCancellable,
  ) {
    samewith(
      $pty_flags,
      $working_directory,
      resolve-gstrv(@argv),
      resolve-gstrv(@envv),
      G_SPAWN_DEFAULT,
      &child_setup,
      $child_setup_data,
      $child_setup_data_destroy,
      $timeout,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method spawn_async (
    Int() $pty_flags,
    Str() $working_directory,
    @argv,
    @envv,
    Int() $timeout,
    Int() $spawn_flags                       = G_SPAWN_DEFAULT,
    &callback                                = Callable,
    gpointer $user_data                      = gpointer,
    &child_setup                             = Callable,
    gpointer $child_setup_data               = Pointer,
    GDestroyNotify $child_setup_data_destroy = Pointer,
    GCancellable() $cancellable              = GCancellable,
  ) {
    samewith(
      $pty_flags,
      $working_directory,
      resolve-gstrv(@argv),
      resolve-gstrv(@envv),
      $spawn_flags,
      &child_setup,
      $child_setup_data,
      $child_setup_data_destroy,
      $timeout,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method spawn_async (
    Int() $pty_flags,
    Str() $working_directory,
    CArray[Str] $argv,
    CArray[Str] $envv,
    Int() $spawn_flags,
    GSpawnChildSetupFunc $child_setup,
    gpointer $child_setup_data,
    GDestroyNotify $child_setup_data_destroy,
    Int() $timeout,
    GCancellable() $cancellable = GCancellable,
    &callback                   = Callable,
    gpointer $user_data         = gpointer
  ) {
    my VtePtyFlags $pf = $pty_flags;
    my GSpawnFlags $sf = $spawn_flags;
    my gint         $t = $timeout;

    vte_terminal_spawn_async(
      $!vt,
      $pf,
      $working_directory,
      $argv,
      $envv,
      $sf,
      $child_setup,
      $child_setup_data,
      $child_setup_data_destroy,
      $timeout,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method unselect_all is also<unselect-all> {
    vte_terminal_unselect_all($!vt);
  }

  method watch_child (GPid $child_pid) is also<watch-child> {
    my GPid $c = $child_pid;

    vte_terminal_watch_child($!vt, $c);
  }

  method write_contents_sync (
    GOutputStream() $stream,
    Int() $flags,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<write-contents-sync>
  {
    my VteWriteFlags $f = $flags;

    vte_terminal_write_contents_sync($!vt, $stream, $f, $cancellable, $error);
  }

  method get_encoding is also<get-encoding> {
    vte_terminal_get_encoding($!vt)
  }

  method set_encoding (
    Str() $codeset,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<set-encoding>
  {
    clear_error;
    my $rv = so vte_terminal_set_encoding($!vt, $codeset, $error);
    set_error($error);
    $rv;
  }

}
