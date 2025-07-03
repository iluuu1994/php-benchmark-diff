#!/usr/bin/env php
<?php

function mean(array $values): float {
    return array_sum($values) / count($values);
}

function standard_deviation(array $values, float $mean): float {
    $sum = 0.0;
    foreach ($values as $value) {
        $sum += ($value - $mean) ** 2;
    }
    return sqrt($sum / (count($values) - 1));
}

function independent_t_test(int $size1, float $mean1, float $stdDev1, int $size2, float $mean2, float $stdDev2) {
    return abs($mean1 - $mean2) / sqrt((($stdDev1 ** 2) / $size1) + (($stdDev2 ** 2) / $size2));
}

function p_value(int $df, float $tTest): float {
    $tTest = abs($tTest);

    $header = [1.00, 0.50, 0.40, 0.30, 0.20, 0.10, 0.05, 0.02, 0.01, 0.002, 0.001];
    $table = [
        PHP_INT_MAX => [0.000, 0.674, 0.842, 1.036, 1.282, 1.645, 1.960, 2.326, 2.576, 3.090,  3.291],
        1000        => [0.000, 0.675, 0.842, 1.037, 1.282, 1.646, 1.962, 2.330, 2.581, 3.098,  3.300],
        100         => [0.000, 0.677, 0.845, 1.042, 1.290, 1.660, 1.984, 2.364, 2.626, 3.174,  3.390],
        80          => [0.000, 0.678, 0.846, 1.043, 1.292, 1.664, 1.990, 2.374, 2.639, 3.195,  3.416],
        60          => [0.000, 0.679, 0.848, 1.045, 1.296, 1.671, 2.000, 2.390, 2.660, 3.232,  3.460],
        40          => [0.000, 0.681, 0.851, 1.050, 1.303, 1.684, 2.021, 2.423, 2.704, 3.307,  3.551],
        30          => [0.000, 0.683, 0.854, 1.055, 1.310, 1.697, 2.042, 2.457, 2.750, 3.385,  3.646],
        29          => [0.000, 0.683, 0.854, 1.055, 1.311, 1.699, 2.045, 2.462, 2.756, 3.396,  3.659],
        28          => [0.000, 0.683, 0.855, 1.056, 1.313, 1.701, 2.048, 2.467, 2.763, 3.408,  3.674],
        27          => [0.000, 0.684, 0.855, 1.057, 1.314, 1.703, 2.052, 2.473, 2.771, 3.421,  3.690],
        26          => [0.000, 0.684, 0.856, 1.058, 1.315, 1.706, 2.056, 2.479, 2.779, 3.435,  3.707],
        25          => [0.000, 0.684, 0.856, 1.058, 1.316, 1.708, 2.060, 2.485, 2.787, 3.450,  3.725],
        24          => [0.000, 0.685, 0.857, 1.059, 1.318, 1.711, 2.064, 2.492, 2.797, 3.467,  3.745],
        23          => [0.000, 0.685, 0.858, 1.060, 1.319, 1.714, 2.069, 2.500, 2.807, 3.485,  3.768],
        22          => [0.000, 0.686, 0.858, 1.061, 1.321, 1.717, 2.074, 2.508, 2.819, 3.505,  3.792],
        21          => [0.000, 0.686, 0.859, 1.063, 1.323, 1.721, 2.080, 2.518, 2.831, 3.527,  3.819],
        20          => [0.000, 0.687, 0.860, 1.064, 1.325, 1.725, 2.086, 2.528, 2.845, 3.552,  3.850],
        19          => [0.000, 0.688, 0.861, 1.066, 1.328, 1.729, 2.093, 2.539, 2.861, 3.579,  3.883],
        18          => [0.000, 0.688, 0.862, 1.067, 1.330, 1.734, 2.101, 2.552, 2.878, 3.610,  3.922],
        17          => [0.000, 0.689, 0.863, 1.069, 1.333, 1.740, 2.110, 2.567, 2.898, 3.646,  3.965],
        16          => [0.000, 0.690, 0.865, 1.071, 1.337, 1.746, 2.120, 2.583, 2.921, 3.686,  4.015],
        15          => [0.000, 0.691, 0.866, 1.074, 1.341, 1.753, 2.131, 2.602, 2.947, 3.733,  4.073],
        14          => [0.000, 0.692, 0.868, 1.076, 1.345, 1.761, 2.145, 2.624, 2.977, 3.787,  4.140],
        13          => [0.000, 0.694, 0.870, 1.079, 1.350, 1.771, 2.160, 2.650, 3.012, 3.852,  4.221],
        12          => [0.000, 0.695, 0.873, 1.083, 1.356, 1.782, 2.179, 2.681, 3.055, 3.930,  4.318],
        11          => [0.000, 0.697, 0.876, 1.088, 1.363, 1.796, 2.201, 2.718, 3.106, 4.025,  4.437],
        10          => [0.000, 0.700, 0.879, 1.093, 1.372, 1.812, 2.228, 2.764, 3.169, 4.144,  4.587],
        9           => [0.000, 0.703, 0.883, 1.100, 1.383, 1.833, 2.262, 2.821, 3.250, 4.297,  4.781],
        8           => [0.000, 0.706, 0.889, 1.108, 1.397, 1.860, 2.306, 2.896, 3.355, 4.501,  5.041],
        7           => [0.000, 0.711, 0.896, 1.119, 1.415, 1.895, 2.365, 2.998, 3.499, 4.785,  5.408],
        6           => [0.000, 0.718, 0.906, 1.134, 1.440, 1.943, 2.447, 3.143, 3.707, 5.208,  5.959],
        5           => [0.000, 0.727, 0.920, 1.156, 1.476, 2.015, 2.571, 3.365, 4.032, 5.893,  6.869],
        4           => [0.000, 0.741, 0.941, 1.190, 1.533, 2.132, 2.776, 3.747, 4.604, 7.173,  8.610],
        3           => [0.000, 0.765, 0.978, 1.250, 1.638, 2.353, 3.182, 4.541, 5.841, 10.215, 12.924],
        2           => [0.000, 0.816, 1.061, 1.386, 1.886, 2.920, 4.303, 6.965, 9.925, 22.327, 31.599],
        1           => [0.000, 1.000, 1.376, 1.963, 3.078, 6.314, 12.71, 31.82, 63.66, 318.31, 636.62],
    ];

    foreach ($table as $i => $row) {
        if ($df >= $i) {
            break;
        }
    }

    foreach ($row as $i => $current) {
        if ($i === count($row) - 1) {
            return 0.001;
        }
        $next = $row[$i + 1];
        if ($tTest >= $current && $tTest < $next) {
            return $header[$i + 1] + (($header[$i] - $header[$i + 1]) / ($next - $current) * ($tTest - $current));
        }
    }

    throw new Exception('Unreachable');
}

