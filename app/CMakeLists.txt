# make executable application
qt_add_executable(${EXE_NAME}
    ./main.cpp
    ./resources/resources.qrc
)

# link library to execution file.
target_link_libraries(${EXE_NAME}
    PRIVATE
    Qt6::Quick
    ${TIMER}
)

# add QML and resource files.
qt_add_qml_module(${EXE_NAME}
    URI Modular
    VERSION 1.0
    QML_FILES
        ./qml/MainWindow.qml
        ./qml/PomodoroWindow.qml
    RESOURCES
        resources/resources.qrc
)
