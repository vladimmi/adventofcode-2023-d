import std.algorithm;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");

void main() {
    string[] lines = input.split("\r\n");

    int result = 0;
    ulong[] weights = new ulong[](lines[0].length);
    weights[] = lines.length;

    int i;
    foreach (lineIndex, line; lines) {
        for (i = 0; i < line.length; i++) {
            switch(line[i]) {
                case 'O':
                    result += weights[i];
                    weights[i]--;
                    break;
                case '#':
                    weights[i] = lines.length - lineIndex - 1;
                    break;
                default:
            }
        }
    }

    writeln("Result: ", result);
}
