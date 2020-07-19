sub MAIN (
	:$hi-there, #= This is a trip!
	:@thusly,   #= Um. Whut?
	:two(:$dbl)   #= Trouble?
) {
	&?ROUTINE.signature.params[0].WHY.trailing.say;
	@thusly.gist.say;
	::('$dbl').say;
}

sub USAGE {
	say "U: { $*USAGE }";
}


