

macro(mc_merge_file_path sDir sFileNames sOutFileNames)
#    message(${sFileNames})
    foreach (sFileName ${sFileNames})
        list(APPEND ${sOutFileNames} ${sDir}/${sFileName})
    endforeach ()
endmacro()

macro(mc_post_build_copyfile sTargetName)
    if(MSVC)
        add_custom_command(TARGET ${sTargetName} POST_BUILD
                COMMAND python "${gs_project_ccpro_script_path}/python/deploy_copyfile.py" -ct $(Configuration) -sf ${sTargetName}
                )
    else()
        add_custom_command(TARGET ${sTargetName} POST_BUILD
                COMMAND python "${gs_project_ccpro_script_path}/python/deploy_copyfile.py" -ct ${CMAKE_BUILD_TYPE} -sf ${sTargetName}
                )
    endif()
endmacro()

macro(mc_build_with_cc_static)
    if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
        #    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused-function -Wno-missing-declarations")
        #    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-function -Wno-missing-declarations")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static-libgcc -static-libstdc++")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libgcc -static-libstdc++")
    endif()

    if(MSVC)
        add_definitions(-D"_CRT_SECURE_NO_WARNINGS")

        #
        foreach(flag_var
                CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
                CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO
                CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
                CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
            if(${flag_var} MATCHES "/MD")
                string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
            endif()
            if(${flag_var} MATCHES "/MDd")
                string(REGEX REPLACE "/MDd" "/MTd" ${flag_var} "${${flag_var}}")
            endif()
        endforeach(flag_var)

        #    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:atlthunk.lib /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:msvcrtd.lib")
        #    set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /NODEFAULTLIB:libcmt.lib")
        #    set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /NODEFAULTLIB:libcmtd.lib")
    endif()
endmacro()


macro(mc_target_link_libraries sTargetName)
    if (WIN32)
        target_link_libraries(${sTargetName}  wsock32 ws2_32 psapi)
    elseif(APPLE)
        find_library(CFLIB CoreFoundation)
        target_link_libraries(${sTargetName}  ${CFLIB})
        add_definitions(-DGUID_CFUUID)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pedantic")
    elseif(ANDROID)
        target_compile_definitions(xg PRIVATE GUID_ANDROID)
    else()
        #    find_package(Libuuid REQUIRED)
        #    if (NOT LIBUUID_FOUND)
        #        message(FATAL_ERROR
        #                "You might need to run 'sudo apt-get install uuid-dev' or similar")
        #    endif()
        #    include_directories(${LIBUUID_INCLUDE_DIR})
        #    target_link_libraries(Libuuid ${LIBUUID_LIBRARY})
        #    add_definitions(-DGUID_LIBUUID)
        #    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pedantic")
        #    target_link_libraries(${sTargetName}  dl rt)
        target_link_libraries(${sTargetName}  dl rt uuid)
    endif ()
endmacro()