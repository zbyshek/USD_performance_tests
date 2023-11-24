# Summary

This repository is a collection of simple performance tests for creating a bulk of USD prims.

## Build and Install (C++)

Example for Windows and VS 2019: 

>mkdir build
>
>cd build
>
>cmake -G "Visual Studio 16 2019" ..
>
>cmake --build . --config Release
>
>cmake --install . --config Release

## Run test (C++)

Windows example:
><root_dir>/bin/USD_Creating_Prims.exe <root_dir>/src/stage.usda <root_dir>/src/stage_output.usd

## Run test Python

**Note:**
*Please make sure that PYTHONPATH contains a path to the USD Python lib folder.*

Windows example using 'Windows PowerShell':
>$env:PYTHONPATH="<PATH TO USD>/lib/python"
>
>python <root_dir>/src/main.py <root_dir>/src/stage.usda <root_dir>/src/stage_output_py.usd