<?php

/** @return list<string> */
function extract_measurements(string $input, string $header): array {
    preg_match_all("($header:\\s+Elapsed time: (?<time>[0-9]+\\.[0-9]+) sec)", $input, $matches);
    return $matches['time'];
}

function mean(array $values): float {
    return array_sum($values) / count($values);
}

$input = stream_get_contents(fopen('php://stdin', 'r'));
$old = mean(extract_measurements($input, 'Old'));
$new = mean(extract_measurements($input, 'New'));
echo $new, ' / ', $old, ' = ', 100 / $old * $new, "\n";
