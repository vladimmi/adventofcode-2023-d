import std.algorithm;
import std.conv;
import std.format;
import std.numeric;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");

enum Direction {
    Up,
    Right,
    Down,
    Left,
    Unknown
}

alias DirectionArray = Direction[];

enum DirectionArray[dchar] signDirections = [
    '.': [],
    '|': [Direction.Up, Direction.Down],
    '-': [Direction.Left, Direction.Right],
    'L': [Direction.Up, Direction.Right],
    'J': [Direction.Up, Direction.Left],
    '7': [Direction.Down, Direction.Left],
    'F': [Direction.Down, Direction.Right],
    'S': [Direction.Up, Direction.Down, Direction.Left, Direction.Right]
];

Direction reverse(Direction direction) {
    switch (direction) {
        case Direction.Up: return Direction.Down;
        case Direction.Right: return Direction.Left;
        case Direction.Down: return Direction.Up;
        case Direction.Left: return Direction.Right;
        default: return Direction.Unknown;
    }
}

Direction nextStep(string[] map, long line, long position, Direction ignore = Direction.Unknown) {
    DirectionArray directions = signDirections[map[line][position]].filter!(d => d != ignore).array();
    if (directions.length > 1) {
        directions = directions.filter!((d) {
            long dLine = line;
            long dPos = position;
            switch (d) {
                case Direction.Up: dLine--; break;
                case Direction.Down: dLine++; break;
                case Direction.Left: dPos--; break;
                case Direction.Right: dPos++; break;
                default: break;
            }

            if (dLine < 0 || dLine >= map.length || dPos < 0 || dPos >= map[0].length) return false;

            dchar[] validSigns = signDirections.keys.filter!(s => signDirections[s].canFind(d.reverse)).array();
            return validSigns.canFind(map[dLine][dPos]);
        }).array();
    }
    if (directions.length == 0) {
        writeln("Something went terribly wrong");
        return Direction.Unknown;
    }
    return directions[0];
}

void main() {
    auto lines = input.split("\r\n");

    long startLine, startPosition;

    for (int i = 0; i < lines.length; i++) {
        startPosition = lines[i].countUntil('S');
        if (startPosition != -1) {
            startLine = i;
            break;
        }
    }

    int result = 0;
    long line = startLine;
    long position = startPosition;
    Direction next = Direction.Unknown;

    do {
        next = nextStep(lines, line, position, next.reverse);
        switch (next) {
            case Direction.Up: line--; break;
            case Direction.Down: line++; break;
            case Direction.Left: position--; break;
            case Direction.Right: position++; break;
            default: break;
        }
        result++;
    } while (line != startLine || position != startPosition);

    writeln("Result: ", result / 2);
}
