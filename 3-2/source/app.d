import std.algorithm;
import std.ascii;
import std.format;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");

bool isNotDigit(dchar c) {
    return !isDigit(c);
}

alias IntArray = int[];
alias Coords = Tuple!(long, long);

void main() {
    auto lines = input.split("\r\n");

    long startIndex, endIndex, pos, i, j;
    int number;
    IntArray[Coords] gears;

    for (long line = 0; line < lines.length; line++) {
        pos = 0;
        while ((startIndex = pos + lines[line][pos..$].countUntil!isDigit) >= pos) {
            endIndex = startIndex + lines[line][(startIndex)..$].countUntil!isNotDigit;
            if (endIndex < startIndex) endIndex = lines[line].length - 1;
            else endIndex--;

            number = 0;
            for (i = max(0, line - 1); i <= min(lines.length - 1, line + 1); i++) {
                for (j = max(0, startIndex - 1); j <= min(lines[i].length - 1, endIndex + 1); j++) {
                    if (lines[i][j] == '*') {
                        if (!number) {
                            lines[line][startIndex..(endIndex + 1)].formattedRead("%d", number);
                        }
                        if (tuple(i, j) !in gears) {
                            gears[tuple(i, j)] = [];
                        }
                        gears[tuple(i, j)] ~= number;
                    }
                }
            }

            pos = endIndex + 1;
        }
    }

    int result = 0;
    foreach (gear; gears.byValue) {
        if (gear.length == 2) {
            result += gear[0] * gear[1];
        }
    }

    writeln("Result: ", result);
}
