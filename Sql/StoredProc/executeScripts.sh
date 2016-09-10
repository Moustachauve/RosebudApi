#!/bin/bash
for sqlScript in $( ls *.sql ); do
    mysql -uroot < $sqlScript
done
