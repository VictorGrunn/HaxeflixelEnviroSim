package maingame;
import flixel.group.FlxGroup;
import entitytypes.MASTER_AGENT;
import entitytypes.MASTER_PLACE;
import entitytypes.Place_Land;
import entitytypes.Agent_Roamer;
import flixel.util.FlxTimer;
import flixel.FlxG;
import ui.GameHUD;

/**
 * ...
 * @author Victor Grunn
 */
class GameGroup extends FlxGroup
{
	public static var month:Int = 0;
	public static var year:Int = 0;
	
	public static var TotalWoodThisYear:Int = 0;
	public static var TotalWoodEver:Int = 0;
	
	public static var totalLivingBears:Int = 0;
	public static var totalLivingLumberjacks:Int = 0;
	
	public static var totalDeadLumberjacks:Int = 0;
	public static var totalDeadLumberjacksThisYear:Int = 0;
	
	public static var totalElderTreesLeft:Int = 0;
	public static var totalNormalTreesLeft:Int = 0;
	public static var totalSaplingsLeft:Int = 0;
	
	private var mapArray:Array < Array < MASTER_PLACE >> ;
	
	public static var occupantsArray:Array <MASTER_AGENT> ;
	
	private var mapGroup:FlxTypedGroup<MASTER_PLACE>;
	private var occupantsGroup:FlxTypedGroup<MASTER_AGENT>;	
	
	public static var mapSize:Int = 50;
	public static var pieceSize:Int = 5;
	public static var mapAccessArray:Array < Array < MASTER_PLACE >> ;
	
	private var gameTimer:FlxTimer;
	
	private var gameHUD:GameHUD;

	public function new() 
	{
		super();
		
		mapArray = new Array < Array < MASTER_PLACE >> ();
		occupantsArray = new Array <MASTER_AGENT > ();	
		mapAccessArray = mapArray;	
		
		mapGroup = new FlxTypedGroup<MASTER_PLACE>();
		add(mapGroup);
		
		occupantsGroup = new FlxTypedGroup<MASTER_AGENT>();
		add(occupantsGroup);
		
		gameHUD = new GameHUD();
		add(gameHUD);
		
		initMap();
		
		gameTimer = new FlxTimer(.05, onTimerComplete, 0);		
	}
	
	override public function update():Void
	{
		super.update();
		
		if (gameTimer != null && !gameTimer.active)
		{
			if (FlxG.keys.justPressed.R)
			{
				GameGroup.month = 0;
				GameGroup.year = 0;
				FlxG.resetGame();
			}
		}
	}	
	
	private function onTimerComplete(t:FlxTimer):Void
	{	
		GameGroup.totalElderTreesLeft = 0;
		GameGroup.totalNormalTreesLeft = 0;
		GameGroup.totalSaplingsLeft = 0;
		
		for (i in 0...mapArray.length)
		{
			for (o in 0...mapArray[i].length)
			{
				mapArray[i][o].ageOneMonth();			
				
				if (mapArray[i][o].ID_TYPE == OCCTYPE_LAND.TREE_ELDER)
				{
					totalElderTreesLeft += 1;
				}
				else if (mapArray[i][o].ID_TYPE == OCCTYPE_LAND.TREE_TREE)
				{
					totalNormalTreesLeft += 1;
				}
				else if (mapArray[i][o].ID_TYPE == OCCTYPE_LAND.TREE_SAPLING)
				{
					totalSaplingsLeft += 1;
				}
			}											
		}						
		
		for (o in 0...GameGroup.occupantsArray.length)
		{
			if (GameGroup.occupantsArray[o] != null)
			{
				GameGroup.occupantsArray[o].ageOneMonth();
			}				
		}					
		
		GameGroup.totalLivingBears = 0;
		GameGroup.totalLivingLumberjacks = 0;
		
		for (i in 0...GameGroup.occupantsArray.length)
		{
			if (GameGroup.occupantsArray[i] != null)
			{
				if (GameGroup.occupantsArray[i].exists)
				{
					if (GameGroup.occupantsArray[i].ID_TYPE == OCCTYPE_CREATURE.LUMBERJACK)
					{
						GameGroup.totalLivingLumberjacks += 1;
					}
					
					if (GameGroup.occupantsArray[i].ID_TYPE == OCCTYPE_CREATURE.BEAR)
					{
						GameGroup.totalLivingBears += 1;
					}
				}
			}
		}
		
		GameGroup.month += 1;
		
		if (GameGroup.month == 12)
		{
			if (TotalWoodThisYear < totalLivingLumberjacks)
			{
				for (i in 0...occupantsArray.length)
				{
					if (occupantsArray[i] != null && occupantsArray[i].exists && occupantsArray[i].ID_TYPE == OCCTYPE_CREATURE.LUMBERJACK)
					{
						occupantsArray[i].currentLocation.removeOccupant(occupantsArray[i]);
						occupantsArray[i].exists = false;
						occupantsArray.remove(occupantsArray[i]);
						break;
					}
				}
			}
			else if (TotalWoodThisYear >= totalLivingLumberjacks)
			{
				var woodScope:Int = TotalWoodThisYear - totalLivingLumberjacks;
				
				var hires:Int = Math.floor(woodScope / 10);
				if (hires <= 0)
				{
					hires = 1;
				}
				
				for (i in 0...hires)
				{
					generateJack();
				}
			}
			
			if (totalDeadLumberjacksThisYear > 0)
			{
				for (i in 0...occupantsArray.length)
				{
					if (occupantsArray[i] != null && occupantsArray[i].exists && occupantsArray[i].ID_TYPE == OCCTYPE_CREATURE.BEAR)
					{
						occupantsArray[i].currentLocation.removeOccupant(occupantsArray[i]);
						occupantsArray[i].exists = false;
						occupantsArray.remove(occupantsArray[i]);
						break;
					}
				}
			}
			else
			{
				generateBear();
			}
			
			GameGroup.month = 0;
			GameGroup.year += 1;
			GameGroup.TotalWoodThisYear = 0;
			GameGroup.totalDeadLumberjacksThisYear = 0;
		}
		
		gameHUD.updateText();
		
		if (totalElderTreesLeft == 0 && totalNormalTreesLeft == 0 && totalSaplingsLeft == 0)
		{
			gameTimer.cancel();

			GameGroup.totalDeadLumberjacks = 0;
			GameGroup.totalDeadLumberjacksThisYear = 0;
			GameGroup.totalElderTreesLeft = 0;
			GameGroup.totalLivingBears = 0;
			GameGroup.totalLivingLumberjacks = 0;
			GameGroup.totalNormalTreesLeft = 0;
			GameGroup.totalSaplingsLeft = 0;
			GameGroup.TotalWoodEver = 0;
			GameGroup.TotalWoodThisYear = 0;
			GameGroup.year = 0;
			GameGroup.month = 0;
			gameHUD.endAnnouncement();
		}
		
		if (year == 400)
		{
			gameTimer.cancel();
			gameHUD.endAnnouncement();
		}
	}
	
