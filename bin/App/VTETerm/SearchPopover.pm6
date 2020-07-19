use v6.c;

use VTE::Raw::Types;

use GTK::Button;
use GTK::Popover;
use GTK::Revealer;
use GTK::SearchEntry;
use GTK::ToggleButton;
use VTE::Regex;
use VTE::Terminal;
use App::VTETerm::Options;

our subset AppVTETermSearchPopoverAncestry is export of Mu
  where PopoverAncestry;

#| %%ui = ui/search-popover.ui
class App::VTETerm::SearchPopover is GTK::Popover {
  has VTE::Terminal       $.terminal;

  has GTK::SearchEntry    $!search-entry            .= new;
  has GTK::Button         $!search-prev-button      .= new;
  has GTK::Button         $!search-next-button      .= new;
  has GTK::Button         $!close-button            .= new;
  has GTK::ToggleButton   $!match-case-checkbutton  .= new;
  has GTK::ToggleButton   $!entire-word-checkbutton .= new;
  has GTK::ToggleButton   $!regex-checkbutton       .= new;
  has GTK::ToggleButton   $!wrap-around-checkbutton .= new;
  has GTK::Button         $!reveal-button           .= new;
  has GTK::Revealer       $!revealer                .= new;
  has Bool                $!caseless                 = False;
  has Bool                $.has-regex                = False;
  has Str                 $!pattern                  = Str;

  submethod BUILD (:$term) {
    $!terminal = $term;

    $!close-button.clicked.tap({ self.hide });
    $!reveal-button.bind('active', $!revealer, 'reveal-child');

    # ---
            $!search-entry.next-match.tap({ self!search(False) });
        $!search-entry.previous-match.tap({ self!search(True)  });
        $!search-entry.search-changed.tap({ self!update-regex  });
         $!search-next-button.clicked.tap({ self!search(False) });
         $!search-prev-button.clicked.tap({ self!search(True)  });
     $!match-case-checkbutton.toggled.tap({ self!update-regex  });
    $!entire-word-checkbutton.toggled.tap({ self!update-regex  });
          $!regex-checkbutton.toggled.tap({ self!update-regex  });
    # ---

    $!wrap-around-checkbutton.toggled.tap({
      $!terminal.search-set-wrap-around($!wrap-around-checkbutton.active);
    });

    self!update-sensitivity;
  }

  method new ($term, $relative-to) {
    self.new-relative-to($relative-to, :$term);
  }

  method !update-sensitivity {
    $!search-prev-button.set-sensitive($.has-regex);
    $!search-next-button.set-sensitive($.has-regex);
  }

  method !update-regex {
    my $pattern;
    my ($search-text, $caseless) =
      ($!search-entry.text, $!match-case-checkbutton.active);

    $pattern = $!regex-checkbutton.active
      ?? $search-text
      !! GLib::Regex.escape-string($search-text);
    $pattern = '\b' ~ $pattern ~ '\b' if $!entire-word-checkbutton.active;
    return if $!caseless eq $caseless && $!pattern eq $pattern;

    $!pattern  = Str;
    $!caseless = $caseless;

    my ($regex, $gregex);
    if $search-text.chars.not {
      try {
        CATCH {
          when X::GLib::GError {
            $!search-entry.tooltip-text = .message;
            $regex = $gregex = Nil;
          }
        }

        if $OPTIONS.no-pcre.not {
          my $flags = 0x40080400;  # PCRE2_UTF | PCRE2_NO_UTF_CHECK | PCRE2_MULTILINE

          $flags  +|= 0x00000008 if $caseless; # PCRE2_CASELESS
          $regex    = VTE::Regex.new-for-search($pattern, $flags);

          try {
            CATCH {
              when X::GLib::GError {
                # PCRE2_ERROR_JIT_BADOPTION -- JIT not supported
                if .code != -45 {
                  $*ERR.say:
                    "JITing regex \"{ $pattern }\" failed: { .message }";
                }
              }
            }

            $regex.jit(0x00000001); # PCRE2_JIT_COMPLETE
            $regex.jit(0x00000002); # PCRE2_JIT_PARTIAL_SOFT
          }
        } else {
          my $flags = G_REGEX_OPTIMIZE +| G_REGEX_MULTILINE;

          $flags +|= G_REGEX_CASELESS if $caseless;
          $gregex = GLib::Regex.new($pattern, $flags);
        }

        $regex = $pattern;
        $!search-entry.tooltip-text('');
      }
    } else {
      $regex = $gregex = Nil;
    }

    if $OPTIONS.no-pcre.not {
      $!has-regex = $regex.defined;
      $!terminal.search-set-regex($regex);
    } else {
      $!has-regex = $gregex.defined;
      $!terminal.search-set-regex($gregex);
    }

    self!update-sensitivity;
  }

  method !search($back) {
    return unless $!has-regex;
    $back ?? $!terminal.search-find-previous !! $!terminal.search-find-next;
  }

}
