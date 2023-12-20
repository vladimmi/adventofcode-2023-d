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

long findPossiblePlace(ubyte[] buffer, long bufferOffset, long blockSize) {
    long start, b, end;
    end = buffer[bufferOffset..$].countUntil('#');
    if (end == -1) {
        end = buffer.length;
    } else {
        end = min(bufferOffset + end + 1, buffer.length);
    }

    startIndexLoop:
    for (start = bufferOffset; start < end; start++) {
        for (b = start; b < start + blockSize; b++) {
            if (buffer[b] != '?' && buffer[b] != '#') {
                continue startIndexLoop;
            }
        }
        if (
            buffer.length > (start + blockSize)
            && buffer[start + blockSize] != '?'
            && buffer[start + blockSize] != '.'
        ) {
            continue startIndexLoop;
        }
        return start;
    }
    return -1;
}

long[string] combinationsCache;

long countCombinations(ubyte[] source, ref ubyte[] buffer, long bufferOffset, ulong[] sourcePattern, ulong[] pattern) {
    if (!pattern.length) {
        return buffer.satisfies(sourcePattern);
    }

    string cacheKey = buffer[bufferOffset..$].assumeUTF.to!string ~ pattern.to!string();
    if (cacheKey in combinationsCache) return combinationsCache[cacheKey];

    long result = 0;
    long firstIndex, index, indexEnd;
    long countDamaged, countUnknown, firstDamaged;

    firstIndex = index = findPossiblePlace(buffer, bufferOffset, pattern[0]);
    firstDamaged = buffer[bufferOffset..$].countUntil('#');
    if (firstDamaged == -1) {
        firstDamaged = buffer.length;
    } else {
        firstDamaged = min(bufferOffset + firstDamaged, buffer.length);
    }

    while (index != -1 && index <= firstDamaged) {
        indexEnd = index + pattern[0];
        buffer[bufferOffset..index] = '.';
        buffer[index..indexEnd] = '#';
        buffer[indexEnd] = '.';

        countDamaged = buffer.count('#');
        countUnknown = buffer.count('?');
        if (countDamaged <= sourcePattern.sum && (countDamaged + countUnknown) >= sourcePattern.sum) {
            result += countCombinations(source, buffer, indexEnd + 1, sourcePattern, pattern[1..$]);
        }

        buffer[index..(indexEnd + 1)] = source[index..(indexEnd + 1)];

        index = findPossiblePlace(buffer, index + 1, pattern[0]);
    }

    buffer[bufferOffset..$] = source[bufferOffset..$];

    combinationsCache[cacheKey] = result;

    return result;
}

void main() {
    string[] lines = input.split("\r\n");

    long result = 0;

    foreach (line; lines) {
        string[] parts = line.split(" ");
        ulong[] pattern = parts[1].split(",").map!(p => p.to!ulong).repeat(5).join().array();
        ubyte[] source = parts[0].dup.representation().repeat(5).join('?');
        ubyte[] buffer = source.dup;
        result += countCombinations(source, buffer, 0, pattern, pattern);
    }

    writeln("Result: ", result);
}
