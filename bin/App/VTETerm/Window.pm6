use v6.c;

use VTE::Raw::Types;

use Pango::FontDescription;

use GIO::PropertyAction;
use GDK::Visual;
use GTK::ApplicationWindow;
use GTK::Box;
use GTK::Clipboard;
use GTK::MenuButton;
use GTK::Scrollbar;
use GTK::ToggleButton;
use GTK::Widget;
use VTE::Terminal;
use App::VTETerm::SearchPopover;
use App::VTETerm::Options;

my @action-entries = (
  GActionEntry.new('copy',       &action_copy_cb,       's' ),
  GActionEntry.new('copy-match', &action_copy_match_cb, 's' ),
  GActionEntry.new('paste',      &action_paste_cb           ),
  GActionEntry.new('reset',      &action_reset_cb,      'b' ),
  GActionEntry.new('find',       &action_find_cb            ),
  GActionEntry.new('quit',       &action_quit_cb            )
);

#| %%ui = ui/window.ui
class App::VTETerm::Window is GTK::ApplicationWindow {
  has Gtk::Scrollbar                $!scrollbar;
  has Gtk::Box                      $!terminal_box;
  #has Gtk::Box                      $!notifications-box;
  has Gtk::Widget                   $!readonly-emblem;
  #has Gtk::Button                   $!copy_button;
  #has Gtk::Button                   $!paste_button;
  has Gtk::ToggleButton             $!find-button;
  has Gtk::MenuButton               $!gear-button;

  has GPid                          $!child_pid;
  has GTK::Clipboard                $!clipboard;
  has VTE::Terminal                 $!terminal;
  has App::VTETerm::SearchPopover   $!search-popover;
  has                               $!launch-idle-id;

  has @!builtin-dingus = (
    '(((gopher|news|telnet|nntp|file|http|ftp|https)://)|(www|ftp)[-A-Za-z0-9]*\\.)[-A-Za-z0-9\\.]+(:[0-9]*)?',
    '(((gopher|news|telnet|nntp|file|http|ftp|https)://)|(www|ftp)[-A-Za-z0-9]*\\.)[-A-Za-z0-9\\.]+(:[0-9]*)?/[-A-Za-z0-9_\\$\\.\\+\\!\\*\\(\\),;:@&=\\?/~\\#\\%]*[^]\'\\.\}>\\) ,\\\']'
  );

