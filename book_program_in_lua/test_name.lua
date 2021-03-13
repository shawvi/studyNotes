
local fixSet = {
  "陈果", "陈卓", "陈实", "陈晨"
  }

local keySet = {
    "观", 
    "景",
    "远",
    "池",
    "晨",
    "驰",
    "橙",
    "劲",
    "科",
    "畅",
    "坚",
    "萌",
    "捷",
    "醒",
    "铭",
    "漫",
    "沐",
    "晴",
    "石",
    "思",
    "潜",
    "润",
    "实",
    "霜",
    "视",
    "势",
    "深",
    "稳",
    "蔚",
    "望",
    "溪",
    "旭",
    "希",
    "镇",
    "潇",
    "熙",
    "岩",
    "玥",
    "卓",
    "征",
    "杨",
    "扬",
    "竹",
    "阅",
    "依",
    "麦",
    "歌",
    "迈",
    "辞",
    "谨",
    "科",
    "珂",
    "梁",
    "黎",
    "朗",
    "浸",
  }

local familyName = "陈"
local keyNum = #keySet
local nameSet = {}
for idx, midName in ipairs(keySet) do
  for idy, lastName in ipairs(keySet) do
    if idx ~= idy then
      local fullName = familyName .. midName .. lastName
      print(fullName)
      table.insert(nameSet, fullName)
    end
  end
end

print(#nameSet)