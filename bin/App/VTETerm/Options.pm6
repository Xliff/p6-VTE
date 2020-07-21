use v6.c;

use VTE::Raw::Types;

use GDK::RGBA;

class App::VTETerm::Options {
  has Str  @.dingus                                = ()   ;
  has Str  @.environment                           = ()   ;
  has Str  $.cursor-background-color-string  is rw = ''   ;
  has Str  $.cursor-blink-mode-string        is rw = ''   ;
  has Str  $.cursor-foreground-color-string  is rw = ''   ;
  has Str  $.cursor-shape-string             is rw = ''   ;
  has Str  $.hl-bg-color-string              is rw = ''   ;
  has Str  $.hl-fg-color-string              is rw = ''   ;
  has Str  $.cjk-ambiguous-width-string      is rw = ''   ;
  has Str  $.command                         is rw = ''   ;
  has Str  $.encoding                        is rw = ''   ;
  has Str  $.font-string                     is rw = ''   ;
  has Str  $.geometry                        is rw = ''   ;
  has Str  $.icon-title                      is rw = ''   ;
  has Str  $.output-filename                 is rw = ''   ;
  has Str  $.word-char-exceptions            is rw = ''   ;
  has Str  $.working-directory               is rw = ''   ;
  has Bool $.audible                         is rw = False;
  has Bool $.debug                           is rw = False;
  has Bool $.keep                            is rw = False;
  has Bool $.no-argb-visual                  is rw = False;
  has Bool $.no-builtin-dingus               is rw = False;
  has Bool $.no-context-menu                 is rw = False;
  has Bool $.no-double-buffer                is rw = False;
  has Bool $.no-geometry-hints               is rw = False;
  has Bool $.no-hyperlink                    is rw = False;
  has Bool $.no-pcre                         is rw = False;
  has Bool $.no-rewrap                       is rw = False;
  has Bool $.no-shell                        is rw = False;
  has Bool $.object-notifications            is rw = False;
  has Bool $.reverse                         is rw = False;
  has Bool $.version                         is rw = False;
  has Int  $.extra-margin                    is rw = 0    ;
  has Int  $.n-windows                       is rw = 1    ;
  has Int  $.scrollback-lines                is rw = 512  ;
  has Int  $.transparency-percent            is rw = 0    ;

  method !get-color (Str() $s) {
    return Nil unless $s;
    my $c = GDK::RGBA.new;
    unless $c.parse($s) {
      $*ERR.say: "Failed to parse '{ $s }' as color.";
      return Nil;
    }
    $c;
  }

  method get-colors {
    (
      self!get-color($!cursor-foreground-color-string),
      self!get-color($!cursor-background-color-string)
    )
  }

  method get-cursor-colors {
    (
      self.color-cursor-foreground,
      self.color-cursor-background
    )
  }

  method get-hl-colors {
    (
      self.color-hl-fg,
      self.color-hl-bg
    )
  }

  method color-cursor-background {
    self!get-color($!cursor-background-color-string);
  }

  method color-cursor-foreground {
    self!get-color($!cursor-foreground-color-string);
  }

  method color-hl-bg { self!get-color($!hl-bg-color-string) }
  method color-hl-fg { self!get-color($!hl-fg-color-string) }

  method cursor-blink-mode {
    getEnumValueByNick(VteCursorBlinkModeEnum, $!cursor-blink-mode-string);
  }

  method cursor-shape {
    getEnumValueByNick(VteCursorShapeEnum, $!cursor-shape-string);
  }
}

our $OPTIONS is export;
INIT {
  $OPTIONS = App::VTETerm::Options.new;
}
