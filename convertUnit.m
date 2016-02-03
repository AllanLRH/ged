function convertUnit(tickID, tickIDLabel, a)
  h = get(gca,tickID);
  set(gca,tickIDLabel,h*a);
