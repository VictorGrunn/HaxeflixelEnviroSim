package entitytypes;

/**
 * ...
 * @author Victor Grunn
 */
class MASTER_AGENT extends MASTER_BASE
{
	private var movesLeft:Int = 0;
	public var ID_TYPE:OCCTYPE_CREATURE;
	public var currentLocation:MASTER_PLACE;

	public function new() 
	{
		super();
	}
	
	public function launch(_type:OCCTYPE_CREATURE):Void
	{
		ID_TYPE = _type;
	}	
	
	public function interrupt():Void
	{
		
	}
	
}

enum OCCTYPE_CREATURE
{
	BEAR;
	LUMBERJACK;
}