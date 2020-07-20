use v6.c;

unit package App::VTETerm::Main;

use App::VTETerm::App;
use App::VTETerm::Options;

our %PARAMETERS is export;

my token func-call  { '(&' (<[\w_\-]>+)? ')' }
my token get-set    { '(=' (<[\w_\-]>+)? ')' }
my token validation { '(values:' .+? ')'     }

class App::VTETerm::Config {
  my $version = v0.0.1;

  method version { $version };
}

sub version (|) {
  say "Simpler VTE Test Application { App::VTETerm::Config.version }";
  exit 0;
}

sub debug ($d) {
  GDK::Window.set-debug-upates($d);
}

# Not being called?
sub GENERATE-USAGE (&main, |c) {
  my $usage = &*GENERATE-USAGE(&main, |c);

  for $usage ~~ m:g/<func-call>/ {
    .gist.say;
    with .<func-call> {
      $usage.substr-rw(.from, .to - .from) = '';
    }
  }
  for $usage ~~ m:g/<get-set>/ {
    .gist.say;
    with .<get-set> {
      $usage.substr-rw(.from, .to - .from) = '';
    }
  }
  $usage
}

sub MAIN (
  Bool :$gregex,                     #= Use GRegex instead of PCRE2 (&no-pcre)
  Bool :$no-argb-visual,             #= Don't use an ARGB visual (=)
  Bool :$no-builtin-dingus,          #= Highlight URLs inside the terminal (=)
  Bool :$no-context-menu,            #= Disable context menu (=)
  Bool :$reverse,                    #= Reverse foreground/background colors (=)
  Bool :$version,                    #= Show version (&version)
  Bool :a(:$audible-bell),           #= Use audible terminal bell (=audible)
  Bool :d(:$debug),                  #= Enable various debugging checks (&ebug)
  Bool :G(:$no-geometry-hints),      #= Allow the terminal to be resized to any dimension, not constrained to fit to an integer multiple of characters (=)
  Bool :H(:$no-hyperlink),           #= Disable hyperlinks (=)
  Bool :k(:$keep),                   #= Live on after the command exits (=)
  Bool :N(:$object-notifications),   #= Print VteTerminal object notifications (=)
  Bool :R(:$no-rewrap),              #= Disable rewrapping on resize (=)
  Bool :S(:$no-shell),               #= Disable spawning a shell inside the terminal (=)
  Bool :two($no-double-buffer),      #= Disable double-buffering (=)
  Int  :$extra-margin,               #= Add extra margin around the terminal widget (=)
  Int  :$windows = 1,                #= Open multiple windows (default: 1) (=n-windows)
  Int  :n(:$scrollback-lines),       #= Specify the number of scrollback-lines (=)
  Int  :T(:$transparent),            #= Enable the use of a transparent background (values:0..100) (=transparency-percent)
  Str  :@env,                        #= Add environment variable to the child's environment (=environment)
  Str  :$cjk-width,                  #= Specify the cjk ambiguious width to use for UTF-8 encoing (=cjk-ambiguous-with-string)
  Str  :$cursor-background-color,    #= Enable a colored cursor background (=cursor-background-color-string)
  Str  :$cursor-blink,               #= Cursor blink mode (values:system|on|off) (=cursor-blink-mode-string)
  Str  :$cursor-foreground-color,    #= Enable a colored cursor foreground (=cursor-foreground-color-string)
  Str  :$cursor-shape,               #= Set cursor shape (values:block|underline|ibeam) (=cursor-shape-string)
  Str  :$encoding,                   #= Specify the terminal encoding to use (=)
  Str  :$highlight-background-color, #= Enable distinct highlight background color for selection (=hl-bg-color-string)
  Str  :$highlight-foreground-color, #= Enable distinct highlight foreground color for selection (=hl-fg-color-string)
  Str  :$output-file,                #= Save terminal contents to file at exit (=output-filename)
  Str  :$word-char-exceptions,       #= Specify the word char exceptions (=)
  Str  :c(:$command),                #= Execute a command in the terminal (=)
  Str  :D(:@dingu),                  #= Add regex highlight (=dingus)
  Str  :f(:$font),                   #= Specify a font to use (=font-string)
  Str  :g(:$geometry),               #= Set the size (in characters) and position (=)
  Str  :i(:$icon-title),             #= Enable the setting of the icon title (=)
  Str  :w($working-directory)        #= Specify the initial working directory of the terminal (=)
)
  is export
{
  for %PARAMETERS.keys {
    my $pv = ::("{ %PARAMETERS{$_} }");
    my $pc = %PARAMETERS.WHY.trailing;

    if $pv && $pc ~~ &func-call {
      "$0"( $pv )
    }

    if $pc ~~ &get-set {
      my $attr = $0 // $_;

      if $pc ~~ &validation {
        if $0.contains('|') {
          die "Parameter $_ contains invalid value '{ $pv }'"
            unless $pv eq $0.split('|').any;
        } elsif $0.contains('..') {
          my ($to, $from) = $0.split('..');
          die "Parameter $_ is out of range. Must be in range { $0 }"
            unless $pv ~~ $to .. $from;
        }
      }

      $OPTIONS."{ $attr }"() = $pv
    }
  }

  App::VTETerm::App.new.run;
}

BEGIN {
  %PARAMETERS = (gather for &MAIN.signature.params.kv -> $k, $v {
    take Pair.new($v.name, $k);
  }).Hash
}
