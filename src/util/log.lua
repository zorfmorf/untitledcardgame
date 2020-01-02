
--- basic logging class that supports different log levels and dumping of log information
local log = {}

-- supported log levels
LOG_DEBUG = 0
LOG_INFO = 1
LOG_WARN = 2
LOG_ERROR = 3

-- log level strings
local LOG_STR = {}
LOG_STR[LOG_DEBUG] = "DEBUG"
LOG_STR[LOG_INFO] = "INFO"
LOG_STR[LOG_WARN] = "WARN"
LOG_STR[LOG_ERROR] = "ERROR"


-- set default log level
LOG_LEVEL = LOG_DEBUG


-- Actually note down message
function log:log(level, ...)
    -- TODO keep in memory and dump periodically / on demand
    -- TODO enable print suppression?
    print(LOG_STR[level], ...)
end


-- Write all buffered log contents
function log:dump()
    -- TODO implement
end


function log:debug(...)
    if LOG_LEVEL == LOG_DEBUG then
        self:log(LOG_DEBUG, ...)
    end
end


function log:info(...)
    if LOG_LEVEL < LOG_WARN then
        self:log(LOG_INFO, ...)
    end
end


function log:warn(...)
    if LOG_LEVEL < LOG_ERROR then
        self:log(LOG_WARN, ...)
    end
end


function log:err(...)
    self:log(LOG_ERROR, ...)
end


return log
