package org.robotlegs.test.support.guarding {
	                                 
	public class SampleCommandB {
		
		[Inject]
		public var reporter:ICommandReporter;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function SampleCommandB() {			
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
			reporter.reportCommand(SampleCommandB);
		}
		
	}
}