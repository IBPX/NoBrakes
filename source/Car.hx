package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import haxe.Timer;
import Math;

class Car extends FlxSprite {
	private var _fps:Int = 30; // Use for step();
	
	public function new(x:Int, y:Int):Void {
		super(x, y);
		loadGraphic("assets/images/car.png");
	}

	public function step(speed):Void {
		this.y = this.y - (speed / _fps);
	}

	public function placeRandom() { // Place randomly on the X axis.
		this.x = (Math.random() * 136);
	}

	public function tweenAway() {
		FlxTween.linearMotion(this, this.x, this.y, this.x, 160, 2, true, {ease: FlxEase.quadInOut});
		haxe.Timer.delay(this.placeRandom, 2000);
	}
}
