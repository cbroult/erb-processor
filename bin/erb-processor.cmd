@echo off

set RUBY_SCRIPT_PATH=%~dpn0
shift
ruby %RUBY_SCRIPT_PATH% %*

