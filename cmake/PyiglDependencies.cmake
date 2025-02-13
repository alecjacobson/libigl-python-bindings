# Prepare dependencies
#
# For each third-party library, if the appropriate target doesn't exist yet,
# download it via external project, and add_subdirectory to build it alongside
# this project.


# Download and update 3rdparty libraries
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
list(REMOVE_DUPLICATES CMAKE_MODULE_PATH)

################################################################################
# Required libraries
################################################################################


include(FetchContent)

FetchContent_Declare(
    libigl
    GIT_REPOSITORY https://github.com/libigl/libigl.git
    GIT_TAG 238a607032d725cbf1b99cad2077516b1ee066d8
)
FetchContent_GetProperties(libigl)
FetchContent_MakeAvailable(libigl)

FetchContent_Declare(
  numpyeigen
  GIT_REPOSITORY https://github.com/fwilliams/numpyeigen.git
  GIT_TAG        e2ac64034fde35cb70da39aaefbf5331df6015f7)
# NumpyEigen's CMakeLists sets NPE_PYTHON_EXECUTABLE without a way to override,
# so we must include directly rather that using FetchContent_MakeAvailable
#FetchContent_MakeAvailable(numpyeigen)
# Check if population has already been performed
FetchContent_GetProperties(numpyeigen)
if(NOT numpyeigen_POPULATED)
  # Fetch the content using previously declared details
  FetchContent_Populate(numpyeigen)
endif()
# Push CMAKE_MODULE_PATH
set(PREV_CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${numpyeigen_SOURCE_DIR}/cmake)
# Why isn't eigen_SOURCE_DIR defined?
SET(NPE_WITH_EIGEN "${libigl_SOURCE_DIR}/../eigen-src/"  CACHE INTERNAL "")
include(numpyeigen)
# Pop CMAKE_MODULE_PATH
set(CMAKE_MODULE_PATH ${PREV_CMAKE_MODULE_PATH})

if(${PY_IGL_DOWNLOAD_TEST_DATA})
  FetchContent_Declare(test_data
    SOURCE_DIR "${PYLIBIGL_EXTERNAL}/../data"
    GIT_REPOSITORY https://github.com/libigl/libigl-tests-data.git
    GIT_TAG        19cedf96d70702d8b3a83eb27934780c542356fe)
  FetchContent_MakeAvailable(test_data)
endif()

if(${PY_IGL_DOWNLOAD_TUTORIAL_DATA})
  FetchContent_Declare(tutorial_data
    SOURCE_DIR "${PYLIBIGL_EXTERNAL}/../tutorial/data"
    GIT_REPOSITORY https://github.com/libigl/libigl-tutorial-data.git
    GIT_TAG        c1f9ede366d02e3531ecbaec5e3769312f31cccd)
  FetchContent_MakeAvailable(tutorial_data)
endif()

