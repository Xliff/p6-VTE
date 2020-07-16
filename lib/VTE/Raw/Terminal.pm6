use v6.c;

use NativeCall;

use VTE::Raw::Types;
use GDK::RGBA;

unit package VTE::Raw::Terminal;

### /usr/include/vte-2.91/vte/vteterminal.h

sub vte_terminal_copy_clipboard_format (
  VteTerminal $terminal,
  VteFormat $format
)
  is native(vte)
  is export
{ * }

sub vte_terminal_copy_primary (VteTerminal $terminal)
  is native(vte)
  is export
{ * }

sub vte_terminal_event_check_regex_simple (
  VteTerminal $terminal,
  GdkEvent $event,
  CArray[VteRegex] $regexes,
  gsize $n_regexes,
  guint32 $match_flags,
  CArray[Str] $matches
)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_feed (VteTerminal $terminal, Str $data, gssize $length)
  is native(vte)
  is export
{ * }

sub vte_terminal_feed_child (
  VteTerminal $terminal,
  Str $text,
  gssize $length
)
  is native(vte)
  is export
{ * }

sub vte_terminal_get_allow_hyperlink (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_audible_bell (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_bold_is_bright (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_cell_height_scale (VteTerminal $terminal)
  returns gdouble
  is native(vte)
  is export
{ * }

sub vte_terminal_get_cell_width_scale (VteTerminal $terminal)
  returns gdouble
  is native(vte)
  is export
{ * }

sub vte_terminal_get_char_height (VteTerminal $terminal)
  returns glong
  is native(vte)
  is export
{ * }

sub vte_terminal_get_char_width (VteTerminal $terminal)
  returns glong
  is native(vte)
  is export
{ * }

sub vte_terminal_get_cjk_ambiguous_width (VteTerminal $terminal)
  returns gint
  is native(vte)
  is export
{ * }

sub vte_terminal_get_color_background_for_draw (
  VteTerminal $terminal,
  GdkRGBA $color
)
  is native(vte)
  is export
{ * }

sub vte_terminal_get_column_count (VteTerminal $terminal)
  returns glong
  is native(vte)
  is export
{ * }

sub vte_terminal_get_current_directory_uri (VteTerminal $terminal)
  returns Str
  is native(vte)
  is export
{ * }

sub vte_terminal_get_current_file_uri (VteTerminal $terminal)
  returns Str
  is native(vte)
  is export
{ * }

sub vte_terminal_get_cursor_blink_mode (VteTerminal $terminal)
  returns VteCursorBlinkMode
  is native(vte)
  is export
{ * }

sub vte_terminal_get_cursor_position (
  VteTerminal $terminal,
  glong $column,
  glong $row
)
  is native(vte)
  is export
{ * }

sub vte_terminal_get_cursor_shape (VteTerminal $terminal)
  returns VteCursorShape
  is native(vte)
  is export
{ * }

sub vte_terminal_get_enable_bidi (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_enable_shaping (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_font (VteTerminal $terminal)
  returns PangoFontDescription
  is native(vte)
  is export
{ * }

sub vte_terminal_get_font_scale (VteTerminal $terminal)
  returns gdouble
  is native(vte)
  is export
{ * }

sub vte_terminal_get_has_selection (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_input_enabled (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_mouse_autohide (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_pty (VteTerminal $terminal)
  returns VtePty
  is native(vte)
  is export
{ * }

sub vte_terminal_get_row_count (VteTerminal $terminal)
  returns glong
  is native(vte)
  is export
{ * }

sub vte_terminal_get_scroll_on_keystroke (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_scroll_on_output (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_get_scrollback_lines (VteTerminal $terminal)
  returns glong
  is native(vte)
  is export
{ * }

sub vte_terminal_get_text (
  VteTerminal $terminal,
  &is_selected (VteTerminal, glong, glong, gpointer --> gboolean),
  gpointer $user_data,
  GArray $attributes
)
  returns Str
  is native(vte)
  is export
{ * }

sub vte_terminal_get_text_blink_mode (VteTerminal $terminal)
  returns VteTextBlinkMode
  is native(vte)
  is export
{ * }

sub vte_terminal_get_text_range (
  VteTerminal $terminal,
  glong $start_row,
  glong $start_col,
  glong $end_row,
  glong $end_col,
  &is_selected (VteTerminal, glong, glong, gpointer --> gboolean),
  gpointer $user_data,
  GArray $attributes
)
  returns Str
  is native(vte)
  is export
{ * }

sub vte_terminal_get_type ()
  returns GType
  is native(vte)
  is export
{ * }

sub vte_terminal_get_window_title (VteTerminal $terminal)
  returns Str
  is native(vte)
  is export
{ * }

sub vte_terminal_get_word_char_exceptions (VteTerminal $terminal)
  returns Str
  is native(vte)
  is export
{ * }

sub vte_terminal_hyperlink_check_event (
  VteTerminal $terminal,
  GdkEvent $event
)
  returns Str
  is native(vte)
  is export
{ * }

sub vte_terminal_match_add_regex (
  VteTerminal $terminal,
  VteRegex $regex,
  guint32 $flags
)
  returns gint
  is native(vte)
  is export
{ * }

sub vte_terminal_match_check_event (
  VteTerminal $terminal,
  GdkEvent $event,
  gint $tag is rw
)
  returns Str
  is native(vte)
  is export
{ * }

sub vte_terminal_match_remove (VteTerminal $terminal, gint $tag)
  is native(vte)
  is export
{ * }

sub vte_terminal_match_remove_all (VteTerminal $terminal)
  is native(vte)
  is export
{ * }

sub vte_terminal_match_set_cursor_name (
  VteTerminal $terminal,
  gint $tag,
  Str $cursor_name
)
  is native(vte)
  is export
{ * }

sub vte_terminal_new ()
  returns GtkWidget
  is native(vte)
  is export
{ * }

sub vte_terminal_paste_clipboard (VteTerminal $terminal)
  is native(vte)
  is export
{ * }

sub vte_terminal_paste_primary (VteTerminal $terminal)
  is native(vte)
  is export
{ * }

sub vte_terminal_pty_new_sync (
  VteTerminal $terminal,
  VtePtyFlags $flags,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns VtePty
  is native(vte)
  is export
{ * }

sub vte_terminal_reset (
  VteTerminal $terminal,
  gboolean $clear_tabstops,
  gboolean $clear_history
)
  is native(vte)
  is export
{ * }

sub vte_terminal_search_find_next (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_search_find_previous (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_search_get_regex (VteTerminal $terminal)
  returns VteRegex
  is native(vte)
  is export
{ * }

sub vte_terminal_search_get_wrap_around (VteTerminal $terminal)
  returns uint32
  is native(vte)
  is export
{ * }

sub vte_terminal_search_set_regex (
  VteTerminal $terminal,
  VteRegex $regex,
  guint32 $flags
)
  is native(vte)
  is export
{ * }

sub vte_terminal_search_set_wrap_around (
  VteTerminal $terminal,
  gboolean $wrap_around
)
  is native(vte)
  is export
{ * }

sub vte_terminal_select_all (VteTerminal $terminal)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_allow_hyperlink (
  VteTerminal $terminal,
  gboolean $allow_hyperlink
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_audible_bell (VteTerminal $terminal, gboolean $is_audible)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_backspace_binding (
  VteTerminal $terminal,
  VteEraseBinding $binding
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_bold_is_bright (
  VteTerminal $terminal,
  gboolean $bold_is_bright
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_cell_height_scale (VteTerminal $terminal, gdouble $scale)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_cell_width_scale (VteTerminal $terminal, gdouble $scale)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_cjk_ambiguous_width (VteTerminal $terminal, gint $width)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_clear_background (
  VteTerminal $terminal,
  gboolean $setting
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_color_background (
  VteTerminal $terminal,
  GdkRGBA $background
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_color_bold (VteTerminal $terminal, GdkRGBA $bold)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_color_cursor (
  VteTerminal $terminal,
  GdkRGBA $cursor_background
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_color_cursor_foreground (
  VteTerminal $terminal,
  GdkRGBA $cursor_foreground
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_color_foreground (
  VteTerminal $terminal,
  GdkRGBA $foreground
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_color_highlight (
  VteTerminal $terminal,
  GdkRGBA $highlight_background
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_color_highlight_foreground (
  VteTerminal $terminal,
  GdkRGBA $highlight_foreground
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_colors (
  VteTerminal $terminal,
  GdkRGBA $foreground,
  GdkRGBA $background,
  Pointer $palette,
  gsize $palette_size
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_cursor_blink_mode (
  VteTerminal $terminal,
  VteCursorBlinkMode $mode
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_cursor_shape (
  VteTerminal $terminal,
  VteCursorShape $shape
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_default_colors (VteTerminal $terminal)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_delete_binding (
  VteTerminal $terminal,
  VteEraseBinding $binding
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_enable_bidi (VteTerminal $terminal, gboolean $enable_bidi)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_enable_shaping (
  VteTerminal $terminal,
  gboolean $enable_shaping
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_font (
  VteTerminal $terminal,
  PangoFontDescription $font_desc
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_font_scale (VteTerminal $terminal, gdouble $scale)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_input_enabled (VteTerminal $terminal, gboolean $enabled)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_mouse_autohide (VteTerminal $terminal, gboolean $setting)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_pty (VteTerminal $terminal, VtePty $pty)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_scroll_on_keystroke (
  VteTerminal $terminal,
  gboolean $scroll
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_scroll_on_output (VteTerminal $terminal, gboolean $scroll)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_scrollback_lines (VteTerminal $terminal, glong $lines)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_size (VteTerminal $terminal, glong $columns, glong $rows)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_text_blink_mode (
  VteTerminal $terminal,
  VteTextBlinkMode $text_blink_mode
)
  is native(vte)
  is export
{ * }

sub vte_terminal_set_word_char_exceptions (
  VteTerminal $terminal,
  Str $exceptions
)
  is native(vte)
  is export
{ * }

sub vte_terminal_spawn_async (
  VteTerminal $terminal,
  VtePtyFlags $pty_flags,
  Str $working_directory,
  CArray[Str] $argv,
  CArray[Str] $envv,
  GSpawnFlags $spawn_flags_,
  GSpawnChildSetupFunc $child_setup,
  gpointer $child_setup_data,
  GDestroyNotify $child_setup_data_destroy,
  gint $timeout,
  GCancellable $cancellable,
  &callback (VteTerminal, GPid, GError, gpointer),
  gpointer $user_data
)
  is native(vte)
  is export
{ * }

sub vte_terminal_unselect_all (VteTerminal $terminal)
  is native(vte)
  is export
{ * }

sub vte_terminal_watch_child (VteTerminal $terminal, GPid $child_pid)
  is native(vte)
  is export
{ * }

sub vte_terminal_write_contents_sync (
  VteTerminal $terminal,
  GOutputStream $stream,
  VteWriteFlags $flags,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(vte)
  is export
{ * }

# Deprecated
sub vte_terminal_get_encoding (VteTerminal $terminal)
  returns Str
  is DEPRECATED
  is native(vte)
  is export
{ * }

sub vte_terminal_set_encoding (
  VteTerminal $terminal,
  Str $codeset,
  CArray[Pointer[GError]] $error
)
  returns gboolean
  is DEPRECATED
  is native(vte)
  is export
{ * }
