local date = 1439653520
local day2year = 365.242 -- days in a year
local sec2hour = 60 * 60 -- seconds in an hour
local sec2day = sec2hour * 24 -- seconds in a day
local sec2year = sec2day * day2year -- seconds in a year
-- year
print(date // sec2year + 1970) --> 2015.0
-- hour (in UTC)
print(date % sec2day // sec2hour) --> 15
-- minutes
print(date % sec2hour // 60) --> 45
-- seconds
print(date % 60) --> 20



> os.time({year=2015, month=8, day=15, hour=12, min=45, sec=20})
--> 1439653520
> os.time({year=1970, month=1, day=1, hour=0}) --> 10800
> os.time({year=1970, month=1, day=1, hour=0, sec=1})
--> 10801
> os.time({year=1970, month=1, day=1}) --> 54000