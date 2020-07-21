use v6.c;

use VTE::Raw::Types;

use GTK::Application;
use GTK::Settings;
use App::VTETerm::Options;
use App::VTETerm::Window;

constant MAX_WINDOWS = 16;

class App::VTETerm::App is GTK::Application {
  has @!windows;

  submethod BUILD {
    self.startup.tap({
      @!windows.push: App::VTETerm::Window.new(self)
        for ^($OPTIONS.n-windows, MAX_WINDOWS).min;
    });

    self.activate.tap({
      for @!windows {
        next if $_ ~~ App::VTETerm::Window;
        .apply-geometry;
        .present;
        .launch;
      }
    });
  }

  submethod TWEAK {
    my $settings = GTK::Settings.get-default;

    ($settings.enable-mnemonics, $settings.enable-accels) = False xx 2;
    $settings.menu-bar-accel = Str;
  }

  method new {
    nextwith(
      id => 'org.gnome.Vte.Test.App',
      flags => G_APPLICATION_NON_UNIQUE
    );
  }
}
