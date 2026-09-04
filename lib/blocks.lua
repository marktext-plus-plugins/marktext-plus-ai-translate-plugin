--- Splitting a document into the smallest pieces worth translating on their own.
---
--- A whole document in one request is slow, can exceed what the model will
--- take, and loses everything when it fails. A block at a time costs one
--- paragraph when something goes wrong, and the reader sees the first one
--- while the rest are still arriving.
---
--- Written with find, sub and string.len rather than patterns and `#`. The
--- editor's Lua does not return anything for `gmatch("(.-)\n")`, never
--- advances past an empty match in `gmatch("[^\n]*")`, does not recognise the
--- `%s` and `%S` classes, and raises on `#someString`. The first three failed
--- silently, and a split that returns nothing looks exactly like a document
--- with one block in it.

local M = {}

--- Whether the line is only spaces and tabs.
local function is_blank(line)
  for i = 1, string.len(line) do
    local c = line:sub(i, i)
    if c ~= " " and c ~= "\t" and c ~= "\r" then return false end
  end
  return true
end

--- Whether this line opens or closes a fenced code block.
local function is_fence(line)
  local trimmed = line
  while string.len(trimmed) > 0
      and (trimmed:sub(1, 1) == " " or trimmed:sub(1, 1) == "\t") do
    trimmed = trimmed:sub(2)
  end
  return trimmed:sub(1, 3) == "```" or trimmed:sub(1, 3) == "~~~"
end

--- The document as lines, without their terminators.
local function to_lines(document)
  local lines, pos = {}, 1
  while true do
    local at = document:find("\n", pos, true)
    if at == nil then
      lines[#lines + 1] = document:sub(pos)
      return lines
    end
    lines[#lines + 1] = document:sub(pos, at - 1)
    pos = at + 1
  end
end

--- The document as blocks, in order.
---
--- Split on blank lines, which is where Markdown itself ends a paragraph —
--- except inside a fence, where a blank line is part of the code and cutting
--- there would hand the model half a program.
---@param document string
---@return string[]
function M.split(document)
  local blocks, current, fenced = {}, {}, false

  local function flush()
    if #current == 0 then return end
    local text = table.concat(current, "\n")
    local empty = true
    for _, line in ipairs(current) do
      if not is_blank(line) then empty = false break end
    end
    if not empty then blocks[#blocks + 1] = text end
    current = {}
  end

  for _, line in ipairs(to_lines(document)) do
    if is_fence(line) then
      -- A fence opening ends whatever came before it: the paragraph above a
      -- code block is its own block, and handing the model both at once is
      -- what this split exists to avoid.
      if not fenced then flush() end
      fenced = not fenced
      current[#current + 1] = line
      if not fenced then flush() end
    elseif is_blank(line) and not fenced then
      flush()
    else
      current[#current + 1] = line
    end
  end
  flush()

  return blocks
end

--- Whether the block is only a heading line.
---
--- A heading on its own tells the model nothing about the register or the
--- subject it is translating: "## Results" could be a lab report or a football
--- table. It goes with the text under it.
local function is_heading(block)
  if block:sub(1, 1) ~= "#" then return false end
  return block:find("\n", 1, true) == nil
end

--- How much text one request carries, in characters.
---
--- A paragraph per request meant a request per paragraph: a long document
--- became dozens of round trips, each paying its own latency, for text that
--- would have fitted comfortably in one. Batching trades a slightly longer
--- wait for the first piece against a much shorter wait for the whole.
---
--- Not larger, because the point of splitting at all still holds: what fails
--- costs one batch and not the document, and the reader sees the beginning
--- while the end is still arriving.
M.BUDGET = 1500

--- Blocks grouped into requests, in order.
---
--- A block longer than the budget travels alone: it cannot be made smaller
--- without cutting a paragraph in half, which is what the split avoids.
---@param blocks string[]
---@param budget integer|nil
---@return string[]
function M.batch(blocks, budget)
  budget = budget or M.BUDGET
  local batches, current, size = {}, {}, 0

  local function flush()
    if #current == 0 then return end
    batches[#batches + 1] = table.concat(current, "\n\n")
    current, size = {}, 0
  end

  -- The decision is made when the next block arrives, never after adding one.
  -- Closing a batch the moment it filled meant a heading that came next had no
  -- batch left to join and started one of its own — alone, which is the thing
  -- the heading rule exists to prevent.
  for _, block in ipairs(blocks) do
    local length = string.len(block)
    -- A heading joins whatever it lands next to even when the budget is
    -- spent: on its own it tells the model nothing about register or subject.
    if size > 0 and size + length > budget and not is_heading(block) then
      flush()
    end
    current[#current + 1] = block
    size = size + length + 2
  end
  flush()

  return batches
end

return M
