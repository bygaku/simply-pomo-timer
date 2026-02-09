# add target library
qt_add_library(${TIMER}
    STATIC
    include/pomodoro_timer.h
    pomodoro_timer.cpp
)

# add target include directories to Timer library.
target_include_directories(${TIMER}
    PUBLIC
    ./include/
)

# link library to this target.
target_link_libraries(${TIMER}
    PRIVATE
        Qt6::Core
        Qt6::Multimedia
)