function format_value(float $value) {
    $metricPrefixes = [
        [1e12, 'T'],
        [1e9, 'G'],
        [1e6, 'M'],
        [1e3, 'k'],
        [1, ''],
        [1e-3, 'm'],
        [1e-6, 'µ'],
        [1e-9, 'n'],
        [1e-12, 'p'],
    ];

    $absValue = abs($value);

    foreach ($metricPrefixes as $i => [$factor, $prefix]) {
        if ($absValue >= $factor || $i === count($metricPrefixes) - 1) {
            $formatted = $value / $factor;
            return number_format($formatted, 3) . ' ' . $prefix;
        }
    }
}

function format_percentage(float $num) {
    return number_format($num, 3, '.', '');
}

function runCommand(string $cmd, string $mode): float {
    $pipes = null;
    $descriptorSpec = [0 => ['pipe', 'r'], 1 => ['pipe', 'w'], 2 => ['pipe', 'w']];

    if ($mode !== 'cgi') {
        $cmd = "perf stat -e $mode $cmd";
    }

    $cmd = 'taskset -c 0 ' . $cmd;

    $processHandle = proc_open($cmd, $descriptorSpec, $pipes, getcwd(), null);

    $stdin = $pipes[0];
    $stdout = $pipes[1];
    $stderr = $pipes[2];

    fclose($stdin);

    stream_set_blocking($stdout, false);
    stream_set_blocking($stderr, false);

    $stdoutEof = false;
    $stderrEof = false;
    $stderrBuffer = '';

    do {
        $read = [$stdout, $stderr];
        $write = null;
        $except = null;

        stream_select($read, $write, $except, 1, 0);

        foreach ($read as $stream) {
            $chunk = fgets($stream);
            if ($stream === $stderr) {
                $stderrBuffer .= $chunk;
            }
        }

        $stdoutEof = $stdoutEof || feof($stdout);
        $stderrEof = $stderrEof || feof($stderr);
    } while(!$stdoutEof || !$stderrEof);

    fclose($stdout);
    fclose($stderr);
    $statusCode = proc_close($processHandle);

    if ($statusCode !== 0) {
        fwrite(STDERR, $stderrBuffer);
        fwrite(STDERR, 'Exited with status code ' . $statusCode . "\n");
        exit($statusCode);
    }

    $regex = $mode === 'cgi'
        ? "(Elapsed time: (?<value>[0-9]+\\.[0-9]+) sec)"
        : "((?<value>[0-9’,]+)( )+(cpu_core/)?$mode(:u|/|/u)?)";
    if (preg_match($regex, $stderrBuffer, $matches) === 0) {
        fwrite(STDERR, "Value $mode could not be detected\n");
        exit(1);
    }
    $value = (float)str_replace(['’', ','], '', $matches['value']);
    return $value;
}

