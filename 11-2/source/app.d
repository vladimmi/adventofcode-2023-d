import std.algorithm;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");
enum int expansionCoeff = 1_000_000;

alias Coord = Tuple!(int, int);

void main() {
    string[] map = input.split("\r\n");
    int[] emptyLines, emptyColumns;
    int i, j;

    for (i = 0; i < map.length; i++) {
        if (map[i].all!(a => a == '.')) emptyLines ~= i;
    }

    bool empty;
    for (j = 0; j < map[0].length; j++) {
        empty = true;
        for (i = 0; i < map.length; i++) {
            if (map[i][j] == '#') {
                empty = false;
                break;
            }
        }
        if (empty) emptyColumns ~= j;
    }
    
    Coord[] galaxies;
    for (i = 0; i < map.length; i++) {
        for (j = 0; j < map[i].length; j++) {
            if (map[i][j] == '#') galaxies ~= tuple(i, j);
        }
    }

    long result = 0;
    ulong lines, columns;
    for (i = 0; i < galaxies.length; i++) {
        for (j = i + 1; j < galaxies.length; j++) {
            lines = emptyLines.count!(l => l > min(galaxies[i][0], galaxies[j][0]) && l < max(galaxies[i][0], galaxies[j][0]));
            columns = emptyColumns.count!(c => c > min(galaxies[i][1], galaxies[j][1]) && c < max(galaxies[i][1], galaxies[j][1]));
            result += abs(galaxies[j][0] - galaxies[i][0]) + lines * (expansionCoeff - 1) + abs(galaxies[j][1] - galaxies[i][1]) + columns * (expansionCoeff - 1);
        }
    }

    writeln("Result: ", result);
}
