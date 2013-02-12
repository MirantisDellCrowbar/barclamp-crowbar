# ignore errors with loading relative helpers of controller
# this errors appear when using ruby 1.9.1 
MissingSourceFile::REGEXPS << [/^cannot load such file -- (.+_helper)$/i, 1]