  submethod BUILD {
    $!terminal = VTE::Terminal.new;
    if $OPTIONS.extra-margin -> $m {
      $!terminal.margins = $m;
    }
    $!scrollbar.adjustment = $!terminal.vadjustment

    self.add-action-entries($action_entries);

    my $action = GIO::PropertyAction.new('input-enable', $!terminal);
    add-action($action);
    $action.notify('state').tap(-> *@a {
      my $a = GIO::Roles::Action.new_action_object( cast(GAction, @a[0]) );
      $!readonly_emblem.visible = $a.state.boolean.not;
    });

    $!search-popover = App::VTETerm::SearchPopover.new(
      $terminal,
      $!find-button
    );
    $!search-popover.closed.tap({
      $!find-button.active = False if $!find-button.active
    });
    $!find-button.toggled.tap({
      my $a = $!find-button.active;
      $!search-popover.visible = $a if $!search-popover.visible = $a.not;
    });

    my ($menu, $section) = GIO::Menu.new xx 2;
    $section.append('_Copy', 'win.copy');
    $section.append('_Paste', 'win.paste');
    $section.append('_Find…', 'win.find');
    $menu.append-section($section);

    $section = GIO::Menu.new;
    $section.append('_Reset', 'win.reset(false)');
    $section.append('Reset and C_lear', 'win.reset(true)');
    $section.append('_Input enabled', 'win.input-enabled');
    $menu.append-section($section);

    $section = GIO::Menu.new;
    $section.append('_Quit', 'win.quit');
    $menu.append-section($section);

    $!gear-button.menu-model = $menu;

    $!clipboard = GTK::Clipboard.get(GDK_SELECTION_CLIPBOARD);
    $!clipboard.owner-change.tap(-> *@a { update-paste-sensitivity });

    self.title = 'Terminal';

    if $OPTIONS.transparency-percent {
      if $OPTIONS.no-argb-visual {
        if self.screen.rgba-visual -> $v {
          self.visual = $v;
        }
      }
      self.app-paintable = True;
    }

    # Signals
    with $!terminal {
      .popup-menu-connect.tap(-> *@a { self.show-context-menu });

      .button-press-event.tap(-> *@a {
        my $e = GDK::Event.new( @a[1] )
        @a[* - 1].r = 0 unless $e.typed-event.button == 3;
        @a[* - 1].r = self.show-context-menu($e.button, $e.time, $e);
      });

      .notify.tap(-> *@a {
        my $ps = GLib::Object::ParamSpec.new( @a[1] );
        my $psn = $ps.name;
        return unless $ps.owner-type == $!terminal.get-type;
        say "NOTIFY property \"{ $psn }\" value { $!terminal."$psn"() }";
      }) if $OPTIONS.object-notifications;

      .resize-window.tap(-> *@a ($t, $r, $c) {
         return unless $r > 2 && $c > 2;
         $!terminal.set-size($r, $c, :rev);
         # cw: XXX
         # self.resize-to-geometry() removed... do we need to use
         # self.resize? If so, we need the char size.
      });

      # ---
       .char-size-change.tap(-> *@a { self.update-geometry            });
           .child-exited.tap(-> *@a { self.handle-child-exited( |@a ) });
     .decrease-font-size.tap(-> *@a { self.adjust-font-size(1 / 1.2)  });
       .deiconify-window.tap(-> *@a { self.deiconify                  });
     .icon-title-changed.tap(-> *@a { self.window.icon_name =
                                      $!terminal.icon-title           });
         .iconify-window.tap(-> *@a { self.adjust-font-size(1.2)      });
           .lower-window.tap(-> *@a { return unless self.realized;
                                      self.window.lower               });
        .maximize-window.tap(-> *@a { self.maximize                   });
            .move-window.tap(-> *@a { self.move( |@a.skip(1) )        });
           .raise-window.tap(-> *@a { return unless self.realized;
                                      self.window.raise               });
         .refresh-window.tap(-> *@a { self.queue-draw                 });
                .restore.tap(-> *@a { self.restore                    });
      .selection-changed.tap(-> *@a { self.update-copy-sensitivity    });
    .window-title-change.tap(-> *@a { self.title = $!terminal.title   });
    # ---

    with $!terminal {

      if $OPTIONS.encoding -> $e {
        CATCH {
          when X::GLib::Error {
            $*ERR.say: "Failed to set encoding: { .message }";
          }
        }
        $!terminal.encoding = $e;
      }

      if $OPTIONS.work-char-exceptions -> $wce {
        $!terminal.word-char-exceptions = $wce;
      }

      .double-buffered     = $OPTIONS.no-double-buffer.not;
      .rewrap-on-resize    = $OPTIONS.no-rewrap.not;
      .audible-bell        = $OPTIONS.audible;
      .cjk-ambiguous-width = $OPTIONS.cjk-ambiguous-width;
      .cursor-shape        = $OPTIONS.cursor-shape;
      .cursor-blink-mode   = $OPTIONS.cursor-blink-mode;
      .mouse-autohide      = True;
      .scroll-on-output    = True;
      .scrollback-lines    = $OPTIONS.scrollback-lines;

      if $OPTIONS.font-string -> $f {
        .font = Pango::FontDescription.new-from-desc($f);
      }

      # ---
                .set-colors( |$OPTIONS.get-colors           );
         .set-cursor-colors( |$OPTIONS.get-cursor-colors    );
      .set-highlight-colors( |$OPTIONS.get-highlight-colors );
      # ---

      self!add-dingus(@builtin-dingus) unless $OPTIONS.no-builtin-dingus;
      if $OPTIONS.dingus -> $d {
        self.add-dingus($d);
      }

      $!terminal-box.pack-start($!terminal);
      $!terminal.show;

      self.update-paste-sensitivity;
      self.update-copy-sensitivity;

      die 'Window could not be set to REALIZED state!' unless self.realized;
    }

  }

  method !add-dingus(@dingus) {
    my @cursors = (GDK_CURSOR_TYPE_GUMBY, GDK_CURSOR_TYPE_HAND1);

    for @dingus.kv -> $k, $v {
      CATCH {
        when X::GLib::Error {
          $*ERR.say: "Failed to compile regex '$v': { .message }";
        }
      }

      my $tag = do if $OPTIONS.no-pcre.not {
        my $rf = [+|]( PCRE2_UTF,
                       PCRE2_NO_UTF_CHECK,
                       PCRE2_CASELESS,
                       PCRE2_MULTILINE );

        my $regex = VTE::Regex.new-for-match($v, .chars, $rf);
        try {
          CATCH {
            when X::GLib::Error {
              $*ERR.say: "JITing regex '$v' failed: { .message }";
            }
          }
          $regex.jit(PCRE2_JIT_COMPLETE);
          $regex.jit(PCRE2_JIT_PARTIAL_SOFT);
        }
        $!terminal.match-add-regex($regex);
      } else {
        my $rf = [+|]( G_REGEX_COMPILE_FLAG_OPTIMIZE,
                       G_REGEX_COMPILE_FLAG_MULTILINE );

        my $regex = GLib::Regex.new($v, $rf);
        $!terminal.match-add-gregex($regex);
      }

      $!terminal.match-set-cursor-type( $tag, @cursors[$k % @cursors.elems] );
    }
  }

  method !adjust-font-size (Num() $factor) {
    my ($r, $c) = $!terminal.get-size;
    $!terminal.font-scale *= $factor;

    self!update_geometry()
    #self.resize-to-geometry -- cw: use self.resize!s
  }

  multi method show-context-menu {
    samewith(0, GDK::Event.time);
  }
  multi method show-context-menu (
    Int() $button,
    Int() $timestamp,
    GdkEvent() $event = GdkEvent
    --> Int
  ) {
    return 0 unless $OPTIONS.no-context-menu;

    my $menu = GLib::Menu;
    $menu.append('_Copy', 'win.copy::text');
    $menu.append('Copy As _HTML', 'win.copy::html');

    if $event {
      if $!terminal.hyperlink-check-event($event) -> $hyperlink {
        $menu.append('Copy _Hyperlink', 'win.copy-match::' ~ $hyperlink)
      }
      if $!terminal.match_check_event($event) -> $match {
        $menu.append('Copy _Match', 'win.copy-match::' ~ $match);
      }
    }
    $menu,.append('_Paste');

    my $popup = GTK::Menu.new($menu, :model);
    $popup.attach-to-widget(self);
    $popup.popup-at-pointer;
    $popup.select-first unless $button;
    1;
  }

  multi handle-child-exited ($t, $s) {
    $*ERR.say: "Child exited with status { $s.fmt('%x') }";

    if $OPTIONS.output-filename -> $fn {
      try {
        CATCH {
          default {
            $*ERR.say: "Failed to write output to { $fn } { .message }"
          }
        }
        with GIO::Roles::GFile.new-for-commandline-arg($fn) {
          $!terminal.write-contents-sync($_) with .replace;
        }
      }
    }

    return unless $OPTIONS.keep;

    self.destroy;
  }

}
