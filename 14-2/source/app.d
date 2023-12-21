import std.algorithm;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;


enum string input = import("input.txt");

void tiltNorth(ref ubyte[][] data) {
    ulong[] positions = new ulong[](data[0].length);
    positions[] = 0;

    for (long i = 0; i < data.length; i++) {
        for (long j = 0; j < data[i].length; j++) {
            switch (data[i][j]) {
                case 'O':
                    if (positions[j] != i) {
                        data[positions[j]][j] = data[i][j];
                        data[i][j] = '.';
                    }
                    positions[j]++;
                    break;
                case '#':
                    positions[j] = i + 1;
                    break;
                default:
            }
        }
    }
}

void tiltSouth(ref ubyte[][] data) {
    ulong[] positions = new ulong[](data[0].length);
    positions[] = data[0].length - 1;

    for (long i = data.length - 1; i >= 0; i--) {
        for (long j = 0; j < data[i].length; j++) {
            switch (data[i][j]) {
                case 'O':
                    if (positions[j] != i) {
                        data[positions[j]][j] = data[i][j];
                        data[i][j] = '.';
                    }
                    positions[j]--;
                    break;
                case '#':
                    positions[j] = i - 1;
                    break;
                default:
            }
        }
    }
}


void tiltWest(ref ubyte[][] data) {
    ulong[] positions = new ulong[](data.length);
    positions[] = 0;

    for (long i = 0; i < data[0].length; i++) {
        for (long j = 0; j < data.length; j++) {
            switch (data[j][i]) {
                case 'O':
                    if (positions[j] != i) {
                        data[j][positions[j]] = data[j][i];
                        data[j][i] = '.';
                    }
                    positions[j]++;
                    break;
                case '#':
                    positions[j] = i + 1;
                    break;
                default:
            }
        }
    }
}

void tiltEast(ref ubyte[][] data) {
    ulong[] positions = new ulong[](data.length);
    positions[] = data.length - 1;

    for (long i = data[0].length - 1; i >= 0; i--) {
        for (long j = 0; j < data.length; j++) {
            switch (data[j][i]) {
                case 'O':
                    if (positions[j] != i) {
                        data[j][positions[j]] = data[j][i];
                        data[j][i] = '.';
                    }
                    positions[j]--;
                    break;
                case '#':
                    positions[j] = i - 1;
                    break;
                default:
            }
        }
    }
}

int weight(ubyte[][] data) {
    int result = 0;

    for (int i = 0; i < data.length; i++) {
        for (int j = 0; j < data[i].length; j++) {
            if (data[i][j] == 'O') {
                result += data.length - i;
            }
        }
    }

    return result;
}

void main() {
    ubyte[][] data = input.dup.representation().split("\r\n");

    ubyte[][][] cycleHistory;

    for (int i = 0; i < 1_000_000_000; i++) {
        data.tiltNorth();
        data.tiltWest();
        data.tiltSouth();
        data.tiltEast();

        long loopStart = cycleHistory.countUntil(data);
        if (loopStart != -1) {
            long loopLength = i - loopStart;
            long stepsLeft = fmod(1_000_000_000 - i - 1, loopLength).to!long;
            data = cycleHistory[loopStart + stepsLeft].map!(l => l.dup).array();
            break;
        } else {
            cycleHistory ~= data.map!(l => l.dup).array();
        }
    }

    writeln("Result: ", data.weight());
}