function print_temp(string $message) {
    static $lineLength = 0;
    if ($lineLength) {
        echo str_repeat(' ', $lineLength), "\r";
    }
    echo $message, "\r";
    flush();
    $lineLength = strlen($message);
}

function print_progress(?int $max, int $current) {
    $length = 30;
    $progress = $max !== null ? round($length / $max * $current) : 0;
    $maxLabel = $max !== null ? $max : '?';
    print_temp('[' . str_repeat('-', $progress) . str_repeat(' ', $length - $progress) . "] $current/$maxLabel");
}

function filter_interquartile_range($values, float $window) {
    $windowSize = max(5, (int)ceil(count($values) * $window));
    asort($values);
    return array_slice($values, 0, $windowSize, true);
}

function main($argv) {
    array_shift($argv);

    $mode = 'duration_time';
    $window = 0.25;
    $runs = null;
    $time = 5;
    foreach ($argv as $i => $arg) {
        if (preg_match('(^--mode=(?<mode>.*)$)', $arg, $matches)) {
            $mode = $matches['mode'];
            unset($argv[$i]);
        }
        if (preg_match('(^--window=(?<window>.*)$)', $arg, $matches)) {
            $window = $matches['window'];
            if (!is_numeric($window) || $window <= 0 || $window > 1) {
                fwrite(STDERR, "--window must be a float > 0 <= 1\n");
                exit(1);
            }
            $window = (float)$window;
            unset($argv[$i]);
        }
        if (preg_match('(^--runs=(?<runs>.*)$)', $arg, $matches)) {
            $runs = $matches['runs'];
            if (!ctype_digit($runs) || $runs < 1) {
                fwrite(STDERR, "--runs must be an integer >= 1\n");
                exit(1);
            }
            $runs = (int)$runs;
            unset($argv[$i]);
        }
        if (preg_match('(^--time=(?<time>.*)$)', $arg, $matches)) {
            $time = $matches['time'];
            if (!ctype_digit($time) || $time <= 0) {
                fwrite(STDERR, "--time must be an integer > 0\n");
                exit(1);
            }
            $time = (int)$time;
            unset($argv[$i]);
        }
    }
    $argv = array_values($argv);

    if (count($argv) !== 2) {
        fwrite(STDERR, "Expecting exactly three inputs\n");
        exit(1);
    }

    $oldCmd = $argv[0];
    $newCmd = $argv[1];

    $oldValues = [];
    $newValues = [];

    print_progress($runs !== null ? $runs * 2 : null, 0);
    $i = 0;
    do {
        if ($runs !== null) {
            $oldValues[] = runCommand($oldCmd, $mode);
        } else {
            $start = microtime(true);
            $oldValues[] = runCommand($oldCmd, $mode);
            $delta = microtime(true) - $start;
            $runs = (int) ceil(min(50, $time / $delta / 2));
        }
        print_progress($runs !== null ? $runs * 2 : null, count($oldValues) + count($newValues));
        $newValues[] = runCommand($newCmd, $mode);
        print_progress($runs !== null ? $runs * 2 : null, count($oldValues) + count($newValues));
        $i++;
    } while ($i < $runs);
    print_temp('');

    $oldValues = filter_interquartile_range($oldValues, $window);
    $newValues = filter_interquartile_range($newValues, $window);

    /* Print indexes of picked runs. */
    // echo json_encode(array_keys($oldValues)), "\n";
    // echo json_encode(array_keys($newValues)), "\n";

    $oldMean = mean($oldValues);
    $newMean = mean($newValues);
    $diff = $newMean - $oldMean;
    $relativeDiff = ($newMean / $oldMean - 1) * 100;

    echo 'Old:   ', format_value($oldMean);
    if (count($oldValues) > 1) {
        $oldStdDev = standard_deviation($oldValues, $oldMean);
        echo ' ± ', format_value($oldStdDev), ' (', format_percentage(100 / $oldMean * $oldStdDev), "%)";
    }
    echo "\n";

    echo 'New:   ', format_value($newMean);
    if (count($newValues) > 1) {
        $newStdDev = standard_deviation($newValues, $newMean);
        echo ' ± ', format_value($newStdDev), ' (', format_percentage(100 / $newMean * $newStdDev), "%)";
    }
    echo "\n";

    echo 'Diff:  ', format_value($diff), ' (', ($relativeDiff >= 0 ? '+' : ''), format_percentage($relativeDiff), "%";
    if (count($oldValues) > 1 && count($newValues) > 1) {
        $tTest = independent_t_test(count($oldValues), $oldMean, $oldStdDev, count($newValues), $newMean, $newStdDev);
        $pValue = p_value(count($oldValues) + count($newValues) - 2, $tTest);
        echo ', p < ', format_percentage($pValue);
    }
    echo ")\n";
}

main($argv);
