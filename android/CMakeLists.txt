cmake_minimum_required(VERSION 3.22.1)  # for example

project('m-vahan-app')

add_library( 
        api_util

        # Sets the library as a shared library.
        SHARED

        # Provides a relative path to your source file(s).
        ../ios/Classes/api_util.cpp
)