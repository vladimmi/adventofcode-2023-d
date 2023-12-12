import std.algorithm;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");

void expand(ref ubyte[][] map) {
    int i, j;
    int[] emptyKeys;
    for (i = 0; i < map.length; i++) {
        if (map[i].all!(a => a == '.')) emptyKeys ~= i;
    }
    if (emptyKeys.length) {
        foreach (key; emptyKeys.reverse) {
            ubyte[] emptyLine = new ubyte[](map[0].length);
            emptyLine[] = '.';
            map.insertInPlace(key, emptyLine);
        }
    }

    emptyKeys = [];
    bool empty;
    for (j = 0; j < map[0].length; j++) {
        empty = true;
        for (i = 0; i < map.length; i++) {
            if (map[i][j] == '#') {
                empty = false;
                break;
            }
        }
        if (empty) emptyKeys ~= j;
    }
    if (emptyKeys.length) {
        for (i = 0; i < map.length; i++) {
            foreach (key; emptyKeys.retro) {
                map[i].insertInPlace(key, '.');
            }
        }
    }
}

alias Coord = Tuple!(int, int);

void main() {
    ubyte[][] map = input.dup.split("\r\n").map!representation.array();
    map.expand();
    
    Coord[] galaxies;
    for (int i = 0; i < map.length; i++) {
        for (int j = 0; j < map[i].length; j++) {
            if (map[i][j] == '#') galaxies ~= tuple(i, j);
        }
    }

    int result = 0;
    for (int i = 0; i < galaxies.length; i++) {
        for (int j = i + 1; j < galaxies.length; j++) {
            result += abs(galaxies[j][0] - galaxies[i][0]) + abs(galaxies[j][1] - galaxies[i][1]);
        }
    }

    writeln("Result: ", result);
}
