package no.olog.utilfunctions
{
	import no.olog.Olog;

	/**
	 * Sets a virtual break point. Code execution is not halted, but the class,
	 * function name and line number of the call to breakPoint is written to the log window
	 * along with introspection of any argument passed to it.
	 * @param args Values to inspect at break point. There are two ways to use this argument:
	 * 				<ol>
	 * 					<li>Use it just like a standard trace and pass any properties you want
	 * 					the values of to be displayed after the breakpoint</li>
	 * 					<li>Pass an object reference as the first argument and string property
	 * 					names after that. These property names will be concidered public
	 * 					properties of the object in the first argument and traced.</li>
	 * 					<li>Pass an object reference as the first argument and "*" as the second
	 * 					argument to invoke a full discription of the object passed as the first argument</li> 
	 * 				</ol>
	 */
	public function breakPoint ( ... args ) : void
	{
		Olog.breakPoint.apply( this, args );
	}
}
