define([], function () {
	'use strict';

	function Vec2(x, y) {
		this.x = x;
		this.y = y;
	}

	Vec2.prototype.copy = function() {
		return new Vec2(this.x, this.y);
	};

	Vec2.prototype.add = function(that) {
		return new Vec2(this.x + that.x, this.y + that.y);
	};

	Vec2.prototype.addOn = function(that) {
		this.x += that.x;
		this.y += that.y;
	};

	Vec2.prototype.sub = function(that) {
		return new Vec2(this.x - that.x, this.y - that.y);
	};

	Vec2.prototype.subOn = function(that) {
		this.x -= that.x;
		this.y -= that.y;
	};

	Vec2.prototype.scale = function(scale) {
		return new Vec2(this.x * scale, this.y * scale);
	};

	Vec2.prototype.subOn = function(scale) {
		this.x *= scale;
		this.y *= scale;
	};

	Vec2.prototype.mul = function(that) {
		return new Vec2(this.x * that.x, this.y * that.y);
	};

	Vec2.prototype.mulOn = function(that) {
		this.x *= that.x;
		this.y *= that.y;
	};

	return Vec2;
});
