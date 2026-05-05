local lfs = require("lfs")

local M = {}

function M.write_file(name, content)
  local output = false
  local file = io.open(name, "w")

  if file then
    file:write(content)
    file:close()
    output = true
  end

  return output
end

function M.create_gitignore(project_name)
    local gitignore_list = [[
.idea
.vscode
.cashe
.clang-format
build
cmake-build-*
compile_commands.json
]]
    return M.write_file(project_name .. "/.gitignore", gitignore_list)
end

function M.create_clang_format(project_name)
    local format_options = [[
BasedOnStyle: GNU
IndentWidth: 4

AccessModifierOffset: 0
AlignAfterOpenBracket: true
AlignArrayOfStructures: None
AlignConsecutiveAssignments: None
AlignConsecutiveBitFields: None
AlignConsecutiveDeclarations: None
AlignConsecutiveMacros: None
AlignConsecutiveShortCaseStatements:
Enabled: false
AlignConsecutiveTableGenBreakingDAGArgColons: None
AllowShortBlocksOnASingleLine: Always
BinPackLongBracedList: true

BreakBeforeBraces: Allman
BreakBeforeConceptDeclarations: Always
ColumnLimit: 120
IndentAccessModifiers: false
IndentExternBlock: Indent
NamespaceIndentation: All
]]

    return M.write_file(project_name .. "/.clang-format", format_options)
end

function M.create_cmake_lists_txt(project_name)
    local main_cmake_content = [[
cmake_minimum_required(VERSION 3.20)
project(]] .. project_name .. [[)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

enable_testing()

find_package(PkgConfig REQUIRED)

add_subdirectory(src)
]]

    M.write_file(project_name .. "/CMakeLists.txt", main_cmake_content)
    M.write_file(project_name .. "/src/CMakeLists.txt", [[
add_subdirectory(main)
add_subdirectory(test)
]])
    M.write_file(project_name .. "/src/main/CMakeLists.txt", "add_executable(" .. project_name .. " application.c++)")
    M.write_file(project_name .. "/src/test/CMakeLists.txt", "# tests here")
end

function M.create_directory_structure(project_name)
  lfs.mkdir(project_name .. "/src")
  lfs.mkdir(project_name .. "/src/main")
  lfs.mkdir(project_name .. "/src/test")
  lfs.mkdir(project_name .. "/build")
end

function M.create_cpp_project()
    vim.ui.input({prompt = "Enter project name (no spaces):"}, function(project_name)
        if project_name then
            lfs.mkdir(project_name)
            M.create_directory_structure(project_name)
            M.create_cmake_lists_txt(project_name)
            M.create_clang_format(project_name)
            M.create_gitignore(project_name)
            M.write_file(project_name .. "/LICENSE", "Please put your license information here!")
            M.write_file(project_name .. "/README.md", "# " .. project_name .. "\n\nDocument your project here!")
            M.write_file(project_name .. "/src/main/application.c++", [[
#include <iostream>

int main ()
{
    std::cout << "hello world\n";
    return 0;
}
]])
            vim.fn.system("cmake -S " .. project_name .. " -B " .. project_name .. "/build")
            vim.fn.system("cmake --build " .. project_name .. "/build")
            vim.fn.system("ln -s " .. project_name .. "/build/compile_commands.json " .. project_name ..
                "/compile_commands.json")
        else
            print("No name provided, project not created.")
        end
    end)
end

function M.create_nvim_plugin_project()
    vim.ui.input({prompt = "Enter project name (no spaces):"}, function(project_name)
        if project_name then
            lfs.mkdir(project_name .. ".nvim")
            lfs.mkdir(project_name .. ".nvim/lua")
            M.create_gitignore(project_name .. ".nvim")
            M.write_file(project_name .. ".nvim/LICENSE", "Please put your license information here!")
            M.write_file(project_name .. ".nvim/README.md", "# " .. project_name .. "\n\nDocument your project here!")
            M.write_file(project_name .. ".nvim/lua/" .. project_name .. ".lua", "-- your code here")
        else
            print("No name provided, project not created")
        end
    end)
end

function M.setup(opts)
    opts = opts or {}
    vim.api.nvim_create_user_command("CreateCmakeProject", M.create_cpp_project, {})
    vim.api.nvim_create_user_command("CreateNvimPluginProject", M.create_nvim_plugin_project, {})
end

return M
