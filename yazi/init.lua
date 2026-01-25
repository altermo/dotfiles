function Tabs.height() return 0 end

Header:children_add(function()
  if #cx.tabs == 1 then return "" end
  local spans = {}
  for i = 1, #cx.tabs do
    spans[#spans + 1] = ui.Span(" " .. i .. " ")
  end
  spans[cx.tabs.idx]:reverse()
  return ui.Line(spans)
end, 9000, Header.RIGHT)

Header:children_add(function(self)
  local h = self._current.hovered
  if h and h.link_to then
    return ui.Line{ui.Span(" . -> "),ui.Span(tostring(h.link_to)):fg('cyan')}
  else
    return
  end
end, 3300, Status.LEFT)
