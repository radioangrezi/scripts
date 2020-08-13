#!/bin/bash

find /media/storage/recordings -iname "*${1}*" | sed 's/ /\\ /g'
