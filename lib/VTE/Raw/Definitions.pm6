use v6.c;

use NativeCall;

use Pango::Raw::Types;

use GLib::Roles::Pointers;

unit package VTE::Raw::Definitions;

our constant vte is export = 'vte-2.91',v0;

class VtePty      is repr<CPointer> does GLib::Roles::Pointers is export { }
class VteRegex    is repr<CPointer> does GLib::Roles::Pointers is export { }
class VteTerminal is repr<CPointer> does GLib::Roles::Pointers is export { }

class VteCharAttributes is repr<CStruct> does GLib::Roles::Pointers is export {
    has glong      $.row;
    has glong      $.column;
    HAS PangoColor $.fore,
    HAS PangoColor $.back;
    has guint      $!fields; # guint underline:1, strikethrough:1, columns:4;
}

constant VteCursorBlinkMode is export := guint32;
our enum VteCursorBlinkModeEnum is export <
  VTE_CURSOR_BLINK_SYSTEM
  VTE_CURSOR_BLINK_ON
  VTE_CURSOR_BLINK_OFF
>;

constant VteCursorShape is export := guint32;
our enum VteCursorShapeEnum is export <
  VTE_CURSOR_SHAPE_BLOCK
  VTE_CURSOR_SHAPE_IBEAM
  VTE_CURSOR_SHAPE_UNDERLINE
>;

constant VteEraseBinding is export := guint32;
our enum VteEraseBindingEnum is export <
  VTE_ERASE_AUTO
  VTE_ERASE_ASCII_BACKSPACE
  VTE_ERASE_ASCII_DELETE
  VTE_ERASE_DELETE_SEQUENCE
  VTE_ERASE_TTY
>;

constant VteFormat is export := guint32;
our enum VteFormatEnum is export (
  VTE_FORMAT_TEXT => 1,
  VTE_FORMAT_HTML => 2,
);

constant VtePtyError is export := guint32;
our enum VtePtyErrorEnum is export (
  VTE_PTY_ERROR_PTY_HELPER_FAILED => 0,
  'VTE_PTY_ERROR_PTY98_FAILED'
);

constant VtePtyFlags is export := guint32;
our enum VtePtyFlagsEnum is export (
  VTE_PTY_NO_LASTLOG  => 1 +< 0,
  VTE_PTY_NO_UTMP     => 1 +< 1,
  VTE_PTY_NO_WTMP     => 1 +< 2,
  VTE_PTY_NO_HELPER   => 1 +< 3,
  VTE_PTY_NO_FALLBACK => 1 +< 4,
  VTE_PTY_NO_SESSION  => 1 +< 5,
  VTE_PTY_NO_CTTY     => 1 +< 6,
  VTE_PTY_DEFAULT     =>      0,
);

constant VteTextBlinkMode is export := guint32;
our enum VteTextBlinkModeEnum is export (
  VTE_TEXT_BLINK_NEVER     => 0,
  VTE_TEXT_BLINK_FOCUSED   => 1,
  VTE_TEXT_BLINK_UNFOCUSED => 2,
  VTE_TEXT_BLINK_ALWAYS    => 3,
);

constant VteWriteFlags is export := guint32;
our enum VteWriteFlagsEnum is export (
  VTE_WRITE_DEFAULT => 0,
);

constant VteTestFlags is export := guint64;
our enum VteTestFlagsEnum is export (
  VTE_TEST_FLAGS_NONE => 0,
  VTE_TEST_FLAGS_ALL  => 2 ** 64 - 1
);
