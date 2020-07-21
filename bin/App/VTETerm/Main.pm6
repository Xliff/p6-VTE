use v6.c;

unit package App::VTETerm::Main;

use GDK::Window;
use App::VTETerm::App;
use App::VTETerm::Options;

our %PARAMETERS is export;

my token no-cp      { <-[)]>+ }

my token func-call  { '(&'       (<no-cp>) ')' }
my token get-set    { '(='       (<no-cp>) ')' }
my token validation { '(values:' (<no-cp>) ')' }

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

sub no-pcre ($value) {
  $OPTIONS.no-pcre = $value.not;
}

# Not being called?
sub GENERATE-USAGE (&main, |c) is export {
  my $usage = &*GENERATE-USAGE(&main, |c);

  $usage.substr-rw(.from, .to - .from) = ''
    for ( $usage ~~ m:g/[ <func-call> | <get-set> | <validation>]/ ).reverse;

  $usage
}

class X::MAIN is Exception {
  has $!err;

  submethod BUILD (:$!err) { }

  method new ($err) { self.bless(:$err) }
  method message    { $!err }
}

sub MAIN (
  Bool :$gregex,                     #= Use GRegex instead of PCRE2 (&no-pcre)
  Bool :$no-argb-visual,             #= Don't use an ARGB visual (=)
  Bool :$no-builtin-dingus,          #= Highlight URLs inside the terminal (=)
  Bool :$no-context-menu,            #= Disable context menu (=)
  Bool :$reverse,                    #= Reverse foreground/background colors (=)
  Bool :$version,                    #= Show version (&version)
  Bool :a(:$audible-bell),           #= Use audible terminal bell (=audible)
  Bool :d(:$debug),                  #= Enable various debugging checks (&debug)
  Bool :G(:$no-geometry-hints),      #= Allow the terminal to be resized to any dimension, not constrained to fit to an integer multiple of characters (=)
  Bool :H(:$no-hyperlink),           #= Disable hyperlinks (=)
  Bool :k(:$keep),                   #= Live on after the command exits (=)
  Bool :N(:$object-notifications),   #= Print VteTerminal object notifications (=)
  Bool :R(:$no-rewrap),              #= Disable rewrapping on resize (=)
  Bool :S(:$no-shell),               #= Disable spawning a shell inside the terminal (=)
  Bool :two($no-double-buffer),      #= Disable double-buffering (=)
  Int  :$extra-margin,               #= Add extra margin around the terminal widget (=)
  Int  :$windows,                    #= Open multiple windows (default: 1) (=n-windows)
  Int  :n(:$scrollback-lines),       #= Specify the number of scrollback-lines (=)
  Int  :T(:$transparent),            #= Enable the use of a transparent background (values:0..100) (=transparency-percent)
  Str  :$env,                        #= Add environment variable to the child's environment (=environment)
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
  Str  :D(:$dingu),                  #= Add regex highlight (=dingus)
  Str  :f(:$font),                   #= Specify a font to use (=font-string)
  Str  :g(:$geometry),               #= Set the size (in characters) and position (=)
  Str  :i(:$icon-title),             #= Enable the setting of the icon title (=)
  Str  :w($working-directory)        #= Specify the initial working directory of the terminal (=)
)
  is export
{
  CATCH {
    when X::MAIN { .message.say; exit }
  }

  for %PARAMETERS.kv -> $pn, $pt {
    my $pv = ::("\${$pn}");
    next without $pv;

    say "---- $pn ----";
    $pv.^name.say;
    $pv.gist.say;

    my $pc = $pt[1];
    if $pn && $pc ~~ &func-call {
      say "Calling { $0 }...";
      ::("\&{$0}")( $pv );
    }

    if $pc ~~ &get-set {
      my $attr = $0 // $pn;

      if $pt[2] -> $v {
        if $v ~~ Array {
          X::MAIN.new("Parameter $pn contains invalid value '{ $pv }'").throw
            unless $pv eq $0.split('|').any;
        } elsif $v ~~ Range {
          X::MAIN.new(
            "Parameter $pn is out of range. Must be in range {
             $v.min }..{ $v.max }"
          ).throw unless $pv ~~ $v;
        }
      }

      $OPTIONS."{ $attr }"() = $pv;
      say "OPTIONS.{ $attr } set to { $OPTIONS."{ $attr }"() }";
    }
  }
  exit;

  App::VTETerm::App.new.run;
}

BEGIN {
  %PARAMETERS = (gather for &MAIN.signature.params.kv -> $k, $v {
    my $pn = $v.name.substr(1);
    my $pc = $v.WHY.trailing;

    my $pv = [ $k, $v.WHY.trailing ];
    if $pc ~~ &validation {
      if $0.contains('|') {
        $pv.push: $0.split('|').grep( *.chars );
      } elsif $0.contains('..') {
        my ($to, $from) = $0.split('..');
        X::MAIN.new(
          "Invalid range 'to' specification in parameter $k!"
        ).throw unless $to ~~ /^ \d+ $/;
        X::MAIN.new(
          "Invalid range 'from' specification in parameter $pn!"
        ).throw unless $from ~~ /^ \d+ $/;
        $pv.push: $to..$from;
      }
    }

    take Pair.new($v.name.substr(1), $pv);
  }).Hash;
  %PARAMETERS.gist.say;
}
