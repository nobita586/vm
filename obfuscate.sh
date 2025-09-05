#!/bin/bash
shc -f entrypoint.sh -o entrypoint
rm -f entrypoint.sh entrypoint.sh.x.c
echo "✅ entrypoint obfuscated successfully."
