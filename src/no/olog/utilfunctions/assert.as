package no.olog.utilfunctions {
	import flash.utils.getQualifiedClassName;
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
		var level:uint;
		var msg:String = "[Test \"" + testName + "\"] ";
		var location:String = "";
		var result:*;
		if (actual is Function) {
			actual.apply( this, args );
		}
		else if (expected is Class) {
			expected = getQualifiedClassName( expected );
			result = getQualifiedClassName( actual );
		}
		else if (expected is String && !isNaN( Number( actual ) )) {
			var expectedAsString:String = String( expected );
			if (expectedAsString.charAt( 0 ) == "<" && Number( actual ) < Number( expectedAsString.substr( 1 ) ))
				result = expected;
			else if (expectedAsString.charAt( 0 ) == ">" && Number( actual ) > Number( expectedAsString.substr( 1 ) ))
				result = expected;
			else
				result = actual;
		}
		else {
			result = actual;
		}
		if (result === expected) {
			msg += "passed";
			level = 4;
		}
		else {
			msg += "failed, expected " + String( expected ) + " was " + String( result );
			level = 3;
			location = getCallee( 3 );
		}

		Olog.trace( msg, level, location );
		return level == 4 ? true : false;
	}
}
