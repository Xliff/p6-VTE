use v6.c;

use VTE::Raw::Types;

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
  }

}
