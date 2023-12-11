import std.algorithm;
import std.conv;
import std.format;
import std.numeric;
import std.range;
import std.stdio;
import std.string;
import std.utf;


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

struct Location {
    long line;
    long position;

    void move(Direction direction) {
        switch (direction) {
            case Direction.Up: line--; break;
            case Direction.Down: line++; break;
            case Direction.Left: position--; break;
            case Direction.Right: position++; break;
            default: break;
        }
    }

    Location at(Direction direction) {
        Location result = this;
        switch (direction) {
            case Direction.Up: result.line--; break;
            case Direction.Down: result.line++; break;
            case Direction.Left: result.position--; break;
            case Direction.Right: result.position++; break;
            default: break;
        }
        return result;
    }

    Location leftHand(Direction direction) {
        switch (direction) {
            case Direction.Up: return this.at(Direction.Left);
            case Direction.Down: return this.at(Direction.Right);
            case Direction.Left: return this.at(Direction.Down);
            case Direction.Right: return this.at(Direction.Up);
            default: throw new Exception("Invalid direction: " ~ direction.to!string);
        }
    }

    Location rightHand(Direction direction) {
        switch (direction) {
            case Direction.Up: return this.at(Direction.Right);
            case Direction.Down: return this.at(Direction.Left);
            case Direction.Left: return this.at(Direction.Up);
            case Direction.Right: return this.at(Direction.Down);
            default: throw new Exception("Invalid direction: " ~ direction.to!string);
        }
    }
}

Direction reverse(Direction direction) {
    switch (direction) {
        case Direction.Up: return Direction.Down;
        case Direction.Right: return Direction.Left;
        case Direction.Down: return Direction.Up;
        case Direction.Left: return Direction.Right;
        default: return Direction.Unknown;
    }
}

Direction nextStep(string[] map, Location location, Direction ignore = Direction.Unknown) {
    DirectionArray directions = signDirections[map[location.line][location.position]].filter!(d => d != ignore).array();
    if (directions.length > 1) {
        directions = directions.filter!((d) {
            Location newLocation = location.at(d);

            if (newLocation.line < 0 || newLocation.line >= map.length || newLocation.position < 0 || newLocation.position >= map[0].length) return false;

            dchar[] validSigns = signDirections.keys.filter!(s => signDirections[s].canFind(d.reverse)).array();
            return validSigns.canFind(map[newLocation.line][newLocation.position]);
        }).array();
    }
    if (directions.length == 0) {
        writeln("Something went terribly wrong");
        return Direction.Unknown;
    }
    return directions[0];
}

void main() {
    string[] lines = input.split("\r\n");

    char[][] map = new char[][](lines.length);
    for (int i = 0; i < lines.length; i++) {
        map[i] = new char[](lines[0].length);
    }

    Location start;

    for (int i = 0; i < lines.length; i++) {
        start.position = lines[i].countUntil('S');
        if (start.position != -1) {
            start.line = i;
            break;
        }
    }

    Location location = start;
    int leftTurns = 0, rightTurns = 0;
    Direction prev = Direction.Unknown;
    Direction next = Direction.Unknown;

    do {
        next = nextStep(lines, location, next.reverse);
        location.move(next);
        map[location.line][location.position] = '#';
        
        if (prev != Direction.Unknown && next != prev) {
            if (
                (prev == Direction.Down && next == Direction.Right) ||
                (prev == Direction.Right && next == Direction.Up) ||
                (prev == Direction.Up && next == Direction.Left) ||
                (prev == Direction.Left && next == Direction.Down)
            ) {
                leftTurns++;
            } else {
                rightTurns++;
            }
        }
        prev = next;
    } while (location != start);

    bool leftHand = leftTurns > rightTurns;
    location = start;
    Location sideLocation;
    next = Direction.Unknown;
    do {
        next = nextStep(lines, location, next.reverse);

        sideLocation = leftHand ? location.leftHand(next) : location.rightHand(next);
        if (map[sideLocation.line][sideLocation.position] == char.init) {
            map[sideLocation.line][sideLocation.position] = '$';
        }

        location.move(next);

        sideLocation = leftHand ? location.leftHand(next) : location.rightHand(next);
        if (map[sideLocation.line][sideLocation.position] == char.init) {
            map[sideLocation.line][sideLocation.position] = '$';
        }
    } while (location != start);

    bool filled;
    int i, j;
    do {
        filled = false;
        for (i = 0; i < map.length; i++) {
            for (j = 0; j < map[i].length; j++) {
                if (
                    (map[i][j] == char.init) && (
                        (i > 0 && map[i - 1][max(0, j - 1)..min(j + 1, map[i].length)].canFind('$')) ||
                        map[i][max(0, j - 1)..min(j + 1, map[i].length)].canFind('$') ||
                        (i < (map.length - 1) && map[i + 1][max(0, j - 1)..min(j + 1, map[i].length)].canFind('$'))
                    )
                ) {
                    map[i][j] = '$';
                    filled = true;
                }
            }
        }
    } while (filled);

    writeln("Result: ", map.map!(line => line.byCodeUnit.count('$')).sum());
}
