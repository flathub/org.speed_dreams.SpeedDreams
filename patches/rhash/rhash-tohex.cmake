function(rhash_tohex in out)
    math(EXPR hex "${in}" OUTPUT_FORMAT HEXADECIMAL)
    string(SUBSTRING ${hex} 2 -1 clean_hex)
    string(LENGTH ${clean_hex} length)

    if(length LESS 2)
        string(PREPEND clean_hex "0")
    endif()

    set(${out} ${clean_hex} PARENT_SCOPE)
endfunction()
