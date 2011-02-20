package no.olog.logtargets {
	import no.olog.Oline;

	/**
	 * Interface to implement for writing custom log targets
	 * @author Oyvind Nordhagen
	 * @date 19. feb. 2011
	 */
	public interface ILogTarget {
		function writeLogLine ( line:Oline ):void
	}
}
