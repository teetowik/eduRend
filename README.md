# eduRend
![eduRend](EDU_2d_s.png)

Main framework for graphics assignments in DA307A Computer Graphics and Modelling, Malmö University.  
Assets are required to run the code. These can be downloaded from the course page.

Clone this repository to start working with the course assignments.  
Cloning can be done here on this page, or using e.g. [GitHub Desktop Client](https://desktop.github.com/).

## Requirements
- Windows 10 or 11.
- Visual Studio 2019 (C++14) or newer, with the following workloads:
  - _Desktop development with C++_
  - _Game development with C++_
- A GPU that supports DirectX 11.

Run _Visual Studio Installer_ to add or remove workloads.  
Make sure Windows, Visual Studio and GPU drivers are updated.

## Main changes: 2025 version
- Misc. QOL (@xzereha)
- ImGui (@Selfsson-Dev)
- [Optional FORCE_DGPU](https://github.com/cjgribel/eduRend/pull/10) (@Oxenryd)

## Main changes: 2023 version
- Major cleanup (@xzereha, @FilipTrip)

## Main changes: 2022 version
- Scene class hierarchy (@cjgribel)
- [stb_image](https://github.com/nothings/stb) for texture loading (@cjgribel)
- Shader hot-reloading (@xzereha)
- Better DirectX debugging (@xzereha)
- Window class (@xzereha)

Base version by CJ Gribel (@cjgribel).
