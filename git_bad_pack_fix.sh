#!/bin/bash

# Force Git to process packing sequentially instead of choking the NAS network pipe
git config --global pack.threads "1"

# Lower the window memory and size limits so packets are written in smaller, safer chunks
git config --global pack.windowMemory "100m"
git config --global pack.packSizeLimit "100m"

