package no.olog.utilfunctions {
	import no.olog.Olog;

	/**
	 * Performs simple equals assertion and outputs the results to the log window
	 * @param testName String name used to identify the test
	 * @param expected The expected value of the actual argument
	 * @param actual The actual value. This argument can either be the value itself of a function reference,
	 * in which case the function will be called and the returned value will be evaluated against the expected argument
	 * @param args Any arguments to use when calling actual if actual is a function reference 
	 */
	public function assert ( testName:String, expected:*, actual:*, ... args ):Boolean {
		if (!Olog.enableAssertions) true;
		var level:uint;
		var msg:String = "[Test \"" + testName + "\"] ";
		var location:String = "";
		var result:* = (actual is Function) ? actual.apply( this, args ) : actual;
		if (expected === result) {
			msg += "passed";
			level = 4;
		} else {
			msg += "failed, expected " + String( expected ) + " was " + result;
			level = 3;
			location = getCallee( 3 );
		}

		Olog.trace( msg, level, location );
		return result == 4 ? true : false;
	}
}
