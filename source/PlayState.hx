package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import haxe.Timer;
import Car;

/**

 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	
	var background:FlxSprite;
	var logo:FlxSprite;
	var truckSpeed:Float;

	var truck:FlxSprite;
	var gamePlaying:Bool = false;
	var sound_gamestart:FlxSound;
	var sound_crash:FlxSound;

	var fps = 30;
	var speedincriment = 5;
	var updateMoved:Bool;
	var acceleration:Float = 0;
	var maxVelocity = 100;
	var moveAmount:Float = 0;
	var lastDirection:Bool = true;
	var tweeningTitle:Bool = false;
	var score:Int;
	var scoreDisplay:FlxText;
	var _cars:FlxGroup;
	
	
	override public function create():Void {
		FlxG.mouse.visible = false;
		FlxG.mouse.useSystemCursor = true;

		var background = new FlxSprite();
		background.loadGraphic("assets/images/background.png");
		add(background);

		gamePlaying = false;

		score = 0;
		scoreDisplay = new FlxText(0, 130, 160, "", 8);
		scoreDisplay.alignment = "center";
		scoreDisplay.color = 0x759a71;

		sound_gamestart = new FlxSound();
		sound_gamestart.loadStream("assets/sounds/gamestart.mp3");

		sound_crash = new FlxSound();

		sound_crash.loadStream("assets/sounds/crash.mp3");

		logo = new FlxSprite();
		logo.loadGraphic("assets/images/logo.png");
		logo.x = 42;

		logo.y = 33;

		truck = new FlxSprite();
		truck.loadGraphic("assets/images/truck_forward.png");
		truck.x = 60;

		truck.y = -100;
		truckSpeed = 10;

		_cars = new FlxGroup();
		var numCars:Int = 10;
		for (i in 0...numCars) {
			var newCar = new Car(20, 150); // Place offscreen
			_cars.add(newCar);
		}
		
		add(_cars);
		add(truck);
		add(logo);
		add(scoreDisplay);
		super.create();
		
	}

	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */

	override public function destroy():Void {
		super.destroy();
	}

	/**
	 * Function that is called once every frame.

	 */
	override public function update():Void {
		updateMoved = false;
		//acceleration = 0;
		slowTruck();
		if (FlxG.keys.pressed.D) { turnTruck(true); }
		if (FlxG.keys.pressed.A) { turnTruck(false); }
		if (FlxG.keys.pressed.RIGHT) { turnTruck(true); }
		if (FlxG.keys.pressed.LEFT) { turnTruck(false); }
		if (FlxG.keys.pressed.ESCAPE) {
			if (gamePlaying) {
				if (tweeningTitle == false) { gameEnd(); }
			}
		}
		if (gamePlaying) {
			score = score + 1;
			scoreDisplay.text = score + "";
			FlxG.overlap(truck, _cars, hitStuff);
		}
		jumpTruck(truck.x + moveAmount);
		super.update();
		
	}

	// GAME FUNCTIONS START
	public function gameStart() {
		gamePlaying = true;
		score = 0;
		sound_gamestart.play();
		tweeningTitle = true;
		tween(logo, logo.x, logo.y, 42, -100, 2.00, true, {ease: FlxEase.quadInOut});
		tween(truck, 60, truck.y, 60, 10, 2, true, {ease: FlxEase.quadInOut});
		haxe.Timer.delay(setTweeningTitle, 2000);
	}

	public function gameEnd() {
		gamePlaying = false;
		tweeningTitle = true;
		tween(logo, logo.x, logo.y, 42, 33, 2.00, true, {ease: FlxEase.quadInOut});
		scoreDisplay.text = "Your Score: " + score;
		tween(truck, truck.x, truck.y, truck.x, -50, 2, true, {ease: FlxEase.quadInOut});
		
		haxe.Timer.delay(setTweeningTitle, 2000);
	}

	public function tween(sprite:FlxSprite, startx:Float, starty:Float, endx:Float, endy:Float, time:Float, respectTime:Bool, options):Void {
		FlxTween.linearMotion(sprite, startx, starty, endx, endy, time, respectTime, options);
	}
	// GAME FUNCTIONS END


	// TRUCK FUNCTIONS START
	// Why didn't I just make this a class? // Fix later
	public function jumpTruck(x:Float):Void {
		if (x < 0) { x = 0; }
		if (x > 160 - truck.width) { x = 160 - truck.width; }
		truck.x = x;
	}
	
	public function turnTruck(right:Bool):Void {
		updateMoved = true;
		var direction = 1;
		if (right == false) { direction = -1; }
		if (gamePlaying) {
			if (right == lastDirection) {} else { acceleration = 20; } // Don't know how to do 'if not' in Haxe. Fix later.
			if (acceleration < 20) { acceleration = 20; }
			if (acceleration < maxVelocity) { acceleration = acceleration * 1.3; }
			if (acceleration > maxVelocity) { acceleration = maxVelocity; }
			moveAmount = (acceleration/fps)*direction;
			lastDirection = right;
		}
		else { if (tweeningTitle == false) { gameStart(); } }
	}

	public function slowTruck():Void {
		if (acceleration != 0) { acceleration = acceleration/1.25; }
	}
	// TRUCK FUNCTIONS END
	// MISC
	public function setTweeningTitle():Void {
		tweeningTitle = false;
	}

	public function hitStuff(object1, object2):Void {
		gameEnd();
	}
}
