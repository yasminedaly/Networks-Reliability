numNodes = size(TT_link, 1);
numSamples = size(TT_link, 3);
KPIs = struct();

% Assume a free-flow speed of 15 km/h
free_flow_speed = 15; % km/h

for origin = 1:numNodes
    for destination = 1:numNodes
        if origin ~= destination
            od_travel_times = squeeze(TT_link(origin, destination, :));
            od_travel_times = od_travel_times(od_travel_times < Inf);

            if isempty(od_travel_times)
                continue;
            end

            % COV
            mean_travel_time = mean(od_travel_times);
            std_travel_time = std(od_travel_times);
            cov = std_travel_time / mean_travel_time;

            % Percentiles
            TT50 = prctile(od_travel_times, 50);
            TT80 = prctile(od_travel_times, 80);
            TT90 = prctile(od_travel_times, 90);
            TT95 = prctile(od_travel_times, 95);
            T5 = prctile(od_travel_times, 5); % For free-flow travel time

            % Variance
            variance_travel_time = var(od_travel_times);

            % Average Deviation
            average_deviation = mean(abs(od_travel_times - mean_travel_time));

            % Buffer Index
            B = TT95 - TT50; % Buffer time
            BI = B / mean_travel_time;

            % Planning Time Index
            T_free = T5; % Updated to use the 5th percentile as the free-flow travel time
            PTI = TT95 / T_free;

            % Misery Index
            MI = TT95;

            % UI_l - User Impact Index related to length (additional distance)
            % Calculated as the extra time (above the 5th percentile) converted to distance
            UI_l = (TT95 - T5) * free_flow_speed / 60; % convert to km

            % Probability of Exceedance
            probability_exceedance = mean(od_travel_times > (B + TT50));

            % Store KPIs
            KPIs.COV(origin, destination) = cov;
            KPIs.TT50(origin, destination) = TT50;
            KPIs.TT80(origin, destination) = TT80;
            KPIs.TT90(origin, destination) = TT90;
            KPIs.TT95(origin, destination) = TT95;
            KPIs.T5(origin, destination) = T5; % Store the 5th percentile as well
            KPIs.var(origin, destination) = variance_travel_time;
            KPIs.adev(origin, destination) = average_deviation;
            KPIs.BI(origin, destination) = BI;
            KPIs.PTI(origin, destination) = PTI;
            KPIs.MI(origin, destination) = MI;
            KPIs.UI_l(origin, destination) = UI_l; % Store UI_l
            KPIs.PrTTiBTT50(origin, destination) = probability_exceedance;

            fprintf('Origin: %d, Destination: %d\n', origin, destination);
            fprintf('COV: %f\n', KPIs.COV(origin, destination));
            fprintf('TT50: %f\n', KPIs.TT50(origin, destination));
            fprintf('TT80: %f\n', KPIs.TT80(origin, destination));
            fprintf('TT90: %f\n', KPIs.TT90(origin, destination));
            fprintf('TT95: %f\n', KPIs.TT95(origin, destination));
            fprintf('T5: %f\n', KPIs.T5(origin, destination)); % Print the 5th percentile
            fprintf('Variance: %f\n', KPIs.var(origin, destination));
            fprintf('Average Deviation: %f\n', KPIs.adev(origin, destination));
            fprintf('Buffer Index: %f\n', KPIs.BI(origin, destination));
            fprintf('Planning Time Index: %f\n', KPIs.PTI(origin, destination));
            fprintf('Misery Index: %f\n', KPIs.MI(origin, destination));
            fprintf('UI_l: %f\n', KPIs.UI_l(origin, destination)); % Print UI_l
            fprintf('Probability of Travel Time exceeding Buffer Time + TT50: %f\n\n', KPIs.PrTTiBTT50(origin, destination));
        end
    end
end

