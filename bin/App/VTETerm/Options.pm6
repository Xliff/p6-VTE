use v6.c;

use VTE::Raw::Types;

use GDK::RGBA;

class App::VTETerm::Options {
  has Str  @.dingus                         = ();
  has Str  @.environment                    = ();
  has Str  $.cjk-ambiguous-width-string     = ''    is rw;
  has Str  $.command                        = ''    is rw;
  has Str  $.cursor-background-color-string = ''    is rw;
  has Str  $.cursor-blink-mode-string       = ''    is rw;
  has Str  $.cursor-foreground-color-string = ''    is rw;
  has Str  $.cursor-shape-string            = ''    is rw;
  has Str  $.encoding                       = ''    is rw;
  has Str  $.font-string                    = ''    is rw;
  has Str  $.geometry                       = ''    is rw;
  has Str  $.hl-bg-color-string             = ''    is rw;
  has Str  $.hl-fg-color-string             = ''    is rw;
  has Str  $.icon-title                     = ''    is rw;
  has Str  $.output-filename                = ''    is rw;
  has Str  $.word-char-exceptions           = ''    is rw;
  has Str  $.working-directory              = ''    is rw;
  has Bool $.audible                        = False is rw;
  has Bool $.debug                          = False is rw;
  has Bool $.keep                           = False is rw;
  has Bool $.no-argb-visual                 = False is rw;
  has Bool $.no-builtin-dingus              = False is rw;
  has Bool $.no-context-menu                = False is rw;
  has Bool $.no-double-buffer               = False is rw;
  has Bool $.no-geometry-hints              = False is rw;
  has Bool $.no-hyperlink                   = False is rw;
  has Bool $.no-pcre                        = False is rw;
  has Bool $.no-rewrap                      = False is rw;
  has Bool $.no-shell                       = False is rw;
  has Bool $.object-notifications           = False is rw;
  has Bool $.reverse                        = False is rw;
  has Bool $.version                        = False is rw;
  has Int  $.extra-margin                   = 0     is rw;
  has Int  $.n-windows                      = 1     is rw;
  has Int  $.scrollback-lines               = 512   is rw;
  has Int  $.transparency-percent           = 0     is rw;

  method get-color (Str() $s) {
    return Nil unless $s;
    my $c = GDK::RGBA.new;
    unless $c.parse($s) {
      $*ERR.say: "Failed to parse '{ $s }' as color.";
      return Nil;
    }
    $c;
  }

  method get-color-cursor-background {
    self!get-color($!cursor-background-color-string);
  }

  method get-color-cursor-foreground {
    self!get-color($!cursor-foreground-color-string);
  }

  method get-color-hl-bg { self!get-color($!hl-bg-color-string) }
  method get-color-hl-fg { self!get-color($!hl-fg-color-string) }

  method get-cursor-blink-mode {
    getEnumValueByNick(VteCursorBlinkModeEnum, $!cursor-blink-mode-string);
  }

  method get-cursor-shape {
    getEnumValueByNick(VteCursorShapeEnum, $!cursor-cursor-shape-string);
  }
}

our $OPTIONS is export;
INIT {
  $OPTIONS = Options.new;
}
