#!/bin/bash
echo "make dcm is running..."
metrics=$( make dcm )
echo -e "\n=== START LOGGING===\n\n$metrics\n\n### END LOGGING###\n"

if grep -q "WARNING" <<< "$metrics"; then
    echo "*** METRICS_ERROR contain WARNING***: $metrics"
    exit 1
fi

if grep -q "ALARM" <<< "$metrics"; then
    echo "*** METRICS_ERROR contain ALARM***: $metrics"
    exit 1
fi

if grep -q "STYLE" <<< "$metrics"; then
    echo "*** METRICS_ERROR contain STYLE***: $metrics"
    exit 1
fi

if grep -q "PERFORMANCE" <<< "$metrics"; then
    echo "*** METRICS_ERROR contain PERFORMANCE***: $metrics"
    exit 1
fi

echo "*** METRICS_SUCCESS ***"
