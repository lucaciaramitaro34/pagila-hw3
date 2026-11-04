#!/bin/bash

failed=false

mkdir -p results

for problem in sql/*.sql; do
    printf '%s ' "$problem"

    problem_id=$(basename "${problem%.sql}")

    result="results/$problem_id.out"
    expected="expected/$problem_id.out"

    # Execute the SQL query and capture errors
    psql -v ON_ERROR_STOP=1 < "$problem" > "$result" 2>&1
    query_status=$?

    # Compare actual and expected outputs
    DIFF=$(diff -B "$expected" "$result" 2>&1)
    diff_status=$?

    if [ "$query_status" -eq 0 ] && [ "$diff_status" -eq 0 ]; then
        echo pass
    else
        echo fail
        failed=true

        echo "----------------------------------------"
        echo "FAILED: $problem"
        echo "----------------------------------------"

        if [ "$query_status" -ne 0 ]; then
            echo "SQL execution error:"
            cat "$result"
        else
            echo "Expected vs actual differences:"
            echo "$DIFF"
        fi

        echo
    fi
done

if [ "$failed" = "true" ]; then
    exit 2
fi

exit 0
