import std.algorithm;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");

bool satisfies(ubyte[] data, ulong[] pattern) {
    return data.group().filter!(g => g[0] == '#').map!(g => g[1]).array() == pattern;
}

int countSatisfying(ref ubyte[] buffer, ulong[] pattern) {
    int result = 0;

    long index = buffer.countUntil('?');
    if (index == -1) {
        return satisfies(buffer, pattern);
    }

    ulong countDamaged = buffer.count('#');
    if (countDamaged < pattern.sum) {
        buffer[index] = '#';
        result += countSatisfying(buffer, pattern);
    }
    buffer[index] = '.';
    result += countSatisfying(buffer, pattern);

    buffer[index] = '?';

    return result;
}

void main() {
    string[] lines = input.split("\r\n");

    int result = 0;

    foreach (line; lines) {
        string[] parts = line.split(" ");
        ulong[] pattern = parts[1].split(",").map!(p => p.to!ulong).array();
        ubyte[] buffer = parts[0].dup.representation();
        result += countSatisfying(buffer, pattern);
    }

    writeln("Result: ", result);
}
