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

bool equals(Dimension dim)(string[] slice, int a, int b) {
    static if (dim == Dimension.Row) {
        return slice[a] == slice[b];
    } else {
        for (int i = 0; i < slice.length; i++) {
            if (slice[i][a] != slice[i][b]) return false;
        }
        return true;
    }
}

int getAxisValue(string[] pattern) {
    for (int i = 0; i < pattern.length - 1; i++) {
        if (equals!(Dimension.Row)(pattern, i, i + 1)) {
            int size = min(i + 1, pattern.length - i - 1);
            bool valid = true;
            for (int j = 1; j < size; j++) {
                if (!equals!(Dimension.Row)(pattern, i - j, i + 1 + j)) {
                    valid = false;
                    break;
                }
            }
            if (valid) return (i + 1) * 100;
        }
    }

    for (int i = 0; i < pattern[0].length - 1; i++) {
        if (equals!(Dimension.Column)(pattern, i, i + 1)) {
            int size = min(i + 1, pattern[0].length - i - 1);
            bool valid = true;
            for (int j = 1; j < size; j++) {
                if (!equals!(Dimension.Column)(pattern, i - j, i + 1 + j)) {
                    valid = false;
                    break;
                }
            }
            if (valid) return i + 1;
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
