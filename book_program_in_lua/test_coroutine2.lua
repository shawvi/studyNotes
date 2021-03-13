function dispatch ()
local i = 1
local timedout = {}
while true do
if tasks[i] == nil then -- no other tasks?
if tasks[1] == nil then -- list is empty?
break -- break the loop
end
i = 1 -- else restart the loop
timedout = {}
end
local res = tasks[i]() -- run a task
if not res then -- task finished?
table.remove(tasks, i)
else -- time out
i = i + 1
timedout[#timedout + 1] = res
if #timedout == #tasks then -- all tasks blocked?
socket.select(timedout) -- wait
end
end
end
end
Along the loop, this new dispatcher collects the timed-out connections in the table timedout. (Remember that receive passes such connections to yield, thus resume returns them.) If all connections
time out, the dispatcher calls select to wait for any of these connections to change status. This final
implementation runs as fast as the previous implementation, with coroutines. Moreover, as it does not do
busy waits, it uses just as much CPU as the sequential implementation.