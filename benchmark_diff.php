<?php

/** @return list<string> */
function extract_measurements(string $input, string $header): array {
    preg_match_all("($header:\\s+Elapsed time: (?<time>[0-9]+\\.[0-9]+) sec)", $input, $matches);
    return $matches['time'];
}

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
    return ($mean1 - $mean2) / sqrt((($stdDev1 ** 2) / $size1) + (($stdDev2 ** 2) / $size2));
}

function cohens_d(float $mean1, float $mean2, float $stdDev1, float $stdDev2) {
    return (abs($mean1) - abs($mean2)) / sqrt($stdDev1 + $stdDev2) / 2;
}

$input = stream_get_contents(fopen('php://stdin', 'r'));
$oldValues = extract_measurements($input, 'Old');
$newValues = extract_measurements($input, 'New');
$oldMean = mean($oldValues);
$newMean = mean($newValues);
$diff = $newMean - $oldMean;
$relativeDiff = ($newMean / $oldMean - 1) * 100;
$oldStdDev = standard_deviation($oldValues, $oldMean);
$newStdDev = standard_deviation($newValues, $newMean);
$independentTTest = independent_t_test(count($oldValues), $oldMean, $oldStdDev, count($newValues), $newMean, $newStdDev);
$cohensD = cohens_d($oldMean, $newMean, $oldStdDev, $newStdDev);

function format_time(float $num) {
    return number_format($num, 6, '.', '');
}

function format_percentage(float $num) {
    return number_format($num, 3, '.', '') . '%';
}

echo 'Old:       ', format_time($oldMean), ' ± ', format_time($oldStdDev), ' (', format_percentage(100 / $oldMean * $oldStdDev), ")\n";
echo 'New:       ', format_time($newMean), ' ± ', format_time($newStdDev), ' (', format_percentage(100 / $newMean * $newStdDev), ")\n";
echo 'Diff:      ', format_time($diff), ' (', format_percentage($relativeDiff), ")\n";
echo 'T-test:    ', number_format($independentTTest, 3, '.', ''), "\n";
echo "Cohen's d: ", number_format($cohensD, 3, '.', ''), "\n";
