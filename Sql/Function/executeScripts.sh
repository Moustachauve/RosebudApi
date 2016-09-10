#!/bin/bash
for sql_file in `ls ./*.sql`; do mysql -uroot < $sql_file ; done