	public function initMap():Void
	{
		for (i in 0...mapSize)
		{
			mapArray[i] = new Array<MASTER_PLACE>();
			
			for (o in 0...mapSize)
			{				
				var newPlace:MASTER_PLACE = new Place_Land();
				mapGroup.add(newPlace);
				
				mapArray[i][o] = newPlace;
				mapArray[i][o].launch(OCCTYPE_LAND.EMPTY);
				mapArray[i][o].x = (FlxG.width - (mapSize * pieceSize)) + i * pieceSize;
				mapArray[i][o].y = o * pieceSize;
				mapArray[i][o].xSlot = i;
				mapArray[i][o].ySlot = o;
			}
		}		
		
		var treeCount:Int = Std.int((mapSize * mapSize) * .5);
		
		while (treeCount > 0)
		{
			var checkX:Int = Math.floor(Math.random() * mapSize);
			var checkY:Int = Math.floor(Math.random() * mapSize);
			
			if (mapArray[checkX][checkY].ID_TYPE == OCCTYPE_LAND.EMPTY)
			{
				mapArray[checkX][checkY].launch(OCCTYPE_LAND.TREE_TREE);
				treeCount -= 1;
			}
		}				
		
		trace("Map initialized.");				
		initOccupants();
	}	
	
	private function initOccupants():Void
	{				
		var jackCount:Int = Std.int((mapSize * mapSize) * .10);			
		var bearCount:Int = Std.int((mapSize * mapSize) * .02);
		
		while (jackCount > 0)
		{
			jackCount -= 1;
			generateJack();
		}
		
		while (bearCount > 0)
		{
			bearCount -= 1;
			generateBear();
		}	
		
		trace("Occupants initialized.");							
	}	
	
	private function generateJack():Void
	{
		var checkX:Int = Math.floor(Math.random() * mapSize);
		var checkY:Int = Math.floor(Math.random() * mapSize);
		
		if (mapArray[checkX][checkY].occupants.length == 0)
		{
			var jack:MASTER_AGENT = occupantsGroup.recycle(Agent_Roamer);	
			jack.launch(OCCTYPE_CREATURE.LUMBERJACK);
			jack.xSlot = checkX;
			jack.ySlot = checkY;
			mapArray[checkX][checkY].setOccupant(jack);				
			GameGroup.occupantsArray.push(jack);
		}
	}
	
	private function generateBear():Void
	{
		var checkX:Int = Math.floor(Math.random() * mapSize);
		var checkY:Int = Math.floor(Math.random() * mapSize);
		
		if (mapArray[checkX][checkY].occupants.length == 0)
		{
			var bear:MASTER_AGENT = occupantsGroup.recycle(Agent_Roamer);
			bear.launch(OCCTYPE_CREATURE.BEAR);
			bear.xSlot = checkX;
			bear.ySlot = checkY;
			mapArray[checkX][checkY].setOccupant(bear);				
			GameGroup.occupantsArray.push(bear);			
		}
	}
	
}