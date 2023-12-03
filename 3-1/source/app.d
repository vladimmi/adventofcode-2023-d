import std.algorithm;
import std.ascii;
import std.format;
import std.math;
import std.range;
import std.stdio;
import std.string;


enum string input = import("input.txt");

bool isNotDigit(dchar c) {
    return !isDigit(c);
}

bool isSymbol(dchar c) {
    return !isDigit(c) && c != '.';
}

void main() {
    auto lines = input.split("\r\n");    

    int result = 0;

    long startIndex, endIndex, pos, i, j;
    bool hasSymbol;
    int number;

    for (long line = 0; line < lines.length; line++) {
        pos = 0;
        while ((startIndex = pos + lines[line][pos..$].countUntil!isDigit) >= pos) {
            endIndex = startIndex + lines[line][(startIndex)..$].countUntil!isNotDigit;
            if (endIndex < startIndex) endIndex = lines[line].length - 1;
            else endIndex--;

            hasSymbol = false;
            for (i = max(0, line - 1); i <= min(lines.length - 1, line + 1); i++) {
                hasSymbol = hasSymbol || lines[i][max(0, startIndex - 1)..min(lines[i].length, endIndex + 2)].any!isSymbol;
            }

            if (hasSymbol) {
                lines[line][startIndex..(endIndex + 1)].formattedRead("%d", number);
                result += number;
            }

            pos = endIndex + 1;
        }
    }

    writeln("Result: ", result);
}
