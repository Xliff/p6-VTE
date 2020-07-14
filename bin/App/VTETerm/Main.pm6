use v6.c;

unit package App::VTETerm::Main;

use App::VTETerm::App;
use App::VTETerm::Options;

my %PARAMETERS;

my token func-call { '(&' (<[\w_\-]>+)? ')' }
my token get-set   { '(=' (<[\w_\-]>+)? ')' }
my token valiation { '(values:' .+? ')'     }

class Config {
  my $version = v0.0.1;

  method version { $version };
}

sub version (|) {
  say "Simpler VTE Test Application { Config.version }";
  exit 0;
}

sub debug ($d) {
  GDK::Window.set-debug-upates($d);
}

sub MAIN (
  Bool :a(:$audible-bell),           #= Use audible terminal bell (=audible)
  Str  :c(:$command),                #= Execute a command in the terminal (=)
  Str  :$cjk-width                   #= Specify the cjk ambiguious width to use for UTF-8 encoing (=cjk-ambiguous-with-string)
  Str  :$cursor-blink                #= Cursor blink mode (values:system|on|off) (=cursor-blink-mode-string)
  Str  :$cursor-background-color,    #= Enable a colored cursor background (=cursor-background-color-string)
  Str  :$cursor-foreground-color     #= Enable a colored cursor foreground (=cursor-foreground-color-string)
  Str  :$cursor-shape,               #= Set cursor shape (values:block|underline|ibeam) (=cursor-shape-string)
  Str  :D(:@dingu),                  #= Add regex highlight (=dingus)
  Bool :d(:$debug),                  #= Enable various debugging checks (&ebug)
  Str  :$encoding,                   #= Specify the terminal encoding to use (=)
  Str  :@env,                        #= Add environment variable to the child's environment (=environment)
  Int  :$extra-margin,               #= Add extra margin around the terminal widget (=)
  Str  :f(:$font),                   #= Specify a font to use (=font-string)
  Bool :$gregex,                     #= Use GRegex instead of PCRE2 (&no-pcre)
  Str  :g(:$geometry),               #= Set the size (in characters) and position (=geometry)
  Str  :$highlight-background-color  #= Enable distinct highlight background color for selection (=)
  Str  :$highlight-foreground-color, #= Enable distinct highlight foreground color for selection (=)
  Str  :i(:$icon-title),             #= Enable the setting of the icon title (=)
  Bool :k(:$keep),                   #= Live on after the command exits (=)
  Bool :$no-argb-visual,             #= Don't use an ARGB visual (=)
  Bool :$no-builtin-dingus           #= Highlight URLs inside the terminal (=)
  Bool :$no-context-menu,            #= Disable context menu (=)
  Bool :two($no-double-buffer),      #= Disable double-buffering (=)
  Bool :G($no-geometry-hints),       #= Allow the terminal to be resized to any dimension, not constrained to fit to an integer multiple of characters (=)
  Bool :H(:$no-hyperlink),           #= Disable hyperlinks (=)
  Bool :R(:$no-rewrap),              #= Disable rewrapping on resize (=)
  Bool :S(:$no-shell),               #= Disable spawning a shell inside the terminal (=)
  Bool :N(:$object-notifications),   #= Print VteTerminal object notifications (=)
  Str  :$output-file,                #= Save terminal contents to file at exit (=)
  Bool :$reverse,                    #= Reverse foreground/background colors (=)
  Int  :n(:$scrollback-lines),       #= Specify the number of scrollback-lines (=)
  Int  :T(:$transparent),            #= Enable the use of a transparent background (values:0..100) (=transparency-percent)
  Bool :$version,                    #= Show version (&version)
  Int  :$windows = 1,                #= Open multiple windows (default: 1) (=n-windows)
  Str  :$word-char-exceptions,       #= Specify the word char exceptions (=)
  Str  :w($working-directory)        #= Specify the initial working directory of the terminal (=)
)
  is export
{
  for %PARAMETERS.keys {
    my $pv = ::("{ %PARAMETERS{$_} }");
    my $pc = %PARAMETERS.WHY.trailing;

    if $pv &&  $pc ~~ func-call {
      "$0"( $pv )
    }

    if $pc ~~ get-set {
      my $attr = $0 // $_;

      if $pc ~~ validate {
        if $0.contains('|') {
          die "Parameter $_ contains invalid value '{ $pv }'"
            unless $pv eq $0.split('|').any;
        } elsif $0.contains('..') {
          my ($to, $from) = $0.split('..');
          die "Parameter $_ is out of range. Must be in range { $0 }"
            unless $pv ~~ $to .. $from;
        }
      }

      $OPTIONS."{ $attr }" = $pv
    }
  }

  App::VTETerm::App.new.run;
}

sub USAGE is export {
  for $*USAGE ~~ m:g/<func-call>/ {
    with .<func-call> {
      $*USAGE.substr-rw(.from, .to - .from) = '';
    }
  }
  for $*USAGE ~~ m:g/<get-set>/ {
    with .<get-set> {
      $*USAGE.substr-rw(.from, .to - .from) = '';
    }
  }
  $*USAGE.say;
}


BEGIN {
  %PARAMETERS = (gather for &MAIN.signature.params.kv -> $k, $v {
    take Pair.new($v.name, $k);
  }).Hash

  $*USAGE.say;
}
