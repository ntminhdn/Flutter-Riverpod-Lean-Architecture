@echo off
call :Run_Metrics dcm "METRICS"
exit /b

:Run_Metrics
echo %~1 running...
set run_cmd= make %~1
set metrics_log_file= %~1_metrics.log

echo %run_cmd% > %metrics_log_file%
%run_cmd%  > %metrics_log_file%

> nul find /i "WARNING" %metrics_log_file% && (
    echo *** %~2_ERROR contain WARNING***: check file %metrics_log_file%
    exit 1
)

> nul find /i "ALARM" %metrics_log_file% && (
    echo *** %~2_ERROR contain ALARM***: check file %metrics_log_file%
    exit 1
)

> nul find /i "STYLE" %metrics_log_file% && (
    echo *** %~2_ERROR contain STYLE***: check file %metrics_log_file%
    exit 1
)

> nul find /i "PERFORMANCE" %metrics_log_file% && (
    echo *** %~2_ERROR contain PERFORMANCE***: check file %metrics_log_file%
    exit 1
)

del %metrics_log_file%

echo *** %~2_SUCCESS ***
exit /b 0
