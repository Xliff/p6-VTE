use v6.c;

unit package VTE::Raw::Exports;

our @vte-exports is export;

BEGIN {
  @vte-exports = <
    VTE::Raw::Definitions
  >;
}
