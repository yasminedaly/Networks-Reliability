function [tt10,tt50, tt80, tt90, tt95] = percentiles(TT_OD)
    tt10 = prctile(TT_OD, 10, 3);
    tt50 = prctile(TT_OD, 50, 3);
    tt80 = prctile(TT_OD, 80, 3);
    tt90 = prctile(TT_OD, 90, 3);
    tt95 = prctile(TT_OD, 95, 3);

end
