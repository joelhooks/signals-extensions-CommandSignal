package org.robotlegs.test.support.guarding {
	                                 
	import org.robotlegs.mvcs.Command;
	
	public class SampleCommandC {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function SampleCommandC() {			
			// pass constants to the super constructor for properties
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		public function execute():void
		{
			reporter.reportCommand(SampleCommandC);
		}
	}
}