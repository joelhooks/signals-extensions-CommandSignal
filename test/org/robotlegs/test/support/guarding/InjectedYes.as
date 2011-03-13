package org.robotlegs.test.support.guarding 
{

	public class InjectedYes implements IInjectedAnswer, IInjectedOtherAnswer
	{
	
		public function allow():Boolean
		{
			return true;
		}
	
	}

}

