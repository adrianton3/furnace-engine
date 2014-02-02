define([
	'tokenizer/IterableString',
	'tokenizer/TokEnd',
	'tokenizer/TokNum',
	'tokenizer/TokIdentifier',
	'tokenizer/TokStr',
	'tokenizer/TokLPar',
	'tokenizer/TokRPar',
	'tokenizer/TokKeyword',
	'tokenizer/TokWhitespace',
	'tokenizer/TokCommSL',
	'tokenizer/TokCommML',
	'tokenizer/TokComma',
	'tokenizer/TokSemicolon',
	'tokenizer/TokArrow',
	'tokenizer/TokAssignment',
	'tokenizer/TokNewLine',
	'tokenizer/TokenCoords'
	], function (
		IterableString,
		TokEnd,
		TokNum,
		TokIdentifier,
		TokStr,
		TokLPar,
		TokRPar,
		TokKeyword,
		TokWhitespace,
		TokCommSL,
		TokCommML,
		TokComma,
		TokSemicolon,
		TokArrow,
		TokAssignment,
		TokNewLine,
		TokenCoords
	) {
	'use strict';

	var Tokenizer = {};

	Tokenizer.chop = function(s, ws, comm) {
		ws = !!ws;
		comm = !!comm;

		var str = new IterableString(s + ' ');
		var tok = [];

		while(str.hasNext()) {
			var c = str.cur();

			if(c == "'") {
				tok.push(Tokenizer.chop.strs(str));
			}
			else if(c == '"') {
				tok.push(Tokenizer.chop.strd(str));
			}
			else if(c == '/') {
				var n = str.next();
				if(n == '/') {
					var tmp = Tokenizer.chop.commsl(str);
					if(comm) tok.push(tmp);
				}
				else if(n == '*') {
					var tmp = Tokenizer.chop.commml(str);
					if(comm) tok.push(tmp);
				}
				else {
					tok.push(Tokenizer.chop.alphanum(str));
				}
			}
			else if(c == '(') {
				tok.push(new TokLPar(str.getCoords()));
				str.adv();
			}
			else if(c == ')') {
				tok.push(new TokRPar(str.getCoords()));
				str.adv();
			}
			else if(c == '=') {
				tok.push(new TokAssignment(str.getCoords()));
				str.adv();
			}
			else if(c == ',') {
				tok.push(new TokComma(str.getCoords()));
				str.adv();
			}
			else if(c == ';') {
				tok.push(new TokSemicolon(str.getCoords()));
				str.adv();
			}
			else if(c === '-' && str.next() === '>') {
				tok.push(new TokArrow(str.getCoords()));
				str.adv();
				str.adv();
			}
			else if(c > ' ' && c <= '~') {
				tok.push(Tokenizer.chop.alphanum(str));
			}
			else if (c === '\n') {
				tok.push(new TokNewLine(str.getCoords()));
				str.adv();
			} else {
				var tmp = Tokenizer.chop.whitespace(str);
				if(ws) tok.push(tmp);
			}
		}

		tok.push(new TokEnd(str.getCoords()));

		return tok;
	};

	Tokenizer.chop.strUnescape = function(s) {
		return s.replace(/\\\'/g, '\'')
				.replace(/\\\"/g, '\"')
				.replace(/\\\\/g, '\\')
				.replace(/\\\n/g, '\n');
	};

	Tokenizer.chop.strs = function(str) {
		var coords = str.getCoords();
		str.setMarker();
		str.adv();

		while (true) {
			if(str.cur() == '\\') str.adv();
			else if(str.cur() == "'") { str.adv(); return new TokStr(Tokenizer.chop.strUnescape(str.getMarked().slice(1, -1)), coords); }
			else if(str.cur() == '\n' || !str.hasNext()) throw 'String did not end well ' + str.getCoords();
			str.adv();
		}
	};

	Tokenizer.chop.strd = function(str) {
		var coords = str.getCoords();
		str.setMarker();
		str.adv();

		while (true) {
			if(str.cur() == '\\') str.adv();
			else if(str.cur() == '"') { str.adv(); return new TokStr(Tokenizer.chop.strUnescape(str.getMarked().slice(1, -1)), coords); }
			else if(str.cur() == '\n' || !str.hasNext()) throw 'String did not end well ' + str.getCoords();;
			str.adv();
		}
	};

	Tokenizer.chop.num = function(str) {
		var coords = str.getCoords();
		str.setMarker();

		var tmp = str.cur();
		while (tmp >= '0' && tmp <= '9') {
			str.adv();
			tmp = str.cur();
		}

		if (str.cur() == '.') {
			str.adv();
			var tmp = str.cur();
			while (tmp >= '0' && tmp <= '9') {
				str.adv();
				tmp = str.cur();
			}
		}

		if (') \n\t'.indexOf(str.cur()) == -1) throw "Unexpected character '" + str.cur() + "' after \"" + str.getMarked() + '" ' + str.getCoords();

		return new TokNum(str.getMarked(), coords);
	};

	Tokenizer.chop.commml = function(str) {
		var coords = str.getCoords();
		str.setMarker();
		str.adv();
		str.adv();

		while (true) {
			if (str.cur() == '*' && str.next() == '/') {
				str.adv();
				str.adv();
				return new TokCommML(str.getMarked(), coords);
			}
			else if (str.hasNext()) {
				str.adv();
			}
			else throw 'Multiline comment not properly terminated ' + str.getCoords();;
		}
	};

	Tokenizer.chop.commsl = function(str) {
		var coords = str.getCoords();
		str.setMarker();
		str.adv();
		str.adv(2);

		while (true) {
			if(str.cur() == '\n' || !str.hasNext()) {
				str.adv();
				return new TokCommSL(str.getMarked(), coords);
			}
			else str.adv();
		}
	};

	Tokenizer.chop.alphanum = function(str) {
		var coords = str.getCoords();
		str.setMarker();

		var tmp = str.cur();
		while(tmp > ' ' && tmp <= '~' && (tmp != '(' && tmp != ')')) {
			str.adv();
			tmp = str.cur();
		}

		tmp = str.getMarked();

		if(Tokenizer.chop.alphanum.reserved.indexOf(tmp) != -1) return new TokKeyword(tmp, coords);
		else return new TokIdentifier(tmp, coords);
	};

	Tokenizer.chop.alphanum.reserved = [
		'COLORS', 'PLAYER', 'OBJECTS', 'SETS', 'LEAVERULES', 'ENTERRULES', 'USERULES', 'LEGEND', 'LEVELS',
		'rgb',
		'blocking',
		'or', 'and', 'minus',
		'consume', 'give', 'heal', 'hurt', 'teleport', 'message'
	];

	Tokenizer.chop.whitespace = function(str) {
		var tmp = str.cur();
		str.adv();
		return new TokWhitespace(tmp);
	};

	return Tokenizer;
});
