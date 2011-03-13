package org.robotlegs.test.support.guarding {
	                                 	
	public class SampleCommandA {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function SampleCommandA() {			
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
			reporter.reportCommand(SampleCommandA);
		}
		
	}
}