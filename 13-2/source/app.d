import std.algorithm;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");

enum Dimension {
    Row,
    Column
}

int diffValue(Dimension dim)(string[] slice, int a, int b) {
    int result = 0;

    static if (dim == Dimension.Row) {
        for (int i = 0; i < slice[0].length; i++) {
            if (slice[a][i] != slice[b][i]) result++;
        }
    } else {
        for (int i = 0; i < slice.length; i++) {
            if (slice[i][a] != slice[i][b]) result++;
        }
    }

    return result;
}

int getAxisValue(string[] pattern) {
    int diff, size, i, j;

    for (i = 0; i < pattern.length - 1; i++) {
        diff = diffValue!(Dimension.Row)(pattern, i, i + 1);
        if (diff <= 1) {
            size = min(i + 1, pattern.length - i - 1);
            for (j = 1; j < size; j++) {
                diff += diffValue!(Dimension.Row)(pattern, i - j, i + 1 + j);
                if (diff > 1) break;
            }
            if (diff == 1) return (i + 1) * 100;
        }
    }

    for (i = 0; i < pattern[0].length - 1; i++) {
        diff = diffValue!(Dimension.Column)(pattern, i, i + 1);
        if (diff <= 1) {
            size = min(i + 1, pattern[0].length - i - 1);
            for (j = 1; j < size; j++) {
                diff += diffValue!(Dimension.Column)(pattern, i - j, i + 1 + j);
                if (diff > 1) break;
            }
            if (diff == 1) return i + 1;
        }
    }

    return -1;
}

void main() {
    string[] lines = input.split("\r\n");
    string[][] patterns = lines.split([]);

    int result = 0;

    foreach (pattern; patterns) {
        result += pattern.getAxisValue();
    }

    writeln("Result: ", result);
}
