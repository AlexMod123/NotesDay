cmake_minimum_required(VERSION 4.0)
project(Daily)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)


find_package(Qt6 COMPONENTS
        Core
        Gui
        Quick
        QuickControls2
        Charts
        Graphs
        Sql
        REQUIRED)

add_executable(Daily main.cpp
        src/databasemanager.cpp
        src/databasemanager.h
        resources/resources.qrc
        src/metricsModel.cpp
        src/metricsModel.h
        src/notesModel.cpp
        src/notesModel.h
        src/metricTypesModel.cpp
        src/metricTypesModel.h)
target_link_libraries(Daily
        Qt::Core
        Qt::Gui
        Qt::Quick
        Qt6::QuickControls2
        Qt6::Charts
        Qt6::Graphs
        Qt6::Sql
)

