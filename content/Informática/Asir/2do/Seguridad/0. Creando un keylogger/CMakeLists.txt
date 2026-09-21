cmake_minimum_required(VERSION 3.10.0)
project(Project LANGUAGES CXX)

set(COMMON_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/inc)

# --- Configuración del Keylogger_Cliente ---
add_executable(Keylogger_Client 
	${PROJECT_SOURCE_DIR}/src/client/main.cpp
)

target_link_libraries(Keylogger_Client PRIVATE
	pthread
	ws2_32
)

target_include_directories(Keylogger_Client PRIVATE ${COMMON_INCLUDE_DIR})

target_link_options(Keylogger_Client PRIVATE
    -static
)

# --- Configuración del Ketlogger_Servidor ---
add_executable(Keylogger_Server 
	${PROJECT_SOURCE_DIR}/src/server/main.cpp
)

target_link_libraries(Keylogger_Server PRIVATE
	pthread
	ws2_32
)

target_include_directories(Keylogger_Server PRIVATE ${COMMON_INCLUDE_DIR})

target_link_options(Keylogger_Server PRIVATE
    -static
)